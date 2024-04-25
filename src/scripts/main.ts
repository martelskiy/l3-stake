import { ethers, network } from "hardhat";
import { StakeERC20 } from "../typechain-types";
import { deploy } from "../utils/contract";

async function main() {
  const [signer] = await ethers.getSigners();

  console.log(
    `starting the deployment script, will deploy contracts to the network: '${network.name}', 
     with owner set to: '${signer.address}'`,
  );

  await deploy<StakeERC20>("StakeERC20");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
