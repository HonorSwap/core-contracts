// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;


import "./helpers/Ownable.sol";
import "./helpers/SafeBEP20.sol";

import "./helpers/IHonorController.sol";
import "./helpers/IFinanceMaster.sol";

interface IUniswapV2Pair {
  function token0() external view returns (address);
  function token1() external view returns (address);
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

contract InvestHonor is Ownable
{
    using SafeMath for uint256;

    address public _honor;
    address public _pairBUSDHONOR;
    IHonorController public _honorController;
    IFinanceMaster public _financeMaster;

    //
    uint256 public YEAR_INTEREST=33295281583;
    uint256 public SIXMONTH_INTEREST=3000;
    uint256 public THREEMONTH_INTEREST=2500;
    uint256 public MONTH_INTEREST=2000;

    struct Treasure {
        uint256 interest;
        uint256 amount;
        uint start_time;
        uint duration;
        uint112 busdRes;
        uint112 honorRes;
    }

    mapping(address=>Treasure) public userTreasures;


    constructor(address financeMaster,address honor,address controller,address pair) public {
        _honor=honor;
        _honorController=IHonorController(controller);
        _financeMaster=IFinanceMaster(financeMaster);
        _pairBUSDHONOR=pair;
    }

    function setInterests(uint256 year,uint256 sixmonth,uint256 threemonth,uint256 month) public onlyOwner {
        YEAR_INTEREST=year;
        SIXMONTH_INTEREST=sixmonth;
        THREEMONTH_INTEREST=threemonth;
        MONTH_INTEREST=month;
    }

    function deposit(uint256 amount,uint duration ) public {
        Treasure storage user=userTreasures[msg.sender];
        require(user.duration==0,"CURRENT DEPOSITED");
        uint interest=getInterest(duration);
        require(interest>0,"NOT TIME");

        user.interest=interest;
        user.start_time=block.number;
        user.duration=duration;
        user.amount=amount;
        (uint112 busdRes,uint112 honorRes,)=IUniswapV2Pair(_pairBUSDHONOR).getReserves();
        user.busdRes=busdRes;
        user.honorRes=honorRes;

        SafeBEP20.safeTransferFrom(IBEP20(_honor), msg.sender, address(this), amount);
        _financeMaster.depositHonor(amount);
    }

    function getInterest(uint duration) public view returns(uint256) {
        if(duration>=10512000) //Year
        {
            return YEAR_INTEREST;
        }
        if(duration>=5184000)//Six Month
        {
            return SIXMONTH_INTEREST;
        }
        if(duration>=2592000)
        {
            return THREEMONTH_INTEREST;
        }
        if(duration>=864000)
        {
            return MONTH_INTEREST;
        }
        return 0;
    }

    function widthdraw() public {
        /*
        Treasure storage user=userTreasures[msg.sender];
        require(user.duration>0,"NOT DEPOSIT");
        uint last=user.start_time+user.duration;
        require(block.number>=last,"NOT TIME");
        //Devam Edecek
        uint256 honorRes=uint256(user.honorRes);
        uint256 busdRes=uint256(user.busdRes);
    //Devam Edecek
*/
    }
}