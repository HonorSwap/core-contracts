
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();

    const factory = "0x5B19629Db8d16D551e9f3FaaC150fA8a11051B33";
    const honor="0x4CFAC133438b25C22434ed56106EAF8503EC65eA";
    const weth="0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
    const usdt="0x55d398326f99059fF775485246999027B3197955";

    const contract = await hre.ethers.getContractAt("contracts/HonorFactory.sol:HonorFactory",factory);
    
    await contract.setTokenAccess(honor,1);
    await contract.setTokenAccess(weth,1);
    await contract.setTokenAccess(usdt,1);
    // await contract.setUserFee("0xD5e4de15D1070a024BE7E356a5cb92db3f22dF9A",25);







  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
