# Contributing to Tokencoin

Thank you for your interest in contributing to Tokencoin!

## How to Contribute

### Reporting Bugs

1. Check if the bug already exists in issues
2. Create a new issue with:
   - Clear bug title
   - Steps to reproduce
   - Expected vs actual behavior
   - Solidity version and environment

### Suggesting Features

1. Create a detailed feature request
2. Explain the use case and benefits
3. Consider gas efficiency implications

### Code Contributions

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Write tests for your changes
4. Ensure all tests pass: `npx hardhat test`
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

## Development Setup

```bash
# Clone your fork
git clone https://github.com/zhangdulin/tokencoin.git
cd tokencoin

# Install dependencies
npm install

# Run tests
npx hardhat test
```

## Coding Standards

- Follow Solidity style guide
- Add NatSpec comments to all functions
- Include unit tests for new features
- Keep contracts under 200 lines
- Use OpenZeppelin patterns

## Security

- Do not commit private keys or secrets
- Use `.env` for environment variables
- Report security issues privately to: [TBD]

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
