.PHONY: help compile test deploy clean verify

help:
	@echo "Tokencoin (TOKEN) - Smart Contract Commands"
	@echo ""
	@echo "Available commands:"
	@echo "  compile  - Compile smart contracts"
	@echo "  test     - Run all tests"
	@echo "  deploy   - Deploy to localhost (run 'npx hardhat node' first)"
	@echo "  verify   - Verify contracts on Etherscan/BSCScan"
	@echo "  clean    - Clean build artifacts"
	@echo ""

compile:
	cd token-launch && npx hardhat compile

test:
	cd token-launch && npx hardhat test

deploy:
	cd token-launch && npx hardhat run scripts/deploy-token.js --network localhost

verify:
	cd token-launch && npx hardhat run scripts/verify-contract.js --network localhost

clean:
	cd token-launch && npx hardhat clean
