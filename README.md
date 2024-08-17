
# Axelar Network audit details
- Total Prize Pool: $85,000 in USDC
  - HM awards: $71,500 in USDC
  - QA awards: $3,000 in USDC
  - Judge awards: $6,000 in USDC
  - Validator awards: $4,000 in USDC
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

### Publicly Known Issues: 
**ITS hub balance tracking should be applied when minter isn't set (https://github.com/axelarnetwork/interchain-token-service/issues/270)**
- ITS Hub balance tracking should only be applied when the minter isn't set in the deploy Interchain Token message type. If a minter is set, then the balance invariants can't be preserved since the minter address can mint on the remote chain. This is a fine trade off for custom tokens who want more control. The balance invariant is more so intended for the common use case of deploying a [canonical ITS token](https://github.com/axelarnetwork/interchain-token-service/blob/main/contracts/InterchainTokenFactory.sol#L209) or a [trustless native interchain token](https://github.com/axelarnetwork/interchain-token-service/blob/main/contracts/InterchainTokenFactory.sol#L182) to remote chains via the Factory, where the minter isn't set.
Hence, additionally [check](https://github.com/axelarnetwork/axelar-amplifier/blob/feat/its-hub/interchain-token-service/src/contract/execute.rs#L136) if minter length is 0 in ITS hub to enable tracking.


# Overview

## What is Axelar?
Axelar delivers secure cross-chain communication for Web3, enabling you to build Interchain dApps that grow beyond a single chain. Secure means Axelar is built on proof-of-stake, the battle-tested approach used by Ethereum, Polygon, Cosmos, and more. Cross-chain communication means you can build a complete experience for your users that lets them interact with any asset, any application, on any chain with one click.

## Interchain Token Service (ITS): 
The Interchain Token Service allows users and developers to easily create their own token bridge, handling all underlying interchain communication. Users can either use the provided InterchainToken or implement their own. There are multiple configuration options for bridges, and users must trust the deployer of any bridge they use, similar to how they must trust the operator of a token. 

## Interchain Amplifier:
The Interchain Amplifier enables developers to permissionlessly set up connections to the Axelar network. Developers gain access to Axelar's interconnected network of chains and can "amplify" their resources by paying the cost equivalent to developing only one connection. They can establish connections between new ecosystems or existing chains to add new network properties, such as improved security or better delivery and availability.
- More details on Amplifier: https://docs.axelar.dev/dev/amplifier/introduction

## Axelar Amplifier Gateway:
Axelar Amplifier Gateway is a smart contract that lives on the external chain connecting to the Axelar Network. It facilitates the sending and receiving of cross-chain messages to other chains via the Axelar Network. AxelarAmplifierGateway is the EVM reference implementation of the external gateway.

## ITS Token Hub for Amplifier
- Tech Spec: [ITS Token hub design for Amplifier](https://bright-ambert-2bd.notion.site/ITS-Token-Hub-External-dd30ee912d1e48e683d9488acf75e350)

## Links

- **Previous audits:**  https://github.com/axelarnetwork/audits?tab=readme-ov-file
- **Documentation:** https://docs.axelar.dev/
- **Website:** https://www.axelar.network/
- **X/Twitter:** https://twitter.com/axelarnetwork
- **Discord:** https://discord.com/invite/aRZ3Ra6f7D
- **Youtube:** https://www.youtube.com/@axelar-network

## FAQs
- **Frequently Asked Questions:** [C4E Audit (Axelar Amplifier) - FAQs (Aug 2024)](https://bright-ambert-2bd.notion.site/C4E-Audit-Axelar-Amplifier-FAQs-Aug-2024-External-5ded3250fa504e3e882e9551179b7548)

---

# Scope



### Files in scope

- For the [EVM Amplifier Gateway](https://github.com/code-423n4/2024-08-axelar-network/tree/main/axelar-gmp-sdk-solidity) contracts:

| Contract                                          | SLOC | Purpose | Libraries used |
| ------------------------------------------------- | ---- | ------- | -------------- |
| contracts/gateway/BaseAmplifierGateway.sol        | 130  |         |                |
| contracts/gateway/AxelarAmplifierGateway.sol      | 68   |         |                |
| contracts/gateway/AxelarAmplifierGatewayProxy.sol | 13   |         |                |
| contracts/governance/BaseWeightedMultisig.sol     | 129  |         |                |
| TOTAL     |  340 |         |                |



- For the [Cosmwasm/Rust ITS Hub](https://github.com/code-423n4/2024-08-axelar-network/tree/main/axelar-amplifier) contracts:

Contract|SLOC|Purpose|Libraries used
:-------|-------:|-------:|-------:
interchain-token-service/src/abi.rs|524||
interchain-token-service/src/contract/execute.rs|523||
interchain-token-service/src/state.rs|224||
interchain-token-service/src/primitives.rs|109||
interchain-token-service/src/contract.rs|108||
interchain-token-service/src/msg.rs|52||
contracts/axelarnet-gateway/src/state.rs|202||
contracts/axelarnet-gateway/src/contract.rs|139||
contracts/axelarnet-gateway/src/client.rs|126||
contracts/axelarnet-gateway/src/contract/execute.rs|118||
contracts/axelarnet-gateway/src/executable.rs|67||
contracts/axelarnet-gateway/src/msg.rs|33||
| TOTAL     |  2225 |         |                |



- For the [interchain-token-service](https://github.com/code-423n4/2024-08-axelar-network/tree/main/interchain-token-service) contracts:

| Contract                                                                                  | SLOC | Purpose | Libraries used |
|-------------------------------------------------------------------------------------------|------|---------|----------------|
| interchain-token-service/contracts/InterchainTokenService.sol                        | 565  |         |                |
| interchain-token-service/contracts/utils/GatewayCaller.sol                               | 64   |         |                |
| interchain-token-service/contracts/utils/Minter.sol                                      | 21   |         |                |
| interchain-token-service/contracts/interchain-token/InterchainTokenStandard.sol          | 30   |         |                |
| interchain-token-service/contracts/utils/RolesConstants.sol                               | 8    |         |                |
| interchain-token-service/contracts/utils/TokenManagerDeployer.sol                       | 12   |         |                |
| interchain-token-service/contracts/interchain-token/ERC20Permit.sol                      | 31   |         |                |
| interchain-token-service/contracts/utils/InterchainTokenDeployer.sol                    | 26   |         |                |
| interchain-token-service/contracts/interchain-token/InterchainToken.sol                  | 63   |         |                |
| interchain-token-service/contracts/utils/Create3Fixed.sol                                | 21   |         |                |
| interchain-token-service/contracts/interchain-token/ERC20.sol                            | 55   |         |                |
| interchain-token-service/contracts/TokenHandler.sol                                     | 136  |         |                |
| interchain-token-service/contracts/utils/Create3AddressFixed.sol                       | 12   |         |                |
| interchain-token-service/contracts/utils/FlowLimit.sol                                   | 69   |         |                |
| interchain-token-service/contracts/utils/Operator.sol                                    | 21   |         |                |
| interchain-token-service/contracts/InterchainTokenFactory.sol                             | 144  |         |                |
| interchain-token-service/contracts/proxies/InterchainProxy.sol                           | 5   |         |                |
| interchain-token-service/contracts/proxies/TokenManagerProxy.sol                          | 37   |         |                |
| interchain-token-service/contracts/token-manager/TokenManager.sol                         | 83   |         |                |
| interchain-token-service/contracts/executable/InterchainTokenExecutable.sol              | 18   |         |                |
| interchain-token-service/contracts/executable/InterchainTokenExpressExecutable.sol       | 11   |         |                |
| TOTAL     |  1432 |         |                |



### Files out of scope
Any files not under the scope tables are OUT OF SCOPE

## Scoping Q &amp; A

### General questions

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any (all possible ERC20s)             |
| Test coverage                           | interchain-token-service: Functions 100%, Lines 99.11% - EVM Amplifier Gateway: Functions 97.65%, Lines 99.86%                        |
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
-  Clone the repo:
```bash
git clone --recurse https://github.com/code-423n4/2024-08-axelar-network.git
```
 - For Interchain Token Services (make sure you´re at the [interchain-token-service](https://github.com/code-423n4/2024-08-axelar-network/tree/main/interchain-token-service) folder :
```bash
npm ci
npm run build
npm run test
```
To run gas benchmarks:
```bash
REPORT_GAS=true npm run test
```
To run code coverage: 
```bash
npm run coverage
```
More detailed info [here](https://github.com/axelarnetwork/interchain-token-service/tree/main?tab=readme-ov-file). 

- For EVM Amplifier Gateway (make sure you´re at the [axelar-gmp-sdk-solidity](https://github.com/code-423n4/2024-08-axelar-network/tree/main/axelar-gmp-sdk-solidity) folder :
```bash
npm ci
npm run build
npm run test
```
To run gas benchmarks:
```bash
REPORT_GAS=true npm run test
```
To run code coverage: 
```bash
npm run coverage
```
More detailed info [here](https://github.com/axelarnetwork/axelar-gmp-sdk-solidity/tree/v5.10.0/contracts/gateway).

- For Cosmwasm/Rust ITS Hub contracts (make sure you´re at the [axelar-amplifier](https://github.com/code-423n4/2024-08-axelar-network/tree/main/axelar-amplifier) folder :
```bash
rustup update
cargo build
cargo test
```
- More info about EVM contract deployments [here](https://github.com/axelarnetwork/axelar-contract-deployments/blob/main/evm/README.md).



- Test Coverage for Interchain Token Service contracts: 

| File                                    |  % Stmts | % Branch |  % Funcs |  % Lines | Uncovered Lines |
|-----------------------------------------|----------|----------|----------|----------|-----------------|
| contracts/                              |      100 |    95.76 |      100 |    99.18 |                 |
|   InterchainTokenFactory.sol            |      100 |      100 |      100 |      100 |                 |
|   InterchainTokenService.sol            |      100 |    95.68 |      100 |      100 |                 |
|   TokenHandler.sol                      |      100 |    94.23 |      100 |    95.38 |      78,116,155 |
| contracts/executable/                   |      100 |      100 |      100 |      100 |                 |
|   InterchainTokenExecutable.sol         |      100 |      100 |      100 |      100 |                 |
|   InterchainTokenExpressExecutable.sol  |      100 |      100 |      100 |      100 |                 |
| contracts/interchain-token/             |      100 |      100 |      100 |      100 |                 |
|   ERC20.sol                             |      100 |      100 |      100 |      100 |                 |
|   ERC20Permit.sol                       |      100 |      100 |      100 |      100 |                 |
|   InterchainToken.sol                   |      100 |      100 |      100 |      100 |                 |
|   InterchainTokenStandard.sol           |      100 |      100 |      100 |      100 |                 |
| contracts/interfaces/                   |      100 |      100 |      100 |      100 |                 |
|   IAddressTracker.sol                   |      100 |      100 |      100 |      100 |                 |
|   IBaseTokenManager.sol                 |      100 |      100 |      100 |      100 |                 |
|   IERC20BurnableFrom.sol                |      100 |      100 |      100 |      100 |                 |
|   IERC20MintableBurnable.sol            |      100 |      100 |      100 |      100 |                 |
|   IERC20Named.sol                       |      100 |      100 |      100 |      100 |                 |
|   IFlowLimit.sol                        |      100 |      100 |      100 |      100 |                 |
|   IGatewayCaller.sol                    |      100 |      100 |      100 |      100 |                 |
|   IInterchainToken.sol                  |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenDeployer.sol          |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenExecutable.sol        |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenExpressExecutable.sol |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenFactory.sol           |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenService.sol           |      100 |      100 |      100 |      100 |                 |
|   IInterchainTokenStandard.sol          |      100 |      100 |      100 |      100 |                 |
|   IMinter.sol                           |      100 |      100 |      100 |      100 |                 |
|   IOperator.sol                         |      100 |      100 |      100 |      100 |                 |
|   ITokenHandler.sol                     |      100 |      100 |      100 |      100 |                 |
|   ITokenManager.sol                     |      100 |      100 |      100 |      100 |                 |
|   ITokenManagerDeployer.sol             |      100 |      100 |      100 |      100 |                 |
|   ITokenManagerImplementation.sol       |      100 |      100 |      100 |      100 |                 |
|   ITokenManagerProxy.sol                |      100 |      100 |      100 |      100 |                 |
|   ITokenManagerType.sol                 |      100 |      100 |      100 |      100 |                 |
|   ITransmitInterchainToken.sol          |      100 |      100 |      100 |      100 |                 |
| contracts/proxies/                      |      100 |      100 |      100 |      100 |                 |
|   InterchainProxy.sol                   |      100 |      100 |      100 |      100 |                 |
|   TokenManagerProxy.sol                 |      100 |      100 |      100 |      100 |                 |
| contracts/token-manager/                |      100 |    96.15 |      100 |      100 |                 |
|   TokenManager.sol                      |      100 |    96.15 |      100 |      100 |                 |
| contracts/types/                        |      100 |      100 |      100 |      100 |                 |
|   InterchainTokenServiceTypes.sol       |      100 |      100 |      100 |      100 |                 |
| contracts/utils/                        |      100 |     87.5 |      100 |    97.44 |                 |
|   Create3AddressFixed.sol               |      100 |      100 |      100 |      100 |                 |
|   Create3Fixed.sol                      |      100 |    83.33 |      100 |      100 |                 |
|   FlowLimit.sol                         |      100 |      100 |      100 |      100 |                 |
|   GatewayCaller.sol                     |      100 |    83.33 |      100 |    85.71 |          64,116 |
|   InterchainTokenDeployer.sol           |      100 |       75 |      100 |      100 |                 |
|   Minter.sol                            |      100 |      100 |      100 |      100 |                 |
|   Operator.sol                          |      100 |      100 |      100 |      100 |                 |
|   RolesConstants.sol                    |      100 |      100 |      100 |      100 |                 |
|   TokenManagerDeployer.sol              |      100 |       50 |      100 |      100 |                 |
|-----------------------------------------|----------|----------|----------|----------|-----------------|
| All files                               |      100 |    95.45 |      100 |    99.11 |                 |
|-----------------------------------------|----------|----------|----------|----------|-----------------|


- Test coverage for EVM Amplifier Gateway contracts: 

| File                                 |  % Stmts | % Branch |  % Funcs |  % Lines | Uncovered Lines |
|--------------------------------------|----------|----------|----------|----------|-----------------|
| deploy/                              |      100 |    94.44 |      100 |      100 |                 |
|   ConstAddressDeployer.sol           |      100 |      100 |      100 |      100 |                 |
|   Create2.sol                        |      100 |      100 |      100 |      100 |                 |
|   Create2Deployer.sol                |      100 |      100 |      100 |      100 |                 |
|   Create3.sol                        |      100 |    83.33 |      100 |      100 |                 |
|   Create3Address.sol                 |      100 |      100 |      100 |      100 |                 |
|   Create3Deployer.sol                |      100 |      100 |      100 |      100 |                 |
|   CreateDeploy.sol                   |      100 |      100 |      100 |      100 |                 |
|   Deployer.sol                       |      100 |      100 |      100 |      100 |                 |
| executable/                          |      100 |      100 |    81.82 |      100 |                 |
|   AxelarExecutable.sol               |      100 |      100 |       60 |      100 |                 |
|   AxelarGMPExecutable.sol            |      100 |      100 |      100 |      100 |                 |
|   AxelarGMPExecutableWithToken.sol   |      100 |      100 |      100 |      100 |                 |
| express/                             |    97.73 |    95.24 |    83.33 |      100 |                 |
|   AxelarExpressExecutable.sol        |      100 |      100 |    71.43 |      100 |                 |
|   AxelarValuedExpressExecutable.sol  |    95.92 |    91.67 |    77.78 |      100 |                 |
|   ExpressExecutorTracker.sol         |      100 |      100 |      100 |      100 |                 |
| gas-estimation/                      |      100 |    91.67 |      100 |    97.83 |                 |
|   InterchainGasEstimation.sol        |      100 |    91.67 |      100 |    97.83 |             103 |
| gateway/                             |      100 |      100 |      100 |      100 |                 |
|   AxelarAmplifierGateway.sol         |      100 |      100 |      100 |      100 |                 |
|   AxelarAmplifierGatewayProxy.sol    |      100 |      100 |      100 |      100 |                 |
|   BaseAmplifierGateway.sol           |      100 |      100 |      100 |      100 |                 |
| governance/                          |      100 |      100 |      100 |      100 |                 |
|   AxelarServiceGovernance.sol        |      100 |      100 |      100 |      100 |                 |
|   BaseMultisig.sol                   |      100 |      100 |      100 |      100 |                 |
|   BaseWeightedMultisig.sol           |      100 |      100 |      100 |      100 |                 |
|   InterchainGovernance.sol           |      100 |      100 |      100 |      100 |                 |
|   InterchainMultisig.sol             |      100 |      100 |      100 |      100 |                 |
|   Multisig.sol                       |      100 |      100 |      100 |      100 |                 |
| interfaces/                          |      100 |      100 |      100 |      100 |                 |
|   IAxelarAmplifierAuth.sol           |      100 |      100 |      100 |      100 |                 |
|   IAxelarAmplifierGateway.sol        |      100 |      100 |      100 |      100 |                 |
|   IAxelarAmplifierGatewayAuth.sol    |      100 |      100 |      100 |      100 |                 |
|   IAxelarExecutable.sol              |      100 |      100 |      100 |      100 |                 |
|   IAxelarExpressExecutable.sol       |      100 |      100 |      100 |      100 |                 |
|   IAxelarGMPExecutable.sol           |      100 |      100 |      100 |      100 |                 |
|   IAxelarGMPExecutableWithToken.sol  |      100 |      100 |      100 |      100 |                 |
|   IAxelarGMPGateway.sol              |      100 |      100 |      100 |      100 |                 |
|   IAxelarGMPGatewayWithToken.sol     |      100 |      100 |      100 |      100 |                 |
|   IAxelarGasService.sol              |      100 |      100 |      100 |      100 |                 |
|   IAxelarGateway.sol                 |      100 |      100 |      100 |      100 |                 |
|   IAxelarServiceGovernance.sol       |      100 |      100 |      100 |      100 |                 |
|   IAxelarValuedExpressExecutable.sol |      100 |      100 |      100 |      100 |                 |
|   IBaseAmplifierGateway.sol          |      100 |      100 |      100 |      100 |                 |
|   IBaseMultisig.sol                  |      100 |      100 |      100 |      100 |                 |
|   IBaseWeightedMultisig.sol          |      100 |      100 |      100 |      100 |                 |
|   ICaller.sol                        |      100 |      100 |      100 |      100 |                 |
|   IContractExecutor.sol              |      100 |      100 |      100 |      100 |                 |
|   IContractIdentifier.sol            |      100 |      100 |      100 |      100 |                 |
|   IDeploy.sol                        |      100 |      100 |      100 |      100 |                 |
|   IDeployer.sol                      |      100 |      100 |      100 |      100 |                 |
|   IERC20.sol                         |      100 |      100 |      100 |      100 |                 |
|   IERC20MintableBurnable.sol         |      100 |      100 |      100 |      100 |                 |
|   IFinalProxy.sol                    |      100 |      100 |      100 |      100 |                 |
|   IGovernable.sol                    |      100 |      100 |      100 |      100 |                 |
|   IImplementation.sol                |      100 |      100 |      100 |      100 |                 |
|   IInitProxy.sol                     |      100 |      100 |      100 |      100 |                 |
|   IInterchainAddressTracker.sol      |      100 |      100 |      100 |      100 |                 |
|   IInterchainGasEstimation.sol       |      100 |      100 |      100 |      100 |                 |
|   IInterchainGovernance.sol          |      100 |      100 |      100 |      100 |                 |
|   IInterchainMultisig.sol            |      100 |      100 |      100 |      100 |                 |
|   IMulticall.sol                     |      100 |      100 |      100 |      100 |                 |
|   IMultisig.sol                      |      100 |      100 |      100 |      100 |                 |
|   IOperators.sol                     |      100 |      100 |      100 |      100 |                 |
|   IOwnable.sol                       |      100 |      100 |      100 |      100 |                 |
|   IPausable.sol                      |      100 |      100 |      100 |      100 |                 |
|   IProxy.sol                         |      100 |      100 |      100 |      100 |                 |
|   IReentrancyGuard.sol               |      100 |      100 |      100 |      100 |                 |
|   IRoles.sol                         |      100 |      100 |      100 |      100 |                 |
|   IRolesBase.sol                     |      100 |      100 |      100 |      100 |                 |
|   ITimeLock.sol                      |      100 |      100 |      100 |      100 |                 |
|   IUpgradable.sol                    |      100 |      100 |      100 |      100 |                 |
| libs/                                |      100 |    84.38 |      100 |      100 |                 |
|   AddressBytes.sol                   |      100 |      100 |      100 |      100 |                 |
|   AddressString.sol                  |      100 |      100 |      100 |      100 |                 |
|   Bytes32String.sol                  |      100 |      100 |      100 |      100 |                 |
|   ContractAddress.sol                |      100 |      100 |      100 |      100 |                 |
|   ECDSA.sol                          |      100 |       50 |      100 |      100 |                 |
|   SafeNativeTransfer.sol             |      100 |      100 |      100 |      100 |                 |
|   SafeTransfer.sol                   |      100 |       75 |      100 |      100 |                 |
|   StringStorage.sol                  |      100 |      100 |      100 |      100 |                 |
| types/                               |      100 |      100 |      100 |      100 |                 |
|   AmplifierGatewayTypes.sol          |      100 |      100 |      100 |      100 |                 |
|   GasEstimationTypes.sol             |      100 |      100 |      100 |      100 |                 |
|   WeightedMultisigTypes.sol          |      100 |      100 |      100 |      100 |                 |
| upgradable/                          |      100 |      100 |      100 |      100 |                 |
|   BaseProxy.sol                      |      100 |      100 |      100 |      100 |                 |
|   FinalProxy.sol                     |      100 |      100 |      100 |      100 |                 |
|   FixedProxy.sol                     |      100 |      100 |      100 |      100 |                 |
|   Implementation.sol                 |      100 |      100 |      100 |      100 |                 |
|   InitProxy.sol                      |      100 |      100 |      100 |      100 |                 |
|   Proxy.sol                          |      100 |      100 |      100 |      100 |                 |
|   Upgradable.sol                     |      100 |      100 |      100 |      100 |                 |
| utils/                               |      100 |      100 |      100 |      100 |                 |
|   Caller.sol                         |      100 |      100 |      100 |      100 |                 |
|   InterchainAddressTracker.sol       |      100 |      100 |      100 |      100 |                 |
|   Multicall.sol                      |      100 |      100 |      100 |      100 |                 |
|   Operators.sol                      |      100 |      100 |      100 |      100 |                 |
|   Ownable.sol                        |      100 |      100 |      100 |      100 |                 |
|   Pausable.sol                       |      100 |      100 |      100 |      100 |                 |
|   ReentrancyGuard.sol                |      100 |      100 |      100 |      100 |                 |
|   Roles.sol                          |      100 |      100 |      100 |      100 |                 |
|   RolesBase.sol                      |      100 |      100 |      100 |      100 |                 |
|   TimeLock.sol                       |      100 |      100 |      100 |      100 |                 |
|--------------------------------------|----------|----------|----------|----------|-----------------|
| All files                            |    99.64 |    97.59 |    97.65 |    99.86 |                 |
|--------------------------------------|----------|----------|----------|----------|-----------------|

## Miscellaneous
Employees of AXELAR and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.


