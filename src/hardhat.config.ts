import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "dotenv-defaults/config";

const SEPOLIA_DEPLOYER_PK = process.env.SEPOLIA_DEPLOYER_PK;
const SEPOLIA_ALCHEMY_API_KEY = process.env.SEPOLIA_ALCHEMY_API_KEY;

const config: HardhatUserConfig = {
  solidity: {
    compilers: [{ version: "0.8.23" }],
  },
  networks: {
    hardhat: {
      forking: {
        enabled: false,
        url: ``,
      },
    },
    sepolia: {
      accounts: [SEPOLIA_DEPLOYER_PK!],
      url: `https://eth-sepolia.g.alchemy.com/v2/${SEPOLIA_ALCHEMY_API_KEY}`,
    },
  },
};

export default config;
