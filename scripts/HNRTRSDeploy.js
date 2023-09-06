
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();


    const token = await hre.ethers.getContractFactory("contracts/Tokens/HNRTRS.sol:HNRTRS");
    const Token=await token.deploy();

    await Token.deployed();



    console.log(`Token  deployed to ${Token.address} `)

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
