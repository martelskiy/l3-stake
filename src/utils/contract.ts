import { ethers, upgrades } from "hardhat";

export async function deploy<BaseContract>(
  withProxy: boolean,
  name: string,
  ...ctorArguments: any
): Promise<BaseContract> {
  console.log(
    `deploying ${name} contract with constructor arguments: ${ctorArguments}`,
  );

  const contractFactory = await ethers.getContractFactory(name);
  let contract;
  if (withProxy) {
    contract = await upgrades.deployProxy(contractFactory, ctorArguments);
  } else {
    contract = await contractFactory.deploy(...ctorArguments);
  }

  const deployedContract = (await contract.waitForDeployment()) as BaseContract;

  const address = await contract.getAddress();
  console.log(
    `contract with name: '${name}' was deployed to address: '${address}'`,
  );

  return deployedContract;
}
