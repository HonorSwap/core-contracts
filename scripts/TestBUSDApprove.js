
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();
const busd="0x388672B44fD9370EAae35Ccc7A4a32F10b54da62";



  
const BUSDContract = await hre.ethers.getContractFactory("contracts/Tokens/TestBUSD.sol:TestBUSD");
const busdToken=await BUSDContract.attach(busd);

/*
const num=hre.ethers.utils.parseEther("100000");
busdToken.approve("0xA0b6085FCE22403cAF04322249723c424D05f103",num);

*/
const finance="0xA0b6085FCE22403cAF04322249723c424D05f103";
const totalSupply=await busdToken.totalSupply();
await busdToken.approve(finance,totalSupply);
await busdToken.approve("0xD99D1c33F9fC3444f8101754aBC46c52416550D1",totalSupply);
await busdToken.approve("0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3",totalSupply);

const num=hre.ethers.utils.parseEther("100");
const FMV1 = await hre.ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
const fm1=FMV1.attach(finance);

await fm1.depositBUSD(num);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
