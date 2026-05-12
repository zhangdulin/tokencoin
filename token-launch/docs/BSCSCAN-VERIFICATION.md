# BSCScan Verification Guide

## The Problem

BSCScan cannot resolve npm imports like `@openzeppelin/contracts/...` when using single file verification.

## The Solution

Use **Standard JSON Input** format with the pre-generated JSON files.

---

## MyToken Verification

### Step 1: Get the Standard JSON Input

```bash
cat flattened/MyToken-standard-json.json
```

### Step 2: Verify on BSCScan

1. Open: https://bscscan.com/address/0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B#code

2. Click **"Verify Contract"** (green button)

3. Select **"Solc (Standard JSON Input)"** as the verification method

4. Fill in:
   - **Compiler Version**: `0.8.24`
   - **License**: `MIT License`

5. For **"Standard Input JSON"**:
   - Copy the ENTIRE contents of `flattened/MyToken-standard-json.json`
   - Paste it into the text area

6. Click **"Verify"**

### Step 3: Troubleshooting

If you get "Unable to find matching Contract Bytecode and ABI":

1. Make sure you copied the ENTIRE JSON content (no truncation)
2. Verify compiler version is exactly `0.8.24`
3. Check that optimizer is enabled with 200 runs in the JSON settings
4. Ensure evmVersion is set to "paris"

---

## TokenVesting Verification

Same steps, but use:

1. URL: https://bscscan.com/address/0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934#code
2. JSON file: `flattened/TokenVesting-standard-json.json`

---

## Pre-generated JSON Files Location

```
flattened/
├── MyToken.sol                      # Flattened source (for reference)
├── MyToken-standard-json.json       # Ready for BSCScan Standard JSON Input
├── TokenVesting.sol                # Flattened source (for reference)
└── TokenVesting-standard-json.json # Ready for BSCScan Standard JSON Input
```

---

## Generate New JSON Files

If needed, regenerate with:

```bash
node scripts/bscscan-standard-json.js
```

This creates the JSON files with correct compiler settings matching hardhat.config.cjs:
- Solidity: 0.8.24
- Optimizer: enabled, 200 runs
- EVM Version: paris

---

## Contract Addresses (Mainnet)

| Contract | Address |
|----------|---------|
| MyToken | 0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B |
| TokenVesting | 0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934 |
