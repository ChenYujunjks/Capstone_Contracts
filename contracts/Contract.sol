// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MyContract {
    struct Message {
        address from;
        address to;
        string content;
        uint256 timestamp;
    }

    mapping(address => Message[]) private receivedMessages;

    event MessageSent(address indexed from, address indexed to, string content, uint256 timestamp);
    event DebugMessageStored(address indexed to, uint256 messageCount);

    function sendMessage(address _to, string calldata _content) external {
        require(_to != address(0), "Invalid recipient address");
        require(bytes(_content).length > 0, "Message content cannot be empty");

        Message memory newMessage = Message(msg.sender, _to, _content, block.timestamp);

        receivedMessages[_to].push(newMessage);

        emit MessageSent(msg.sender, _to, _content, block.timestamp);

        emit DebugMessageStored(_to, receivedMessages[_to].length);
    }

    function receiveMessagesContentWithSender(address _address) external view returns (string[] memory, address[] memory) {
        uint256 messageCount = receivedMessages[_address].length;
        string[] memory contents = new string[](messageCount);
        address[] memory senders = new address[](messageCount);

        for (uint256 i = 0; i < messageCount; i++) {
            contents[i] = receivedMessages[_address][i].content;
            senders[i] = receivedMessages[_address][i].from;
        }

        return (contents, senders);
    }
    

}