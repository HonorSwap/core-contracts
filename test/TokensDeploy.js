const {
    time,
    loadFixture,
  } = require("@nomicfoundation/hardhat-network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
const { ethers } = require("hardhat");

const tokens={
    honor:undefined,
    busd:undefined,
    usdt:undefined,
    honorbar:undefined,
    xHonor:undefined,
    usdc:undefined,
    wbnb:undefined,
    factory:undefined
}

const _financeMaster="0xd1Dd193Ed1812c3B17950E1DbF772a15f2B004a8";
const _routerHonor="0x2C0648017f0162E4C87C3ff215918783DdCd53c3";
const _routerPancake1="0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
const _routerPancake2="0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3";

function parseETH(val) {
    return ethers.utils.parseEther(val);
}
async function getBlock() {
    return await ethers.provider.getBlock("latest")
   }
    async function pancakeTest() {
        const routerAddress="0xD99D1c33F9fC3444f8101754aBC46c52416550D1";
        const [owner]=await ethers.getSigners();

        const router=await ethers.getContractFactory("contracts/HonorRouter.sol:HonorRouter");
        const Router=router.attach(routerAddress);

        const busd=await ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
        const BUSD=busd.attach("0x388672B44fD9370EAae35Ccc7A4a32F10b54da62");

        const honor=await ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
        const Honor=honor.attach("0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93");

        const block=await getBlock();
   
        const deadline=block.timestamp;
        const amountA=parseETH("10");
        const gas=await Router.addLiquidity(BUSD.address,Honor.address,amountA,amountA,0,0,owner.address,deadline);

        console.log(gas);
        
    }

    async function approveTokensFinanceMaster() {
        const busd=await ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
        const BUSD=busd.attach("0x388672B44fD9370EAae35Ccc7A4a32F10b54da62");

        const honor=await ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
        const Honor=honor.attach("0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93");

        const uintMAX=ethers.constants.MaxUint256;
        const financeMaster="0x5507Fe0EFb15f70bD5490B5c2E44aE4C2bE5Dc1B";
        await BUSD.approve(financeMaster,uintMAX);
        await Honor.approve(financeMaster,uintMAX);
    }

    async function depositTokenFinanceMaster() {
        const financeMaster=await ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
        const fM1=financeMaster.attach("0x4bB6F4E288d59298fA0B7233c1Cdd8b47A9Fee54");

    }
  describe("Test BSC", function() {

    
    async function testFinanceMaster() {
        const [owner]=await ethers.getSigners();
        const financeMaster="0xA0b6085FCE22403cAF04322249723c424D05f103";
        const fmV1=await ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
        fmV1.attach(financeMaster);

        const router=await ethers.getContractFactory("contracts/HonorRouter.sol:HonorRouter");
        const Router=router.attach("0x2C0648017f0162E4C87C3ff215918783DdCd53c3");

        const busd=await ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
        const BUSD=busd.attach("0x388672B44fD9370EAae35Ccc7A4a32F10b54da62");

        const honor=await ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
        const Honor=honor.attach("0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93");

   

        const block=await getBlock();
        const amountA=parseETH("100");
        const deadline=block.timestamp+300;

       //console.log(block);

        const gas=await Router.addLiquidity(BUSD.address,Honor.address,amountA,amountA,0,0,owner.address,deadline,);
        console.log(gas);
    }

    async function checkTest() {
        const financeMaster=await ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
        const fM1=financeMaster.attach("0x5507Fe0EFb15f70bD5490B5c2E44aE4C2bE5Dc1B");

        const busd=await ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
        const BUSD=busd.attach("0x388672B44fD9370EAae35Ccc7A4a32F10b54da62");

        const honor=await ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
        const Honor=honor.attach("0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93");


        const test=await fM1.checkAmount(BUSD.address,Honor.address,parseETH("10"));
        const value=await BUSD.balanceOf(fM1.address);
        console.log(value);
        await fM1.depositToken(BUSD.address,parseETH("100"));
        console.log(test);

        await fM1.tradeAmin(BUSD.address,Honor.address,parseETH("10"));
    }

    async function setRouters() {
        const financeMaster=await ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
        const fM1=financeMaster.attach(_financeMaster);

        await fM1.setRouters(_routerHonor,_routerPancake1,_routerPancake2);
    }

    async function getHonorRouter() {
        const router=await ethers.getContractFactory("contracts/HonorRouter.sol:HonorRouter");
        const Router=router.attach(_routerHonor);
        return Router;
    }

    async function getBUSD() {
        const busd=await ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
        const BUSD=busd.attach("0x388672B44fD9370EAae35Ccc7A4a32F10b54da62");

        return BUSD;
    }

    async function getHonor() {
        const honor=await ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
        const Honor=honor.attach("0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93");
        return Honor;
    }
    it("TestBaşlasın",async function () {
        //await approveTokensFinanceMaster();
        
        //await setRouters();

        // await checkTest();
        const [owner] = await  ethers.getSigners();
        const deadline = Math.floor(Date.now() / 1000) + 60 * 20;

        const Router=await getHonorRouter();
        const bUSD=await getBUSD();
        const honor=await getHonor();

        const amount=parseETH("10");

        const path=[bUSD.address,honor.address];
        const amountOut=await Router.getAmountsOut(amount,path);
        console.log(amountOut);

        await checkTest();

        await Router.swapExactTokensForTokens(amount,amountOut[1],path,owner.address,deadline);
    })
 
  })