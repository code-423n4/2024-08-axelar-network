
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

### Publicly Known Issues: 
#### ITS hub balance tracking should be applied when minter isn't set (https://github.com/axelarnetwork/interchain-token-service/issues/270)
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
Axelar Amplifier Gateway is a smart contract that lives on the external chain that is connecting to the Axelar Network. It faciliates sending and receiving of cross-chain messages to other chains via the Axelar Network. AxelarAmplifierGateway is the EVM reference implementation of the external gateway.

## Links

- **Previous audits:**  https://github.com/axelarnetwork/audits?tab=readme-ov-file
- **Documentation:** https://docs.axelar.dev/
- **Website:** https://www.axelar.network/
- **X/Twitter:** https://twitter.com/axelarnetwork
- **Discord:** https://discord.com/invite/aRZ3Ra6f7D
- **Youtube:** https://www.youtube.com/@axelar-network

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
<pre>----------------------------------------|----------|----------|----------|----------|----------------|
File                                    |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
----------------------------------------|----------|----------|----------|----------|----------------|
 <font color="#26A269"><b>contracts/                            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    95.76</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    99.18</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenFactory.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenService.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    95.68</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>TokenHandler.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    94.23</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    95.38</b></font> |<font color="#C01C28"><b>     78,116,155</b></font> |
 <font color="#26A269"><b>contracts/executable/                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenExecutable.sol        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenExpressExecutable.sol </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/interchain-token/           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ERC20.sol                            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ERC20Permit.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainToken.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenStandard.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/interfaces/                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAddressTracker.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IBaseTokenManager.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IERC20BurnableFrom.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IERC20MintableBurnable.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IERC20Named.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IFlowLimit.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IGatewayCaller.sol                   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainToken.sol                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenDeployer.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenExecutable.sol       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenExpressExecutable.sol</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenFactory.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenService.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainTokenStandard.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IMinter.sol                          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IOperator.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenHandler.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenManager.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenManagerDeployer.sol            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenManagerImplementation.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenManagerProxy.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITokenManagerType.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITransmitInterchainToken.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/proxies/                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainProxy.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>TokenManagerProxy.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/token-manager/              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    96.15</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>TokenManager.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    96.15</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/types/                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainTokenServiceTypes.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>contracts/utils/                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>     87.5</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    97.44</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create3AddressFixed.sol              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create3Fixed.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    83.33</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>FlowLimit.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>GatewayCaller.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    83.33</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    85.71</b></font> |<font color="#C01C28"><b>         64,116</b></font> |
  <font color="#26A269"><b>InterchainTokenDeployer.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>       75</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Minter.sol                           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Operator.sol                         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>RolesConstants.sol                   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>TokenManagerDeployer.sol             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>       50</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
----------------------------------------|----------|----------|----------|----------|----------------|
<font color="#26A269"><b>All files                              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    95.45</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    99.11</b></font> |<font color="#C01C28"><b>               </b></font> |
----------------------------------------|----------|----------|----------|----------|----------------|
</pre>

- Test coverage for EVM Amplifier Gateway contracts: 

<pre>-------------------------------------|----------|----------|----------|----------|----------------|
File                                 |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
-------------------------------------|----------|----------|----------|----------|----------------|
 <font color="#26A269"><b>deploy/                            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    94.44</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ConstAddressDeployer.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create2.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create2Deployer.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create3.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    83.33</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create3Address.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Create3Deployer.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>CreateDeploy.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Deployer.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>executable/                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    81.82</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarExecutable.sol              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>       60</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarGMPExecutable.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarGMPExecutableWithToken.sol  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>express/                           </b></font> |<font color="#26A269"><b>    97.73</b></font> |<font color="#26A269"><b>    95.24</b></font> |<font color="#26A269"><b>    83.33</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarExpressExecutable.sol       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>    71.43</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarValuedExpressExecutable.sol </b></font> |<font color="#26A269"><b>    95.92</b></font> |<font color="#26A269"><b>    91.67</b></font> |<font color="#A2734C"><b>    77.78</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ExpressExecutorTracker.sol        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>gas-estimation/                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    91.67</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    97.83</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainGasEstimation.sol       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    91.67</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    97.83</b></font> |<font color="#C01C28"><b>            103</b></font> |
 <font color="#26A269"><b>gateway/                           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarAmplifierGateway.sol        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarAmplifierGatewayProxy.sol   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>BaseAmplifierGateway.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>governance/                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AxelarServiceGovernance.sol       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>BaseMultisig.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>BaseWeightedMultisig.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainGovernance.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainMultisig.sol            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Multisig.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>interfaces/                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarAmplifierAuth.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarAmplifierGateway.sol       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarAmplifierGatewayAuth.sol   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarExecutable.sol             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarExpressExecutable.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGMPExecutable.sol          </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGMPExecutableWithToken.sol </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGMPGateway.sol             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGMPGatewayWithToken.sol    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGasService.sol             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarGateway.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarServiceGovernance.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IAxelarValuedExpressExecutable.sol</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IBaseAmplifierGateway.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IBaseMultisig.sol                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IBaseWeightedMultisig.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ICaller.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IContractExecutor.sol             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IContractIdentifier.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IDeploy.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IDeployer.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IERC20.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IERC20MintableBurnable.sol        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IFinalProxy.sol                   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IGovernable.sol                   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IImplementation.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInitProxy.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainAddressTracker.sol     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainGasEstimation.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainGovernance.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IInterchainMultisig.sol           </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IMulticall.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IMultisig.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IOperators.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IOwnable.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IPausable.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IProxy.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IReentrancyGuard.sol              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IRoles.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IRolesBase.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ITimeLock.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>IUpgradable.sol                   </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>libs/                              </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>    84.38</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AddressBytes.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AddressString.sol                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Bytes32String.sol                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ContractAddress.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ECDSA.sol                         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>       50</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>SafeNativeTransfer.sol            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>SafeTransfer.sol                  </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#A2734C"><b>       75</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>StringStorage.sol                 </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>types/                             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>AmplifierGatewayTypes.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>GasEstimationTypes.sol            </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>WeightedMultisigTypes.sol         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>upgradable/                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>BaseProxy.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>FinalProxy.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>FixedProxy.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Implementation.sol                </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InitProxy.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Proxy.sol                         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Upgradable.sol                    </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
 <font color="#26A269"><b>utils/                             </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Caller.sol                        </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>InterchainAddressTracker.sol      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Multicall.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Operators.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Ownable.sol                       </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Pausable.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>ReentrancyGuard.sol               </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>Roles.sol                         </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>RolesBase.sol                     </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
  <font color="#26A269"><b>TimeLock.sol                      </b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#26A269"><b>      100</b></font> |<font color="#C01C28"><b>               </b></font> |
-------------------------------------|----------|----------|----------|----------|----------------|
<font color="#26A269"><b>All files                           </b></font> |<font color="#26A269"><b>    99.64</b></font> |<font color="#26A269"><b>    97.59</b></font> |<font color="#26A269"><b>    97.65</b></font> |<font color="#26A269"><b>    99.86</b></font> |<font color="#C01C28"><b>               </b></font> |
-------------------------------------|----------|----------|----------|----------|----------------|
</pre>
## Miscellaneous
Employees of AXELAR and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.


