// SPDX-License-Identifier: GPL-3.0
// pragma solidity >=0.7.0 <0.9.0; // <<< correct version
pragma solidity >=0.4.17 <0.9.0; // !!! handler version just for local vscode

/**
 * contract defines as object prefixed with the "contract' keyword as classes
 * you can treat such contracts as "middleware" that triggered when
 * owning address calls it
 */
contract simeplStorage {
    // each contract can have properties
    // props should be defined with <propType> <propVar>
    uint256 storeData = 23; // "uint" is int
    string names = "tom";
    bool switchON = true;

    // functions defined with the keyword "function" and the name of the function as in other langs
    // the access level defined after the arguments
    // functions can be private or public
    function set(uint256 x) private {
        storeData = x;
    }

    /*
        * Functions that returns values should be declared with the return and the type 
        
        * View functions ensure that they will not modify the state. 
          A function can be declared as view (after the access level: public view)
          The following statements if present in the function are considered modifying the state and compiler will throw warning in such cases.
        *- Modifying state variables.
        *- Emitting events.
        *- Creating other contracts.
        *- Using selfdestruct.
        *- Sending Ether via calls.
        *- Calling any function which is not marked view or pure.
        *- Using low-level calls.
        *- Using inline assembly containing certain opcodes    
    */
    function get() public view returns (uint256) {
        return storeData;
    }
}
