// SPDX-License-Identifier: GPL-3.0
// pragma solidity ^0.8.4; // <<< correct version
pragma solidity >=0.4.17 <0.9.0; // !!! handler version just for local vscode

/**
 * Demo description:
 * Will contract defines grand father's Will to share his fortune with his chillderen
 *
 * contracts can be treated as "middleware" that triggered when
 * owning address calls it to perform an action in the blockchain.
 * When it's called, the action info avaible in object called msg
 *
 * msg is like "request payload" and it hodls the following values

msg.data (bytes calldata): complete calldata
msg.sender (address): sender of the message (current call)
msg.sig (bytes4): first four bytes of the calldata (i.e. function identifier)
msg.value (uint): number of wei sent with the message

* there are some more global objects with availble data related to the call

blockhash(uint blockNumber) returns (bytes32): hash of the given block when blocknumber is one of the 256 most recent blocks; otherwise returns zero
block.basefee (uint): current block’s base fee (EIP-3198 and EIP-1559)
block.chainid (uint): current chain id
block.coinbase (address payable): current block miner’s address
block.difficulty (uint): current block difficulty
block.gaslimit (uint): current block gaslimit
block.number (uint): current block number
block.timestamp (uint): current block timestamp as seconds since unix epoch
gasleft() returns (uint256): remaining gas
tx.gasprice (uint): gas price of the transaction
tx.origin (address): sender of the transaction (full call chain)

 *
 */

