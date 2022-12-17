
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();



    const SmartChef = await hre.ethers.getContractFactory("contracts/SmartChefFactory.sol:SmartChefFactory");
    const smartChef = await SmartChef.deploy();

    await smartChef.deployed();




  console.log(
    `SmartChef  deployed to ${smartChef.address}  `
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
