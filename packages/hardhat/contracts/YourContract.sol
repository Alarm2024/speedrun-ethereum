// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

import "hardhat/console.sol";

/**
 * @title YourContract
 * @dev A smart contract that allows changing a state variable and tracking the changes.
 * Optimized for gas efficiency using Custom Errors.
 */
contract YourContract {
    // State Variables
    address public immutable owner;
    string public greeting = "Building Unstoppable Apps!!!";
    bool public premium = false;
    uint256 public totalCounter = 0;
    
    mapping(address => uint256) public userGreetingCounter;

    // Custom Errors (Gas efficient way to handle errors)
    error Unauthorized();
    error TransferFailed();

    // Events
    event GreetingChange(address indexed greetingSetter, string newGreeting, bool premium, uint256 value);

    // Constructor: Called once on contract deployment
    constructor(address _owner) {
        owner = _owner;
    }

    // Modifier using Custom Error for better gas optimization
    modifier isOwner() {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        _;
    }

    /**
     * @notice Allows anyone to change the state variable "greeting" and increase counters
     * @param _newGreeting The new greeting to save on the contract
     */
    function setGreeting(string memory _newGreeting) public payable {
        console.log("Setting new greeting '%s' from %s", _newGreeting, msg.sender);

        // Change state variables
        greeting = _newGreeting;
        totalCounter += 1;
        userGreetingCounter[msg.sender] += 1;

        if (msg.value > 0) {
            premium = true;
        } else {
            premium = false;
        }

        emit GreetingChange(msg.sender, _newGreeting, msg.value > 0, msg.value);
    }

    /**
     * @notice Allows the owner to withdraw all the Ether in the contract
     */
    function withdraw() public isOwner {
        (bool success, ) = owner.call{ value: address(this).balance }("");
        if (!success) {
            revert TransferFailed();
        }
    }

    /**
     * @notice Fallback function to allow the contract to receive ETH
     */
    receive() external payable {}
}
