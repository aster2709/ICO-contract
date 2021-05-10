//SPDX-License-Identifier: MIT 
pragma solidity ^0.8;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract Whitelist is Ownable {
    mapping (address => bool) public whitelist;
    
    event AddedToWhitelist(address indexed investor, uint timestamp);
    event RemovedFromWhitelist(address indexed investor, uint timestamp);
    
    function addTowhitelist(address _investor) external {
        require(!whitelist[_investor], 'investor already whitelisted');
        whitelist[_investor] = true;
        emit AddedToWhitelist(_investor, block.timestamp);
    }
    
    function removeFromWhitelist(address _investor) external {
        require(whitelist[_investor], "investor not found in whiteist");
        whitelist[_investor] = false;
        emit RemovedFromWhitelist(_investor, block.timestamp);
    }
}