// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract customWill {
    // define properties
    uint256 fortune;
    bool isDeceased;
    address owner;
    address payable[] familyWallets;
    mapping(address => uint256) inheritance;

    /**
     * set initial properties
     */
    constructor() payable {
        owner = msg.sender;
        fortune = msg.value;
        isDeceased = false;
    }

    /**
     * define owner condition
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * deceased status checker
     */
    modifier mustBeDeceased() {
        require(isDeceased == true);
        _;
    }

    /**
     * set fortune inheritance payouts
     */
    function setInheritance(address payable wallet, uint256 amount)
        public
        onlyOwner // ! important modifier, the inheritance should be set only by the owner
    {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    /**
     * trieger fortune inheritance payouts
     */
    function deceased() public onlyOwner {
        isDeceased = true;
        payout(); // trigger the inheritence payout...
    }

    /**
     * process fortune inheritance payouts
     */
    function payout() private mustBeDeceased {
        for (uint256 i = 0; i < familyWallets.length; i++) {
            // grab the current familiy memeber wallet from the predefined familyWallets array
            address payable familyMemberWallet = familyWallets[i];

            // grab the current familiy memeber inheritance amount from the predefined list inheritance mapping
            uint256 familyMemberInheritance = inheritance[familyMemberWallet];

            // transferring funds from contract address to reciever address
            familyMemberWallet.transfer(familyMemberInheritance);
        }
    }
}