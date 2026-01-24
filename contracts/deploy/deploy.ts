import hre from "hardhat";

async function main() {
  const { viem } = hre;

  const [deployer] = await viem.getWalletClients();
  console.log("Deploying with account:", deployer.account.address);

  const contract = await viem.deployContract("CultureProof", []);
  console.log("CultureProof deployed to:", contract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
