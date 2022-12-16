pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/SafeERC20.sol";

contract OnChainBridge {
  using SafeMath for uint256;

  address public owner;
  uint public lockupPeriod; // time in blocks that tokens must be locked up before they can be transferred to the other blockchain
  address public tokenContract; // address of the token contract on the first blockchain
  address public otherTokenContract; // address of the token contract on the second blockchain

  constructor(address _tokenContract, address _otherTokenContract, uint _lockupPeriod) public {
    owner = msg.sender;
    tokenContract = _tokenContract;
    otherTokenContract = _otherTokenContract;
    lockupPeriod = _lockupPeriod;
  }

  function transfer(address _recipient, uint _amount) public {
    // Ensure that the caller has the necessary permissions to initiate a transfer
    require(msg.sender == owner, "Only the owner can initiate a transfer.");

    // Ensure that the recipient is a valid Ethereum address
    require(_recipient != address(0), "Invalid recipient address.");

    // Transfer the specified amount of tokens from the first blockchain to the bridge contract
    SafeERC20(tokenContract).safeTransferFrom(msg.sender, address(this), _amount);

    // Lock up the transferred tokens for the specified lockup period
    transferLockup[_recipient] = block.number + lockupPeriod;
  }

  function unlock(address _recipient, uint _amount) public {
    // Ensure that the caller is the recipient of the locked-up tokens
    require(msg.sender == _recipient, "Only the recipient can unlock the tokens.");

    // Ensure that the lockup period has expired
    require(block.number >= transferLockup[_recipient], "The lockup period has not yet expired.");

    // Transfer the specified amount of locked-up tokens to the recipient's account on the second blockchain
    SafeERC20(otherTokenContract).safeTransfer(_recipient, _amount);

    // Remove the lockup period for the transferred tokens
    delete transferLockup[_recipient];
  }

  mapping(address => uint) public transferLockup;
}
