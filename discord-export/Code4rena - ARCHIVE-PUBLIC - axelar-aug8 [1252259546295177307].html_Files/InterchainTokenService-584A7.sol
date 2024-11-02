// @note deploy InterchainTokenService
address _implementation = address(
    new InterchainTokenService(
        address(tokenManagerDeployer),
        address(interchainTokenDeployer),
        address(mockGateway),
        address(axelarGasService),
        interchainTokenFactoryAddress,
        CHAIN_NAME,
        address(tokenManager),
        address(tokenHandler),
        address(gatewayCaller)
    )
);
_salt = keccak256(abi.encode(DEPLOYMENT_KEY));
address _proxy = create3Deployer.deploy(
    abi.encodePacked(
        type(InterchainProxy).creationCode,
        abi.encode(
            _implementation, DEPLOYER, abi.encode(DEPLOYER, CHAIN_NAME, new string[](0), new address[](0))
        )
    ),
    _salt
);
interchainTokenService = InterchainTokenService(_proxy);