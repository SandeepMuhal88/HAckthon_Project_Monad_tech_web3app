const fs = require("fs");
const path = require("path");

const CONTRACT_NAME = "CultureProof";

const hardhatArtifacts = path.join(
  __dirname,
  "../contracts/artifacts/contracts",
  `${CONTRACT_NAME}.sol`,
  `${CONTRACT_NAME}.json`
);

const backendOut = path.join(
  __dirname,
  "../backend/app/services",
  "culture_proof_abi.json"
);

const frontendOut = path.join(
  __dirname,
  "../frontend/assets",
  "culture_proof_abi.json"
);

function exportAbi() {
  const artifact = JSON.parse(fs.readFileSync(hardhatArtifacts, "utf8"));
  const abi = artifact.abi;

  fs.writeFileSync(backendOut, JSON.stringify(abi, null, 2));
  fs.writeFileSync(frontendOut, JSON.stringify(abi, null, 2));

  console.log("✅ ABI exported to backend & frontend");
}

exportAbi();
