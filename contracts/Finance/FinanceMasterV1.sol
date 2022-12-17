// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./helpers/Ownable.sol";
import "./helpers/SafeBEP20.sol";
import "./helpers/SafeMath.sol";
import "./helpers/TradeHelper.sol";
import "./helpers/IMasterChef.sol";


interface IHonorFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

contract FinanceMasterV1 is Ownable {

    using SafeMath for uint256;

    address public _busd;
    address public _wbnb;
    address public _honor;
    address public _hnrusd;
    address public _routerHonor;
    address public _router1;
    address public _router2;
    IHonorFactory public _factory;


    mapping(address => uint256) public financeAdmins;

    constructor(address busd,address wbnb,address honor,address hnrusd,address factory) public {
        _busd=busd;
        _wbnb=wbnb;
        _honor=honor;
        _hnrusd=hnrusd;
        _factory=IHonorFactory(factory);
    }
    receive() external payable {}
    
    function addFinanceAdmin(address admin) public onlyOwner {
        require(Address.isContract(admin)==true,"Only Contract");
        financeAdmins[admin]=100;
    }
    function deleteFinanceAdmin(address admin) public onlyOwner {
        require(Address.isContract(admin)==true,"Only Contract");
        financeAdmins[admin]=0;
    }


    function setRouters(address routerHonor,address router1,address router2) public onlyOwner {
        _routerHonor=routerHonor;
        _router1=router1;
        _router2=router2;
        setAllApprove();
    }

    function setAllApprove() public {
        SafeBEP20.safeApprove(IBEP20(_busd), _routerHonor, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_hnrusd), _routerHonor, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_wbnb), _routerHonor, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_honor), _routerHonor, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_busd), _router1, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_hnrusd), _router1, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_wbnb), _router1, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_honor), _router1, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_busd), _router2, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_hnrusd), _router2, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_wbnb), _router2, uint256(-1));
        SafeBEP20.safeApprove(IBEP20(_honor), _router2, uint256(-1));
    }

    function _removeLiquidity(address router,address tokenA,address tokenB,uint amount) private {
        IUniswapV2Router(router).removeLiquidity(tokenA, tokenB, amount, 0, 0, address(this), block.timestamp);
    }
  
    function depositToken(address token,uint256 amount) public {
        SafeBEP20.safeTransferFrom(IBEP20(token),msg.sender,address(this),amount);
    }

    function recoverToken(address token,uint256 amount) public onlyOwner {
        SafeBEP20.safeTransfer(IBEP20(token), msg.sender, amount);
    }

    function buyAddLiquidty(address tokenRes,address tokenBuy,uint256 amount) public onlyOwner {
        _swap(tokenRes,tokenBuy,amount);
        uint256 liqAmount=IBEP20(tokenRes).balanceOf(address(this));

        IUniswapV2Router(_routerHonor).addLiquidity(tokenRes, tokenBuy, liqAmount, uint256(-1), 0, 0, address(this), block.timestamp+300);
    }

    
    function swapAdmin(address tokenIn,address tokenOut,uint256 amount) public onlyOwner {
        address  router=TradeHelper.checkAmountMin(_routerHonor,_router1,tokenIn,tokenOut,amount);
        router=TradeHelper.checkAmountMin(router, _router2, tokenIn, tokenOut, amount);

        address[] memory path;
        path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        
        IUniswapV2Router(router).swapExactTokensForTokens(amount, 1, path, address(this), block.timestamp);
    }
    
function tradeAdmin(
        address token1,
        address token2,
        uint256 amountIn) public onlyOwner {
            
            address  router=TradeHelper.checkAmountMin(_routerHonor,_router1,token1,token2,amountIn);
        router=TradeHelper.checkAmountMin(router, _router2, token1, token2, amountIn);
            
            uint256 deadline = block.timestamp + 2 minutes;
            address[] memory path = new address[](2);
            path[0] = token1;
            path[1] = token2;
            uint256[] memory amountsOut = IUniswapV2Router(router).getAmountsOut(amountIn, path);
            uint256  amountOutMin = amountsOut[1];
            IUniswapV2Router(router).swapExactTokensForTokens(
                amountIn,
                amountOutMin,
                path,
                msg.sender,
                deadline);
    }

   function _swap(address tokenIn,address tokenOut,uint256 amount) private {
        address  router=TradeHelper.checkAmountMin(_routerHonor,_router1,tokenIn,tokenOut,amount);
        router=TradeHelper.checkAmountMin(router, _router2, tokenIn, tokenOut, amount);

        address[] memory path;
        path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        
        uint256[] memory amountsOut=IUniswapV2Router(router).getAmountsOut(amount, path);
        IUniswapV2Router(router).swapExactTokensForTokens(amount, amountsOut[1], path, address(this), block.timestamp+300);
   }

   function checkAmount(address tokenIn,address tokenOut,uint256 amount) public onlyOwner view returns(address) {
        return TradeHelper.checkAmountMin(_routerHonor,_router1,tokenIn,tokenOut,amount);
   }

}
