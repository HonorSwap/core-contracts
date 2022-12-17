
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();


    const Multicall = await hre.ethers.getContractFactory("contracts/Multicall.sol:Multicall");
    const multiCall=await Multicall.deploy();

    await multiCall.deployed();



    console.log(`Multicall  deployed to ${multiCall.address} `)

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
