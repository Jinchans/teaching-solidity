pragma solidity ^0.8.17;

// secret santa smart contract where users donate to another random participant.

contract SecretSanta {
    // Struct to store information about each participant
    struct Participant {
        address addr; // Ethereum address of the participant
        uint256 donated; // Amount donated by the participant
    }

    // Mapping to store the list of participants
    mapping(address => Participant) public participants;

    // Add a new participant to the game
    function joinGame(uint256 _donation) public {
        // Add the participant to the list
        participants[msg.sender] = Participant(msg.sender, _donation);
    }

    // Make a donation to another random participant
    function donate() public {
        // Get a list of all the participant addresses
        address[] memory addresses = new address[](participants.length);
        uint256 i = 0;
        for (address addr in participants) {
            addresses[i] = addr;
            i++;
        }

        // Select a random participant to donate to
        uint256 randIndex = randomIndex(addresses.length);
        address recipient = addresses[randIndex];

        // Make the donation
        participants[msg.sender].donated += 1;
        participants[recipient].donated += 1;
    }

    // Retrieve information about a specific participant
    function getParticipant(address _addr) public view returns (address, uint256) {
        return (participants[_addr].addr, participants[_addr].donated);
    }

    // Generate a random index for an array
    function randomIndex(uint256 _length) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(now, msg.sender, _length))) % _length;
    }
}
