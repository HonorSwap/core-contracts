// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./helpers/Ownable.sol";
import "./helpers/SafeBEP20.sol";

contract HNRUSDController is Ownable {
    using SafeMath for uint256;
    using SafeBEP20 for IBEP20;

    struct StableToken {
        uint256 deposited;
        uint256 withdrawn;
        uint256 fee;
        bool active;
    }

    mapping(address => StableToken) public stableTokens;

    IBEP20 public husdToken;
    address public feeTo;

    uint256 public defaultFee = 200;

    event BuyHNRUSD(address indexed token, uint256 amount);
    event SellHNRUSD(address indexed token, uint256 amount);
    event StableSwap(address indexed tokenIn, address indexed tokenOut, uint256 amount);

    constructor(address husd, address _feeTo) public {
        husdToken = IBEP20(husd);
        feeTo = _feeTo;
    }

    modifier tokenIsActive(address token) {
        require(stableTokens[token].active, "Token is not active");
        _;
    }

    function setFeeTo(address _feeTo) public onlyOwner {
        feeTo = _feeTo;
    }

    function setFee(address token, uint256 _fee) public onlyOwner {
        StableToken storage stable = stableTokens[token];
        stable.active = true;
        stable.fee = _fee;
    }

    function addStable(address token, uint256 _fee) public onlyOwner {
        StableToken storage stable = stableTokens[token];
        stable.active = true;
        stable.fee = _fee;
    }

    function setActive(address token, bool _active) public onlyOwner {
        StableToken storage stable = stableTokens[token];
        stable.active = _active;
    }

    function calculateFee(address token, uint256 amount) public view returns (uint256) {
        uint256 tokenFee = stableTokens[token].fee == 0 ? defaultFee : stableTokens[token].fee;
        uint256 minAmount = 1000 * (10 ** 18);

        if (amount <= minAmount) {
            return tokenFee;
        } else if (amount > minAmount && amount <= (minAmount * 10)) {
            return tokenFee.mul(4).div(5);
        } else if (amount > (minAmount * 10) && amount <= (minAmount * 25)) {
            return tokenFee.mul(3).div(5);
        } else if (amount > (minAmount * 25) && amount <= (minAmount * 100)) {
            return tokenFee.mul(2).div(5);
        } else if (amount > (minAmount * 100)) {
            return tokenFee.div(5);
        }
    }

    function sellHNRUSD(address token, uint256 amount) public tokenIsActive(token) {
        IBEP20 sToken = IBEP20(token);
        uint256 balance = sToken.balanceOf(address(this));
        require(balance >= amount, "Not enough balance");

        StableToken storage stable = stableTokens[token];
        uint256 sFEE = stable.fee == 0 ? defaultFee : stable.fee;

        husdToken.safeTransferFrom(msg.sender, address(this), amount);

        uint256 fee = amount.mul(sFEE).div(100000);

        sToken.safeTransfer(feeTo, fee);

        uint256 curAmount = amount.sub(fee);
        sToken.safeTransfer(msg.sender, curAmount);

        stable.withdrawn = stable.withdrawn.add(amount);

        emit SellHNRUSD(token, amount);
    }

    function buyHNRUSD(address token, uint256 amount) public tokenIsActive(token) {
        uint256 husdAmount = husdToken.balanceOf(address(this));
        require(husdAmount >= amount, "Not enough amount");

        StableToken storage stable = stableTokens[token];

        uint256 sFEE = calculateFee(token, amount);

        IBEP20 sToken = IBEP20(token);
        sToken.safeTransferFrom(msg.sender, address(this), amount);

        uint256 fee = amount.mul(sFEE).div(100000);

        sToken.safeTransfer(feeTo, fee);

        uint256 curAmount = amount.sub(fee);

        husdToken.safeTransfer(msg.sender, curAmount);

        stable.deposited = stable.deposited.add(amount);

        emit BuyHNRUSD(token, amount);
    }

    function stablesSwap(address stIn, address stOut, uint256 amount) public tokenIsActive(stIn) tokenIsActive(stOut) {
        require(IBEP20(stOut).balanceOf(address(this)) >= amount, "Not enough balance");

        IBEP20(stIn).safeTransferFrom(msg.sender, address(this), amount);

        uint256 totalFee = calculateFee(stIn, amount).add(calculateFee(stOut, amount)).mul(2);
        uint256 feeAmount = amount.mul(totalFee).div(100000);

        IBEP20(stIn).safeTransfer(feeTo, feeAmount);

        uint256 finalAmount = amount.sub(feeAmount);
        IBEP20(stOut).safeTransfer(msg.sender, finalAmount);

        stableTokens[stIn].deposited = stableTokens[stIn].deposited.add(amount);
        stableTokens[stOut].withdrawn = stableTokens[stOut].withdrawn.add(amount);

        emit StableSwap(stIn, stOut, amount);
    }

    function getReserves(address token) public onlyOwner {
        StableToken memory stable = stableTokens[token];
        require(stable.deposited == 0, "Stable Token can't be received");
        IBEP20(token).safeTransfer(msg.sender, IBEP20(token).balanceOf(address(this)));

    }
}