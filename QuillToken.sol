//SPDX-License-Identifier: MIT 
pragma solidity ^0.8;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract QuillToken is ERC20 {
    uint public totalSupply_ = 50000000000;
    uint reserve = 30;
    uint interestPayout = 20;
    uint HR = 10;
    uint generalFund = 13;
    uint airDrops = 2;
    uint ICO = 25;
    
    event TokenDeployed(address indexed deployer, uint timestamp);
    
    constructor(
        address _reserve, 
        address _interestPayout, 
        address _HR, 
        address _generalFund, 
        address _airDrops,
        address _ICOContract
    ) ERC20('QuillToken', 'QLL') {
        _mint(_reserve, reserve * totalSupply_ * 1e16);
        _mint(_interestPayout, interestPayout * totalSupply_ * 1e16);
        _mint(_HR, HR * totalSupply_ * 1e16);
        _mint(_generalFund, generalFund * totalSupply_ * 1e16);
        _mint(_airDrops, airDrops * totalSupply_ * 1e16);
        _mint(_ICOContract, ICO * totalSupply_ * 1e16);
        emit TokenDeployed(msg.sender, block.timestamp);
    }
}