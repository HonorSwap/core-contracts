
const hre = require("hardhat");

function getFileName(file,tokenName) {
  const fileName="contracts/Tokens/" + file + ".sol:" + tokenName;
  return fileName;
}
async function deployToken(file,tokenName) {
  const fileName="contracts/Tokens/" + file + ".sol:" + tokenName;
  //console.log(fileName);
  const token=await hre.ethers.getContractFactory(fileName);
  const Token=await token.deploy();
  await Token.deployed();
  console.log(file + " Token deployed to " + Token.address);
}

async function main() {


  const honor=await hre.ethers.getContractFactory("contracts/Tokens/HonorToken.sol:HonorToken");
  const Honor=await honor.deploy();
  await Honor.deployed();
  
  console.log("HonorToken: " + Honor.address);

  const bar=await hre.ethers.getContractFactory("contracts/Tokens/HonorBar.sol:HonorBar");
  const Bar=await bar.deploy(Honor.address);
  await Bar.deployed();

  console.log("HonorBar: " + Bar.address);

  await deployToken("HNRUSDToken","HNRUSDToken");

  await deployToken("TestBUSD","TestBUSD");
  await deployToken("TestUSDT","TestUSDT");
  await deployToken("TestUSDC","TestUSDC");
  await deployToken("xHNRToken","xHNRToken");
  /*
  const Honor = await hre.ethers.getContractFactory("contracts/HonorToken.sol:HonorToken");
  const honor = await Honor.deploy();

  const HNRUSD = await hre.ethers.getContractFactory("contracts/HNRUSDToken.sol:HNRUSDToken");
  const hnrUSD = await HNRUSD.deploy();

  const TestBUSD = await hre.ethers.getContractFactory("contracts/TestBUSD.sol:TestBUSD");
  const tBUSD = await TestBUSD.deploy();

  await honor.deployed();
  await hnrUSD.deployed();
  await tBUSD.deployed();
  */

  

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
