// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import './ProjectNFT.sol';
import "truffle/Console.sol";

contract AccessSmartContract {
    ProjectNFT private projectNFT;

    // Maps owner address to bought tokens
    mapping(address => mapping(uint256 => bool)) private _addressToTokens;

    // Maps ownership to expiration date
    // Key is hash of tuple (address, uint256) for address of owner and tokenId
    // See https://stackoverflow.com/questions/56292828/can-i-use-tuple-as-a-key-in-mapping
    mapping(bytes32 => uint256) private _ownershipExpirationTime;
    
    constructor(address projectNFTAddress){
        projectNFT = ProjectNFT(projectNFTAddress);
    }

    function buyProject(uint256 tokenId, address ownerAddress) public payable returns (address) {
        // TODO require token exists;
        projectNFT.getTokenPrice(tokenId); //check if token exists

        console.log("Starting buy for token ", tokenId);

        console.log("With amount ", msg.value);

        console.log("From address ", ownerAddress);

        console.log("msg.value", msg.value);
        console.log("projectNFT.getTokenBuyPrice(tokenId,ownerAddress)", projectNFT.getTokenBuyPrice(tokenId,ownerAddress));


        require(msg.value >= projectNFT.getTokenBuyPrice(tokenId,ownerAddress), 
            'Need to pay buy price to buy token');

        console.log("Checks passed, will call transfer payment");

        // Pay projects owner
        //projectNFT.transferPayment(tokenId, msg.value, ownerAddress);
        projectNFT.transferPayment{value: msg.value}(tokenId, ownerAddress);
        

        console.log("Payed creators, will set ownership");

        // Set ownership
        _addressToTokens[ownerAddress][tokenId] = true;

        // Set expiration time
        uint256 expirationTime = block.timestamp + 60*60*24*31*3; // add 3 months
        _ownershipExpirationTime[keccak256(abi.encodePacked(ownerAddress, tokenId))] = expirationTime;

        return ownerAddress;
    }
}
