pragma solidity ^0.8.17;

// goal is to create a more gas efficient swap. On a dex 2 users submit transactions which are mined in seperate blocks.
// In this method with the help of a relayer both tx's in the swap are mined in the same block and overall 50% less expensive gas fee on the network.

contract GaslessSwap {
    // The tokens being swapped
    address private tokenA;
    address private tokenB;

    // The addresses of the parties involved in the swap
    address private alice;
    address private bob;

    // Flag to track whether both parties have agreed to the terms of the swap
    bool private agreed;

    constructor(address _tokenA, address _tokenB) public {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    // Function for Alice to deposit her tokens with the relayer
    function depositA(uint256 amount) public {
        require(tokenA.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }

    // Function for Bob to deposit his tokens with the relayer
    function depositB(uint256 amount) public {
        require(tokenB.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }

    // Function for Alice and Bob to agree to the terms of the swap
    function agree() public {
        require(msg.sender == alice || msg.sender == bob, "Only Alice or Bob can agree");
        agreed = true;
    }

    // Function to execute the swap
    function execute() public {
        require(agreed, "Both parties must agree before executing the swap");
        require(tokenA.transfer(bob, amountA), "Transfer failed");
        require(tokenB.transfer(alice, amountB), "Transfer failed");
    }
}
