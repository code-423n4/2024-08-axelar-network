
# Axelar Network audit details
- Total Prize Pool: $85,000 in USDC
  - HM awards: $71,500 in USDC
  - QA awards: $3,000 in USDC
  - Judge awards: $6,000 in USDC
  - Validator awards: $4,000 USDC
  - Scout awards: $500 in USDC
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2024-08-axelar-network/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts August 8, 2024 20:00 UTC
- Ends August 26, 2024 20:00 UTC

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2024-08-axelar-network/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._


- Please refer to [previous audits](https://github.com/axelarnetwork/audits/tree/main), especially for `AxelarAmplifierGateway`, `interchain-token-service`, `axelar-amplifier`


# Overview

[ ⭐️ SPONSORS: add info here ]

## Links

- **Previous audits:**  https://github.com/axelarnetwork/audits?tab=readme-ov-file
- **Documentation:** https://docs.axelar.dev/
- **Website:** https://www.axelar.network/
- **X/Twitter:** https://twitter.com/axelarnetwork
- **Discord:** https://discord.com/invite/aRZ3Ra6f7D

---

# Scope

[ ✅ SCOUTS: add scoping and technical details here ]

### Files in scope
- ✅ This should be completed using the `metrics.md` file
- ✅ Last row of the table should be Total: SLOC
- ✅ SCOUTS: Have the sponsor review and and confirm in text the details in the section titled "Scoping Q amp; A"

*For sponsors that don't use the scoping tool: list all files in scope in the table below (along with hyperlinks) -- and feel free to add notes to emphasize areas of focus.*

| Contract | SLOC | Purpose | Libraries used |  
| ----------- | ----------- | ----------- | ----------- |
| [contracts/folder/sample.sol](https://github.com/code-423n4/repo-name/blob/contracts/folder/sample.sol) | 123 | This contract does XYZ | [`@openzeppelin/*`](https://openzeppelin.com/contracts/) |

### Files out of scope
✅ SCOUTS: List files/directories out of scope

## Scoping Q &amp; A

### General questions
### Are there any ERC20's in scope?: Yes

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".

Any (all possible ERC20s)


### Are there any ERC777's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC721's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



### Are there any ERC1155's in scope?: No

✅ SCOUTS: If the answer above 👆 is "Yes", please add the tokens below 👇 to the table. Otherwise, update the column with "None".



✅ SCOUTS: Once done populating the table below, please remove all the Q/A data above.

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any (all possible ERC20s)             |
| Test coverage                           | ✅ SCOUTS: Please populate this after running the test coverage command                          |
| ERC721 used  by the protocol            |            None              |
| ERC777 used by the protocol             |           None                |
| ERC1155 used by the protocol            |              None            |
| Chains the protocol will be deployed on | Other: N/A. These contracts are on Axelar Network protocol.  |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   In scope  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  In scope  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | In scope    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   In scope  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | In scope    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | In scope    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | In scope    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | In scope    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | In scope    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | In scope    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | In scope    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | In scope    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  In scope   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | In scope    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   Out of scope  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | Out of scope    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Out of scope    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | No   |
| Pausability (e.g. Uniswap pool gets paused)               |  No   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |


### EIP compliance checklist
Only Interchain Token adheres to EIP-20.



# Additional context

## Main invariants

- Security: Identify and mitigate vulnerabilities to prevent exploits and attacks.
- Reliability: Ensure the contract behaves consistently under various conditions.
- Efficiency: Verify that the contract performs optimally without unnecessary gas consumption.
- Correctness: Ensure the smart contract logic correctly implements the intended functionality without errors.


## Attack ideas (where to focus for bugs)
**Security Concerns - Access Control, Signature Verification, Reply Protection, Data integrity**
- Does the access control mechanism correctly restrict access to sensitive functions?
- Are role-based access controls (onlyRole) correctly implemented for managing flow limiters and operator roles?
- Does the storage function correctly reference the intended storage slots and ensure security?
- Can the signature verification function correctly verify the required signatures?
- Does the function handling signature proofs properly reject invalid or malicious proofs?
- Can the message validation function correctly update the message status to prevent replay attacks?
- Does the message approval function properly check if a message has already been approved to avoid double approvals?
- Are token details, such as addresses and flow limits, securely managed and protected from tampering?
- Does the contract ensure that minting and burning of tokens are properly authorized and logged?
- Any misbehavior by the token which identified through its token ID, does not impact other tokens registered by ITS?

**Functional Concerns - Message Approval and Execution, Signer Rotation, Event Emission**
- Can the message approval functions correctly handle and store message approvals?
- Does the message validation function accurately validate messages and update their status?
- Does the signer rotation function correctly handle signer rotation, enforce the minimum rotation delay, and prevent rotation to duplicate signers?
- Can the signer rotation function address potential edge cases and ensure proper updates to the signer set?
- Does the contract emit all necessary events correctly and include appropriate data?
- Can event emissions avoid inadvertently exposing sensitive information?

**Upgradability Concerns - Upgrade Mechanism, Storage Compatibility**
- Does the upgrade mechanism correctly delegate calls to the implementation contract?
- Can the initialization and upgrade functions handle scenarios without introducing vulnerabilities?
- Does the storage layout remain compatible with future upgrades to prevent data corruption or loss?
- Can the storage structures be correctly defined and used?

**Potential Edge Cases - Error Handling, Gas Efficiency**
- Does the contract have proper error handling and revert statements for invalid inputs, unauthorized access, and other potential failure scenarios?
- Can the contract be optimized for gas efficiency, particularly in loops and storage access patterns?


## All trusted roles in the protocol

N/A


## Describe any novel or unique curve logic or mathematical models implemented in the contracts:

N/A


## Running tests

- ITS: https://github.com/axelarnetwork/interchain-token-service/tree/main?tab=readme-ov-file
- Amplifier: https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/tree/v5.10.0/contracts/gateway
- EVM contract deployments: https://github.com/axelarnetwork/axelar-contract-deployments/blob/main/evm/README.md

✅ SCOUTS: Please format the response above 👆 using the template below👇

```bash
git clone https://github.com/code-423n4/2023-08-arbitrum
git submodule update --init --recursive
cd governance
foundryup
make install
make build
make sc-election-test
```
To run code coverage
```bash
make coverage
```
To run gas benchmarks
```bash
make gas
```

✅ SCOUTS: Add a screenshot of your terminal showing the gas report
✅ SCOUTS: Add a screenshot of your terminal showing the test coverage

## Miscellaneous
Employees of AXELAR and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.


