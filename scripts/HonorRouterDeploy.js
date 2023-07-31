
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();

  const Factory="0x81E0874b19c8024bBd31DcCcC051ce353a49E8e4";
  const WETH="0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889";
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
