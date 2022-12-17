
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();

    const honorToken="0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93";
    const honorBar="0xDDcB46bE9fb4106345a5b1Efbd66cf4Db6fD2e28";

    const num=hre.ethers.utils.parseEther("30");
    console.log(num);
    
    const MasterHonor = await hre.ethers.getContractFactory("contracts/MasterHonor.sol:MasterHonor");
    const masterHonor = await MasterHonor.deploy(honorToken,honorBar,
        owner.address,num,24734327);

    await masterHonor.deployed();

    //const Multicall = await hre.ethers.getContractFactory("contracts/Multicall.sol:Multicall");
    //const multiCall=await Multicall.deploy();

    //await multiCall.deployed();

  console.log(
    `MasterChef  deployed to ${masterHonor.address} `
  );

  //console.log(`Multicall  deployed to ${multiCall.address} `)

  
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
