# Scripts Overview

This folder contains utility scripts used during development,
deployment, and demo of the Proof-of-Culture Engine.

## Scripts

### export_abi.js
Exports deployed smart contract ABI from Hardhat artifacts
to both backend and frontend to ensure consistency.

### seed_events.py
Seeds demo cultural events for hackathon testing.

### demo_flow.sh
Runs an end-to-end API demo:
Health → Events → Proof Verification → Monad Mint.

## Why This Exists
- Faster iteration
- No manual setup during demo
- Production-style automation