contract devWill {
    /**
     * -------------------------------
     * properties
     * -------------------------------
     */

    uint256 fortune;
    bool isDeceased;

    // In Solidity, address type comes with two flavors,
    // address and address payable (payable is modifier).
    // Both address and address payable stores the 20-byte values,
    // but address payable has additional members, .transfer() and .send()
    address owner; // define property of type "address"

    // this is how array type defined - []
    // array defined to hold addresses
    // payable = addreses that cab get payments
    // and called familyWallets
    // (in solidity all the items that can get payments defined as payable)
    address payable[] familyWallets;

    /**
     * -------------------------------
     * mappingw
     * -------------------------------
     * mapping() is Solidity's way to prepare variable that can handle key-value storage
     * ity is like an object or associaive array
     */
    // here we define a variable inheritance which will hold a map (assoc) of address and value

    // # - regular mapping
    mapping(address => uint256) inheritance;

    // # - mapping nesting mapping
    // mapping(address => mapping(address => bool)) approved;

    // # - mapping nesting array of ints
    // mapping(address => uint[]) scores;

    /**
     * -------------------------------
     * constructor
     * -------------------------------
     * constructor() is contract's initiation method like class initiation in OOP
     * the "payable" modifier used before addresses to defines address that can be payed
     * and in contract constructor context, it defines contract's address as payable as well.
     *
     * it means that the address of this contract, can acccept payment from the sender
     * and then it will be distrebuted basedon the wrriten bussiness logic.
     *
     * payable - means that you can transfer ether with the transaction.
     * If the contract is designed that it needs an ether deposit on construction, then you can not hard code this.
     * You have to allow the transaction sender to indeed send this ether to the contract.
     */
    constructor() public payable {
        // the "msg" is a object that available globally in the contract
        // it contains properties with data from the sender

        owner = msg.sender; // msg.sender represent the owning address that called the contract
        fortune = msg.value; // msg.value  represent the amount of eather being sent
        isDeceased = false; // let's keep thegrand father live at the beging
    }

    /**
     * -------------------------------
     * Modifiers
     * -------------------------------
     * @see: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb#:~:text=The%20Solidity%20documentation%20define%20a,to%20which%20it%20is%20attached.
     * In Solidity,
     * Modifiers express what actions are occurring in a declarative and readable manner.
     * They are similar to the decorator pattern used in Object Oriented Programming.
     * it is like a "mini-middlewares" that runs before functions triggred
     *
     * You can write a modifier with or without arguments. If the modifier does not have argument, you can omit the parentheses ()
     *
     *   modifier modifierWithArgs(uint a) { // ... }
     *   modifier modifierWithoutArgs() { // ... }
     *   modifier modifierWithoutArgs { // ... }
     *
     * Modifiers attached to function in the definitions row after the access level.
     * Multiple modifiers can be applied to a function. You can do this as follow:
     *
     * function doSomething() public modifierWithArgs(6) modifierWithoutArgs{
     *   // do function stuff after modifier checks
     * }
     *
     */

    /**
     * create a modifier so only person who can call the contract is the owner
     */
    modifier onlyOwner() {
        // the require() used to initiate required condition that must happen before moving on
        // a bit like if()
        require(msg.sender == owner);

        // _; this is a placeholder for the attached function to be executed
        // it's like a callback next() which process to the next function after the modifier is called
        // _; must be present in the modifer. you can use the placeholder _: few modifer times in modifer
        // e.g: ModifierWithArguments { logic ...  _;  more logic ... }
        _;
    }

    /**
     * create a modifier so that we only allocate founds if friend's grapms deceased
     */
    modifier mustBeDeceased() {
        require(isDeceased == true);
        _;
    }

    /**
     * -------------------------------
     * functions
     * -------------------------------
     * Function types come in four flavours — internal, external, public and private
     *
     * Internal - functions and state variables can only be accessed internally (i.e. from within the current contract or contracts deriving from it), without using this.
     *
     * External - functions are part of the contract interface, which means they can be called from other contracts and via transactions. An external function f cannot be called internally (i.e. f()does not work, but this.f() works). External functions are sometimes more efficient when they receive large arrays of data.
     *
     * Public - functions are part of the contract interface and can be either called internally or via messages. For public state variables, an automatic getter function is generated.
     *
     * Private - functions and state variables are only visible for the contract they are defined in and not in derived contracts.
     */

    // set inhertenace for each address
    // this action can be taken only by the owner (grampa, the fortune owner)
    // each address that the owner will set as payble for the inheitance,
    // will also be stored in familyWallets array which represnet family memebr per wallet
    function setInheritance(address payable wallet, uint256 amount)
        public
        onlyOwner // ! important modifier, the inheritance should be set only by the owner
    {
        familyWallets.push(wallet); //items can be added to array with .push() as in js

        // !!! NOTEs = the defualt value of the arg uint is 0
        // if your program shouldn't work with defualt value, you can use bool which which has defualt false

        // # create - entry in the pre-defined mapping
        inheritance[wallet] = amount;

        // # read - entry in the pre-defined mapping
        // inheritance[wallet];

        // # update - entry in the pre-defined mapping
        // inheritance[wallet] = newValue;

        // # dalate - entry from the pre-defined mapping
        // delete inheritance[wallet];
    }

    // handle the deceased trigger which will release the owner's Will
    // the function should be public so in the real world it will be able to edit the status,
    // however, not everyonw should be able to trigger it
    // here, for the demo onlyOwner modifier restrict access
    // in the real world it will be someone that represent the owner after he deceased
    // it can be also triggered automaticlly by oracle event
    // e.g: hospital confirmation, etc
    function deceased() public onlyOwner {
        isDeceased = true;
        payout(); // trigger the inheritence payout...
    }

    // pay each famility member based on wallet
    // private - the function is sprivate
    // mustBeDeceased modifier - the function triggered with the mustBeDeceased modifier = payout triggered only if grampa deceased
    function payout() private mustBeDeceased {
        // for loops used in the same way as in other langs
        // .length array prop exist in solidity just as in js
        for (uint256 i = 0; i < familyWallets.length; i++) {
            // grab the current familiy memeber wallet from the predefined familyWallets array
            address payable familyMemberWallet = familyWallets[i];

            // grab the current familiy memeber inheritance amount from the predefined list inheritance mapping
            uint256 familyMemberInheritance = inheritance[familyMemberWallet];

            // to transfer currancy to a wallet,
            // use an object of wallets type with the payable modifier
            // and it's build-in method .transfer(amount);
            familyMemberWallet.transfer(familyMemberInheritance); // transferring funds from contract address to reciever address
        }
    }
}
