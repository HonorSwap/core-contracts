// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;




import "./helpers/Ownable.sol";
import "./helpers/SafeBEP20.sol";

contract FinanceHnrUsd is Ownable
{
    using SafeMath for uint256;

    IBEP20 public _busdToken;
    IBEP20 public _husdToken;
    IBEP20 public _xhnrToken;
    address public _feeTo;

    uint256 public _FEE=50;

    constructor(address busd,address husd,address xhnrToken,address feeTo) public {
        _busdToken=IBEP20(busd);
        _husdToken=IBEP20(husd);
        _xhnrToken=IBEP20(xhnrToken);
        _feeTo=feeTo;
    }

    function setFeeTo(address feeTo) public onlyOwner {
        _feeTo=feeTo;
    }

    function setFee(uint256 _fee) public onlyOwner {
        _FEE=_fee;
    }
    function hUSDBalance() public view returns(uint256) {
        return _husdToken.balanceOf(address(this));
    }
    function bUSDBalance() public view returns(uint256) {
        return _busdToken.balanceOf(address(this));
    }

    /*
    User sent HNRUSD to Contract get BUSD 
    User send xHonor Token to Contract amount x 1500
    */
    function buyBUSD(uint256 amount) public {
        uint256 busdAmount=_busdToken.balanceOf(address(this));
        require(busdAmount>=amount,"Not amount");

        uint256 fee=amount.mul(_FEE).div(100000);
        
        uint256 curAmount=amount.mul(1500);

        SafeBEP20.safeTransferFrom(_xhnrToken, msg.sender, address(this),curAmount);
        SafeBEP20.safeTransferFrom(_husdToken, msg.sender, address(this), amount);
        SafeBEP20.safeTransfer(_husdToken, _feeTo, fee);

        curAmount=amount.sub(fee);
        SafeBEP20.safeTransfer(_busdToken, msg.sender, curAmount);
    }

    /*
    User sent BUSD to Contract get HNRUSD 
    Contract send xHonor Token to User amount x 1000
    */
    function buyHUSD(uint256 amount) public {
        uint256 husdAmount=_husdToken.balanceOf(address(this));
        require(husdAmount>=amount,"Not Amount");


        uint256 fee=amount.mul(_FEE).div(100000);

        SafeBEP20.safeTransferFrom(_busdToken, msg.sender, address(this), amount);
        SafeBEP20.safeTransfer(_busdToken, _feeTo, fee);

        uint256 curAmount=amount.sub(fee);
        SafeBEP20.safeTransfer(_husdToken, msg.sender, curAmount);

        curAmount=amount.mul(1000);
        SafeBEP20.safeTransfer(_xhnrToken, msg.sender, curAmount);
    }

}