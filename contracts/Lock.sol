// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Lottery {

    struct Ticket {
        uint id;
        address owner;
    }

    address owner;
    mapping(uint => Ticket) private   tickets;
    uint public currentTicketId  = 0;
    uint public ticketAmount = 2;

    constructor(){
        owner = msg.sender;
    }

    function buyTicket () external payable  {
        require(currentTicketId < ticketAmount, "No more tickets left(((" );
        require(msg.value == 1 ether, "Pay ether for a ticket!" );
        Ticket memory newTicket = Ticket({
            id: currentTicketId,
            owner: msg.sender
        });
        tickets[currentTicketId] = newTicket;

        currentTicketId++;
    } 

    function getRandomTicketId(uint max) private  view returns (uint) {
        uint randomHash = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        return randomHash % max;
    }

    function drawLottery () external payable   {
        require(currentTicketId == ticketAmount, "A few tickets left");
        uint winnerTicketId = getRandomTicketId(ticketAmount - 1);
        address payable winnerAddress = payable(tickets[winnerTicketId].owner);
        (bool sentWinCheck,) = winnerAddress.call{value: (address(this).balance * 9) / 10}("");
        (bool sentFeeCheck,) = owner.call{value: (address(this).balance)}("");
        require(sentWinCheck, "Failed to send ether to winner");
        require(sentFeeCheck, "Failed to send fee");
    }

}
