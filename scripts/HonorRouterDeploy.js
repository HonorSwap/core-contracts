
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();

  const Factory="0x04E4B98Fd20624C85FC8FDBb9233A087E2Fa98ae";
  const WETH="0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd";
  const Router = await hre.ethers.getContractFactory("contracts/HonorRouter.sol:HonorRouter");
  const router = await Router.deploy(Factory,WETH);

  await router.deployed();


  console.log(
    `Router  deployed to ${router.address}`
  );
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
