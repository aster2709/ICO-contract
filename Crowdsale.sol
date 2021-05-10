// SPDX-License-Identifier: MIT 
pragma solidity ^0.8;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/smartcontractkit/chainlink/blob/master/evm-contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "./Whitelist.sol";
import "./QuillToken.sol";

contract ICO is Ownable {
    
    Whitelist whitelist;
    QuillToken token;
    enum StateChoices {Closed, Open, Paused}
    StateChoices state;
    uint minEntry = 500;
    uint ethUsdPrice;
    uint usdRaised;
    uint hardCap = 12500000;
    uint startTime = 1626287400;
    address payable wallet;
    
    event Buy(address indexed investor, uint timestamp);
    event HardCapHit(uint ethRaised, uint timestamp);
    
    modifier onState(StateChoices _state) {
        require(_state == state, "wrong state for this action");
        _;
    }
    
    constructor(
        address _whitelistAddress, 
        address _tokenAddress, 
        address payable _wallet, 
        address _priceFeedAddress
    ) {
        whitelist = Whitelist(_whitelistAddress);
        token = QuillToken(_tokenAddress);
        wallet = _wallet;
        ethUsdPrice = getPrice(_priceFeedAddress);
    }
    
    receive() external payable {
        buy();
    }
    
    function buy() public payable onState(StateChoices.Open) {
        uint weiAmount = msg.value;
        uint usdAmount = weiAmount * ethUsdPrice / 1e26;
        require(usdAmount > minEntry, "less than minimum entry");
        uint tokensToSend = usdAmount * 1e21;
        uint bonus = getBonus();
        if (bonus > 125) {
            state = StateChoices.Closed;
            require(bonus <= 125, "Crowdsale time is over");
        }
        usdRaised += usdAmount;
        if (usdRaised > hardCap) {
            uint excessAmount = usdRaised - hardCap;
            payable(msg.sender).transfer(excessAmount / ethUsdPrice * 1e26);
            uint validAmount = hardCap - (usdRaised - usdAmount);
            token.transfer(msg.sender, validAmount / ethUsdPrice * bonus * 1e27);
            wallet.transfer(address(this).balance);
            emit HardCapHit(address(this).balance, block.timestamp);
            state = StateChoices.Closed;
        } else {
            token.transfer(msg.sender, tokensToSend * bonus / 100);
        }
        emit Buy(msg.sender, block.timestamp);
    }
    function setState(StateChoices _state) external onlyOwner {
        state = _state;
    }
    function getPrice(address _priceFeedAddress) internal view returns (uint) {
        (, int price,,,) = AggregatorV3Interface(_priceFeedAddress).latestRoundData();
        return uint(price);
    }
    function getBonus() internal view returns(uint) {
        require((block.timestamp - startTime) > 0, "Not yet stared");
        uint currTime = block.timestamp - startTime;
        if (currTime >= 62 days) {
            return 999;
        } else if (currTime >= 54 days) {
            return 100;
        } else if (currTime >= 46 days) {
            return 105;
        } else if (currTime >= 38 days) {
            return 110;
        } else if (currTime >= 30 days) {
            return 115;
        } else if (currTime >= 16 days && currTime <= 30 days) {
            return 120;
        } else if (currTime <= 15 days) {
            return 125;
        }
        return 0;
    }
    function setEthUsdWeeklyPrice(uint _price) public onlyOwner {
        ethUsdPrice = _price;
    }
}