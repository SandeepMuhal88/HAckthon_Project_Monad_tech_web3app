import { HardhatUserConfig, configVariable } from "hardhat/config";
import "@nomicfoundation/hardhat-viem";
import "dotenv/config";

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  networks: {
    monadTestnet: {
      type: "http",
      url: configVariable("MONAD_RPC_URL"),
      accounts: [configVariable("PRIVATE_KEY")],
      chainType: "l1",
    },
  },
};

export default config;
