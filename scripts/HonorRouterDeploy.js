
const hre = require("hardhat");

async function main() {

const [owner, otherAccount] = await hre.ethers.getSigners();

  const Factory="0x5B19629Db8d16D551e9f3FaaC150fA8a11051B33";
  const WETH="0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c";
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
