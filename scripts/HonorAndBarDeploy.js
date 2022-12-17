
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



  

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
