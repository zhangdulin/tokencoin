require("dotenv").config();
require("@nomiclabs/hardhat-ethers");

// Helper function to get private key
const getPrivateKey = () => {
  const key = process.env.PRIVATE_KEY;
  if (!key || key === "YOUR_TESTNET_PRIVATE_KEY" || key.length < 64) {
    return undefined;
  }
  return key.startsWith("0x") ? key : `0x${key}`;
};

// Helper to check if production
const isProduction = (network) => network === 'bsc' || network === 'mainnet';

// Get contract config from environment
const getContractConfig = () => ({
  timelockDelay: parseInt(process.env.TIMELOCK_DELAY || "43200"),
  maxEmergencyWithdrawBps: parseInt(process.env.MAX_EMERGENCY_WITHDRAW_BPS || "1000"),
});

// Network configurations
const getNetworkConfig = (network) => {
  const privateKey = getPrivateKey();

  const baseConfig = {
    accounts: privateKey ? [privateKey] : undefined,
    chainId: network === 'bsc' ? 56 : network === 'bscTestnet' ? 97 : undefined,
  };

  switch (network) {
    case 'bscTestnet':
      return {
        ...baseConfig,
        url: process.env.BSC_TESTNET_RPC_URL || "https://data-seed-prebsc-1-s1.bnbchain.org:8545",
      };
    case 'bsc':
      return {
        ...baseConfig,
        url: process.env.BSC_MAINNET_RPC_URL || "https://bsc-dataseed.binance.org/",
      };
    case 'sepolia':
      return {
        ...baseConfig,
        url: process.env.SEPOLIA_RPC_URL || "https://sepolia.infura.io/v3/YOUR_API_KEY",
      };
    case 'mainnet':
      return {
        ...baseConfig,
        url: process.env.ETHEREUM_RPC_URL || "https://eth-mainnet.g.alchemy.com/v2/YOUR_API_KEY",
      };
    case 'localhost':
      return {
        url: "http://127.0.0.1:8545",
      };
    default:
      return baseConfig;
  }
};

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    hardhat: {
      // Local hardhat network
    },
    localhost: getNetworkConfig('localhost'),
    sepolia: getNetworkConfig('sepolia'),
    bscTestnet: getNetworkConfig('bscTestnet'),
    bsc: getNetworkConfig('bsc'),
    mainnet: getNetworkConfig('mainnet'),
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY || "",
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      bsc: process.env.BSCSCAN_API_KEY || "",
      bscTestnet: process.env.BSCSCAN_API_KEY || "",
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS === "true",
    currency: "USD",
  },
};
