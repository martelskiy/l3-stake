import { ethers, network } from "hardhat";
import { StakeERC20 } from "../typechain-types";
import { deploy } from "../utils/contract";

const stakedToken: ReadonlyMap<string, string> = new Map<string, string>([
  ["sepolia", "0x51fCe89b9f6D4c530698f181167043e1bB4abf89"],
]);

async function main() {
  const [signer] = await ethers.getSigners();

  console.log(
    `starting the deployment script, will deploy contracts to the network: '${network.name}', 
     with owner set to: '${signer.address}'`,
  );

  await deploy<StakeERC20>("StakeERC20", stakedToken.get(network.name));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
