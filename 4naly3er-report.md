

# For the interchain-token-service contracts:

# Report

## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Use of `tx.origin` is unsafe in almost every context | 4 |
| [L-2](#L-2) | Some tokens may revert when zero value transfers are made | 2 |
| [L-3](#L-3) | Missing checks for `address(0)` when assigning values to address state variables | 1 |
| [L-4](#L-4) | Use of `ecrecover` is susceptible to signature malleability | 1 |
| [L-5](#L-5) | `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()` | 10 |
| [L-6](#L-6) | Use of `tx.origin` is unsafe in almost every context | 4 |
| [L-7](#L-7) | `decimals()` is not a part of the ERC-20 standard | 2 |
| [L-8](#L-8) | `domainSeparator()` isn't protected against replay attacks in case of a future chain split  | 2 |
| [L-9](#L-9) | External call recipient may consume all transaction gas | 4 |
| [L-10](#L-10) | Initializers could be front-run | 5 |
| [L-11](#L-11) | Prevent accidentally burning tokens | 32 |
| [L-12](#L-12) | Owner can renounce while system is paused | 1 |
| [L-13](#L-13) | Loss of precision | 4 |
| [L-14](#L-14) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 16 |
| [L-15](#L-15) | File allows a version of solidity that is susceptible to an assembly optimizer bug | 16 |
| [L-16](#L-16) | `symbol()` is not a part of the ERC-20 standard | 4 |
| [L-17](#L-17) | Upgradeable contract not initialized | 8 |
| [L-18](#L-18) | Use of ecrecover is susceptible to signature malleability | 1 |
### <a name="L-1"></a>[L-1] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (4)*:
```solidity
File: ./contracts/utils/GatewayCaller.sol

51:                     tx.origin

61:                     tx.origin

101:                     tx.origin

113:                     tx.origin

```

### <a name="L-2"></a>[L-2] Some tokens may revert when zero value transfers are made
Example: https://github.com/d-xo/weird-erc20#revert-on-zero-value-transfers.

In spite of the fact that EIP-20 [states](https://github.com/ethereum/EIPs/blob/46b9b698815abbfa628cd1097311deee77dd45c5/EIPS/eip-20.md?plain=1#L116) that zero-valued transfers must be accepted, some tokens, such as LEND will revert if this is attempted, which may cause transactions that involve other tokens (such as batch operations) to fully revert. Consider skipping the transfer if the amount is zero, which will also save gas.

*Instances (2)*:
```solidity
File: ./contracts/TokenHandler.sol

179:         IERC20(tokenAddress).safeTransferFrom(from, to, amount);

184:         IERC20(tokenAddress).safeTransfer(to, amount);

```

### <a name="L-3"></a>[L-3] Missing checks for `address(0)` when assigning values to address state variables

*Instances (1)*:
```solidity
File: ./contracts/executable/InterchainTokenExecutable.sol

27:         interchainTokenService = interchainTokenService_;

```

### <a name="L-4"></a>[L-4] Use of `ecrecover` is susceptible to signature malleability
The built-in EVM precompile `ecrecover` is susceptible to signature malleability, which could lead to replay attacks.
References:  <https://swcregistry.io/docs/SWC-117>,  <https://swcregistry.io/docs/SWC-121>, and  <https://medium.com/cryptronics/signature-replay-vulnerabilities-in-smart-contracts-3b6f7596df57>.
While this is not immediately exploitable, this may become a vulnerability if used elsewhere.

*Instances (1)*:
```solidity
File: ./contracts/interchain-token/ERC20Permit.sol

86:         address recoveredAddress = ecrecover(digest, v, r, s);

```

### <a name="L-5"></a>[L-5] `abi.encodePacked()` should not be used with dynamic types when passing the result to a hash function such as `keccak256()`
Use `abi.encode()` instead which will pad items to 32 bytes, which will [prevent hash collisions](https://docs.soliditylang.org/en/v0.8.13/abi-spec.html#non-standard-packed-mode) (e.g. `abi.encodePacked(0x123,0x456)` => `0x123456` => `abi.encodePacked(0x1,0x23456)`, but `abi.encode(0x123,0x456)` => `0x0...1230...456`). "Unless there is a compelling reason, `abi.encode` should be preferred". If there is only one argument to `abi.encodePacked()` it can often be cast to `bytes()` or `bytes32()` [instead](https://ethereum.stackexchange.com/questions/30912/how-to-compare-strings-in-solidity#answer-82739).
If all arguments are strings and or bytes, `bytes.concat()` should be used instead

*Instances (10)*:
```solidity
File: ./contracts/InterchainTokenService.sol

95:     bytes32 internal constant ITS_HUB_CHAIN_NAME_HASH = keccak256(abi.encodePacked(ITS_HUB_CHAIN_NAME));

102:     bytes32 internal constant ITS_HUB_ROUTING_IDENTIFIER_HASH = keccak256(abi.encodePacked(ITS_HUB_ROUTING_IDENTIFIER));

884:         if (keccak256(abi.encodePacked(destinationChain)) == ITS_HUB_CHAIN_NAME_HASH) revert UntrustedChain();

887:         if (keccak256(abi.encodePacked(destinationAddress)) == ITS_HUB_ROUTING_IDENTIFIER_HASH) {

976:             if (keccak256(abi.encodePacked(sourceChain)) != ITS_HUB_CHAIN_NAME_HASH) revert UntrustedChain();

987:             if (keccak256(abi.encodePacked(sourceChain)) == ITS_HUB_CHAIN_NAME_HASH) revert UntrustedChain();

```

```solidity
File: ./contracts/interchain-token/ERC20Permit.sol

80:                 EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,

```

```solidity
File: ./contracts/utils/Create3AddressFixed.sol

24:             uint160(uint256(keccak256(abi.encodePacked(hex'ff', address(this), deploySalt, CREATE_DEPLOY_BYTECODE_HASH))))

27:         deployed = address(uint160(uint256(keccak256(abi.encodePacked(hex'd6_94', deployer, hex'01')))));

```

```solidity
File: ./contracts/utils/TokenManagerDeployer.sol

31:         bytes memory bytecode = abi.encodePacked(type(TokenManagerProxy).creationCode, args);

```

### <a name="L-6"></a>[L-6] Use of `tx.origin` is unsafe in almost every context
According to [Vitalik Buterin](https://ethereum.stackexchange.com/questions/196/how-do-i-make-my-dapp-serenity-proof), contracts should _not_ `assume that tx.origin will continue to be usable or meaningful`. An example of this is [EIP-3074](https://eips.ethereum.org/EIPS/eip-3074#allowing-txorigin-as-signer-1) which explicitly mentions the intention to change its semantics when it's used with new op codes. There have also been calls to [remove](https://github.com/ethereum/solidity/issues/683) `tx.origin`, and there are [security issues](solidity.readthedocs.io/en/v0.4.24/security-considerations.html#tx-origin) associated with using it for authorization. For these reasons, it's best to completely avoid the feature.

*Instances (4)*:
```solidity
File: ./contracts/utils/GatewayCaller.sol

51:                     tx.origin

61:                     tx.origin

101:                     tx.origin

113:                     tx.origin

```

### <a name="L-7"></a>[L-7] `decimals()` is not a part of the ERC-20 standard
The `decimals()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (2)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

200:             tokenDecimals = token.decimals();

291:         uint8 tokenDecimals = token.decimals();

```

### <a name="L-8"></a>[L-8] `domainSeparator()` isn't protected against replay attacks in case of a future chain split 
Severity: Low.
Description: See <https://eips.ethereum.org/EIPS/eip-2612#security-considerations>.
Remediation: Consider using the [implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/EIP712.sol#L77-L90) from OpenZeppelin, which recalculates the domain separator if the current `block.chainid` is not the cached chain ID.
Past occurrences of this issue:
- [Reality Cards Contest](https://github.com/code-423n4/2021-06-realitycards-findings/issues/166)
- [Swivel Contest](https://github.com/code-423n4/2021-09-swivel-findings/issues/98)
- [Malt Finance Contest](https://github.com/code-423n4/2021-11-malt-findings/issues/349)

*Instances (2)*:
```solidity
File: ./contracts/interchain-token/ERC20Permit.sol

53:     function DOMAIN_SEPARATOR() public view returns (bytes32) {

81:                 DOMAIN_SEPARATOR(),

```

### <a name="L-9"></a>[L-9] External call recipient may consume all transaction gas
There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (4)*:
```solidity
File: ./contracts/InterchainTokenService.sol

828:                 IGatewayCaller.callContract.selector,

860:                 IGatewayCaller.callContractWithToken.selector,

```

```solidity
File: ./contracts/utils/GatewayCaller.sol

68:         gateway.callContract(destinationChain, destinationAddress, payload);

120:         gateway.callContractWithToken(destinationChain, destinationAddress, payload, symbol, amount);

```

### <a name="L-10"></a>[L-10] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (5)*:
```solidity
File: ./contracts/interchain-token/InterchainToken.sol

36:         _initialize();

56:     function _initialize() internal {

86:     function init(bytes32 tokenId_, address minter, string calldata tokenName, string calldata tokenSymbol, uint8 tokenDecimals) external {

89:         _initialize();

```

```solidity
File: ./contracts/utils/InterchainTokenDeployer.sol

66:         IInterchainToken(tokenAddress).init(tokenId, minter, name, symbol, decimals);

```

### <a name="L-11"></a>[L-11] Prevent accidentally burning tokens
Minting and burning tokens to address(0) prevention

*Instances (32)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

142:             minterBytes = minter.toBytes();

145:         tokenId = _deployInterchainToken(salt, '', name, symbol, decimals, minterBytes, 0);

153:             token.transferMintership(minter);

157:             tokenManager.addFlowLimiter(minter);

159:             tokenManager.transferOperatorship(minter);

203:                 if (!token.isMinter(minter)) revert NotMinter(minter);

205:                 minter_ = minter.toBytes();

209:         tokenId = _deployInterchainToken(salt, destinationChain, tokenName, tokenSymbol, tokenDecimals, minter_, gasValue);

233:         tokenId = interchainTokenService.deployInterchainToken{ value: gasValue }(

```

```solidity
File: ./contracts/InterchainTokenService.sol

343:             address tokenAddress = _deployInterchainToken(tokenId, minter, name, symbol, decimals);

345:             _deployTokenManager(tokenId, TokenManagerType.NATIVE_INTERCHAIN_TOKEN, abi.encode(minter, tokenAddress));

345:             _deployTokenManager(tokenId, TokenManagerType.NATIVE_INTERCHAIN_TOKEN, abi.encode(minter, tokenAddress));

347:             _deployRemoteInterchainToken(tokenId, name, symbol, decimals, minter, destinationChain, gasValue);

803:         tokenAddress = _deployInterchainToken(tokenId, minterBytes, name, symbol, decimals);

805:         _deployTokenManager(tokenId, TokenManagerType.NATIVE_INTERCHAIN_TOKEN, abi.encode(minterBytes, tokenAddress));

805:         _deployTokenManager(tokenId, TokenManagerType.NATIVE_INTERCHAIN_TOKEN, abi.encode(minterBytes, tokenAddress));

1041:         emit InterchainTokenDeploymentStarted(tokenId, name, symbol, decimals, minter, destinationChain);

1043:         bytes memory payload = abi.encode(MESSAGE_TYPE_DEPLOY_INTERCHAIN_TOKEN, tokenId, name, symbol, decimals, minter);

1101:         if (bytes(minterBytes).length != 0) minter = minterBytes.toAddress();

1103:         (bool success, bytes memory returnData) = interchainTokenDeployer.delegatecall(

1104:             abi.encodeWithSelector(IInterchainTokenDeployer.deployInterchainToken.selector, salt, tokenId, minter, name, symbol, decimals)

1115:         emit InterchainTokenDeployed(tokenId, tokenAddress, minter, name, symbol, decimals);

```

```solidity
File: ./contracts/TokenHandler.sol

59:             _mintToken(tokenManager, tokenAddress, to, amount);

105:             _burnToken(tokenManager, tokenAddress, from, amount);

107:             _burnTokenFrom(tokenAddress, from, amount);

```

```solidity
File: ./contracts/interchain-token/InterchainToken.sol

106:         _addMinter(minter);

118:         _mint(account, amount);

128:         _burn(account, amount);

```

```solidity
File: ./contracts/utils/InterchainTokenDeployer.sol

66:         IInterchainToken(tokenAddress).init(tokenId, minter, name, symbol, decimals);

```

```solidity
File: ./contracts/utils/Minter.sol

23:         _addRole(minter_, uint8(Roles.MINTER));

32:         _transferRole(msg.sender, minter_, uint8(Roles.MINTER));

41:         _proposeRole(msg.sender, minter_, uint8(Roles.MINTER));

```

### <a name="L-12"></a>[L-12] Owner can renounce while system is paused
The contract owner or single user with a role is not prevented from renouncing the role/ownership while the contract is paused, which would cause any user assets stored in the protocol, to be locked indefinitely.

*Instances (1)*:
```solidity
File: ./contracts/InterchainTokenService.sol

594:     function setPauseStatus(bool paused) external onlyOwner {

```

### <a name="L-13"></a>[L-13] Loss of precision
Division by large numbers may result in the result being zero, due to solidity not supporting fractions. Consider requiring a minimum amount for the numerator to ensure that it is always larger than the denominator

*Instances (4)*:
```solidity
File: ./contracts/utils/FlowLimit.sol

66:         uint256 epoch = block.timestamp / EPOCH_TIME;

79:         uint256 epoch = block.timestamp / EPOCH_TIME;

120:         uint256 epoch = block.timestamp / EPOCH_TIME;

135:         uint256 epoch = block.timestamp / EPOCH_TIME;

```

### <a name="L-14"></a>[L-14] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (16)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/InterchainTokenService.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/TokenHandler.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/interchain-token/InterchainToken.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/proxies/InterchainProxy.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/proxies/TokenManagerProxy.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/token-manager/TokenManager.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Create3AddressFixed.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Create3Fixed.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/FlowLimit.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/GatewayCaller.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/InterchainTokenDeployer.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Minter.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Operator.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/RolesConstants.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/TokenManagerDeployer.sol

3: pragma solidity ^0.8.0;

```

### <a name="L-15"></a>[L-15] File allows a version of solidity that is susceptible to an assembly optimizer bug
In solidity versions 0.8.13 and 0.8.14, there is an [optimizer bug](https://github.com/ethereum/solidity-blog/blob/499ab8abc19391be7b7b34f88953a067029a5b45/_posts/2022-06-15-inline-assembly-memory-side-effects-bug.md) where, if the use of a variable is in a separate `assembly` block from the block in which it was stored, the `mstore` operation is optimized out, leading to uninitialized memory. The code currently does not have such a pattern of execution, but it does use `mstore`s in `assembly` blocks, so it is a risk for future changes. The affected solidity versions should be avoided if at all possible.

*Instances (16)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/InterchainTokenService.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/TokenHandler.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/interchain-token/InterchainToken.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/proxies/InterchainProxy.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/proxies/TokenManagerProxy.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/token-manager/TokenManager.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Create3AddressFixed.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Create3Fixed.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/FlowLimit.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/GatewayCaller.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/InterchainTokenDeployer.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Minter.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/Operator.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/RolesConstants.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/utils/TokenManagerDeployer.sol

3: pragma solidity ^0.8.0;

```

### <a name="L-16"></a>[L-16] `symbol()` is not a part of the ERC-20 standard
The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (4)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

199:             tokenSymbol = token.symbol();

290:         string memory tokenSymbol = token.symbol();

317:         string memory symbol = IInterchainToken(token).symbol();

```

```solidity
File: ./contracts/TokenHandler.sol

113:             symbol = IERC20Named(tokenAddress).symbol();

```

### <a name="L-17"></a>[L-17] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (8)*:
```solidity
File: ./contracts/interchain-token/InterchainToken.sol

29:     bytes32 internal constant INITIALIZED_SLOT = 0xc778385ecb3e8cecb82223fa1f343ec6865b2d64c65b0c15c7e8aef225d9e214;

36:         _initialize();

47:     function _isInitialized() internal view returns (bool initialized) {

49:             initialized := sload(INITIALIZED_SLOT)

56:     function _initialize() internal {

58:             sstore(INITIALIZED_SLOT, true)

87:         if (_isInitialized()) revert AlreadyInitialized();

89:         _initialize();

```

### <a name="L-18"></a>[L-18] Use of ecrecover is susceptible to signature malleability
The built-in EVM precompile ecrecover is susceptible to signature malleability, which could lead to replay attacks.Consider using OpenZeppelin’s ECDSA library instead of the built-in function.

*Instances (1)*:
```solidity
File: ./contracts/interchain-token/ERC20Permit.sol

86:         address recoveredAddress = ecrecover(digest, v, r, s);

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 15 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (15)*:
```solidity
File: ./contracts/InterchainTokenFactory.sol

301:     function registerGatewayToken(bytes32 tokenIdentifier, string calldata symbol) external onlyOwner returns (bytes32 tokenId) {

```

```solidity
File: ./contracts/InterchainTokenService.sol

562:     function setFlowLimits(bytes32[] calldata tokenIds, uint256[] calldata flowLimits) external onlyRole(uint8(Roles.OPERATOR)) {

578:     function setTrustedAddress(string memory chain, string memory address_) external onlyOwner {

586:     function removeTrustedAddress(string memory chain) external onlyOwner {

594:     function setPauseStatus(bool paused) external onlyOwner {

```

```solidity
File: ./contracts/interchain-token/InterchainToken.sol

117:     function mint(address account, uint256 amount) external onlyRole(uint8(Roles.MINTER)) {

127:     function burn(address account, uint256 amount) external onlyRole(uint8(Roles.MINTER)) {

```

```solidity
File: ./contracts/token-manager/TokenManager.sol

131:     function transferFlowLimiter(address from, address to) external onlyRole(uint8(Roles.OPERATOR)) {

140:     function addFlowLimiter(address flowLimiter) external onlyRole(uint8(Roles.OPERATOR)) {

149:     function removeFlowLimiter(address flowLimiter) external onlyRole(uint8(Roles.OPERATOR)) {

167:     function setFlowLimit(uint256 flowLimit_) external onlyRole(uint8(Roles.FLOW_LIMITER)) {

```

```solidity
File: ./contracts/utils/Minter.sol

31:     function transferMintership(address minter_) external onlyRole(uint8(Roles.MINTER)) {

40:     function proposeMintership(address minter_) external onlyRole(uint8(Roles.MINTER)) {

```

```solidity
File: ./contracts/utils/Operator.sol

32:     function transferOperatorship(address operator) external onlyRole(uint8(Roles.OPERATOR)) {

41:     function proposeOperatorship(address operator) external onlyRole(uint8(Roles.OPERATOR)) {

```


# For the EVM Amplifier Gateway contracts:

# Report




## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | `domainSeparator()` isn't protected against replay attacks in case of a future chain split  | 6 |
| [L-2](#L-2) | Solidity version 0.8.20+ may not work on other chains due to `PUSH0` | 2 |
| [L-3](#L-3) | File allows a version of solidity that is susceptible to an assembly optimizer bug | 2 |
### <a name="L-1"></a>[L-1] `domainSeparator()` isn't protected against replay attacks in case of a future chain split 
Severity: Low.
Description: See <https://eips.ethereum.org/EIPS/eip-2612#security-considerations>.
Remediation: Consider using the [implementation](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/EIP712.sol#L77-L90) from OpenZeppelin, which recalculates the domain separator if the current `block.chainid` is not the cached chain ID.
Past occurrences of this issue:
- [Reality Cards Contest](https://github.com/code-423n4/2021-06-realitycards-findings/issues/166)
- [Swivel Contest](https://github.com/code-423n4/2021-09-swivel-findings/issues/98)
- [Malt Finance Contest](https://github.com/code-423n4/2021-11-malt-findings/issues/349)

*Instances (6)*:
```solidity
File: ./contracts/gateway/AxelarAmplifierGateway.sol

32:         bytes32 domainSeparator_,

34:     ) BaseWeightedMultisig(previousSignersRetention_, domainSeparator_, minimumRotationDelay_) {}

```

```solidity
File: ./contracts/governance/BaseWeightedMultisig.sol

31:     bytes32 public immutable domainSeparator;

46:         bytes32 domainSeparator_,

50:         domainSeparator = domainSeparator_;

251:         return keccak256(bytes.concat('\x19Ethereum Signed Message:\n96', domainSeparator, signersHash, dataHash));

```

### <a name="L-2"></a>[L-2] Solidity version 0.8.20+ may not work on other chains due to `PUSH0`
The compiler for Solidity 0.8.20 switches the default target EVM version to [Shanghai](https://blog.soliditylang.org/2023/05/10/solidity-0.8.20-release-announcement/#important-note), which includes the new `PUSH0` op code. This op code may not yet be implemented on all L2s, so deployment on these chains will fail. To work around this issue, use an earlier [EVM](https://docs.soliditylang.org/en/v0.8.20/using-the-compiler.html?ref=zaryabs.com#setting-the-evm-version-to-target) [version](https://book.getfoundry.sh/reference/config/solidity-compiler#evm_version). While the project itself may or may not compile with 0.8.20, other projects with which it integrates, or which extend this project may, and those projects will have problems deploying these contracts/libraries.

*Instances (2)*:
```solidity
File: ./contracts/gateway/AxelarAmplifierGateway.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/gateway/AxelarAmplifierGatewayProxy.sol

3: pragma solidity ^0.8.0;

```

### <a name="L-3"></a>[L-3] File allows a version of solidity that is susceptible to an assembly optimizer bug
In solidity versions 0.8.13 and 0.8.14, there is an [optimizer bug](https://github.com/ethereum/solidity-blog/blob/499ab8abc19391be7b7b34f88953a067029a5b45/_posts/2022-06-15-inline-assembly-memory-side-effects-bug.md) where, if the use of a variable is in a separate `assembly` block from the block in which it was stored, the `mstore` operation is optimized out, leading to uninitialized memory. The code currently does not have such a pattern of execution, but it does use `mstore`s in `assembly` blocks, so it is a risk for future changes. The affected solidity versions should be avoided if at all possible.

*Instances (2)*:
```solidity
File: ./contracts/gateway/AxelarAmplifierGateway.sol

3: pragma solidity ^0.8.0;

```

```solidity
File: ./contracts/gateway/AxelarAmplifierGatewayProxy.sol

3: pragma solidity ^0.8.0;

```


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Lack of EIP-712 compliance: using `keccak256()` directly on an array or struct variable | 3 |
### <a name="M-1"></a>[M-1] Lack of EIP-712 compliance: using `keccak256()` directly on an array or struct variable
Directly using the actual variable instead of encoding the array values goes against the EIP-712 specification https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#definition-of-encodedata. 
**Note**: OpenSea's [Seaport's example with offerHashes and considerationHashes](https://github.com/ProjectOpenSea/seaport/blob/a62c2f8f484784735025d7b03ccb37865bc39e5a/reference/lib/ReferenceGettersAndDerivers.sol#L130-L131) can be used as a reference to understand how array of structs should be encoded.

*Instances (3)*:
```solidity
File: ./contracts/gateway/AxelarAmplifierGateway.sol

81:         bytes32 dataHash = keccak256(abi.encode(CommandType.ApproveMessages, messages));

97:         bytes32 dataHash = keccak256(abi.encode(CommandType.RotateSigners, newSigners));

```

```solidity
File: ./contracts/governance/BaseWeightedMultisig.sol

119:         bytes32 signersHash = keccak256(abi.encode(signers));

```
