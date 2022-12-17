
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();
const busd="0x388672B44fD9370EAae35Ccc7A4a32F10b54da62";
const wbnb="0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd";
const honor="0x37CA99B38902c90fE8BDB23D5FDcD36D0a46Ef93";
const hnrusd="0xd62f3a589cF119eB4f246b4894a48dE640Fb3a2e";
const factory="0x04E4B98Fd20624C85FC8FDBb9233A087E2Fa98ae";
// const router="0x2C0648017f0162E4C87C3ff215918783DdCd53c3";


  
const FMV1 = await hre.ethers.getContractFactory("contracts/Finance/FinanceMasterV1.sol:FinanceMasterV1");
const fmV1 = await FMV1.deploy(busd,wbnb,honor,hnrusd,factory);

  await fmV1.deployed();


  console.log(
    `FinanceMasterV1  deployed to ${fmV1.address} `
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
