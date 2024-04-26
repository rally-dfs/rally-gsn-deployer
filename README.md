## RLY GSN Deployer

This repo contains scripts that makes it very easy to deploy the core gas station network contracts to EVM chains.

### Deploying GSN to a new chain

To deploy GSN to a new chain you need to define all variables specified in `.env.sample` in a `.env` file in your root directory and you need to have `rpc_endpoints` and `etherscan` api keys (if you want to verify contracts on etherscan) defined in the `foundry.toml` config file.

### Deploying core GSN contracts

To deploy the GSN core contracts run the following command

`forge script script/DeployGSN.s.sol:DeployGSN --rpc-url [local, amoy, base, etc] --broadcast --verify -vvvv`

This will deploy the `Forwarder`, `Penalizer`, `StakeManager`, `RelayRegistrar`, `RelayHub` contracts and optionally will deploy a test wrapped native token if the `DEPLOY_TEST_WRAPPED_NATIVE_TOKEN` env variable is set to true.

### Deploying Rally Protocol contracts

To deploy the Rally Protocol contracts run the following command. Note: you need to add a `GSN_FORWARDER` value to your `.env` file before doing this.

`forge script script/DeployRally.s.sol:DeployRally --rpc-url [local, amoy, base, etc] --broadcast --verify -vvvv`

### GSN Deployments

Below are the chains and addresses of the GSN instances that the Rally Protocol team has deployed

_Polygon Amoy_

| Contract Name   | Verified Contract                                                                                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Forwarder       | [0x0ae8FC9867CB4a124d7114B8bd15C4c78C4D40E5] (https://www.oklink.com/amoy/address/0x0ae8fc9867cb4a124d7114b8bd15c4c78c4d40e5) |
| Relay Hub       | [0xe213A20A9E6CBAfd8456f9669D8a0b9e41Cb2751] (https://www.oklink.com/amoy/address/0xe213a20a9e6cbafd8456f9669d8a0b9e41cb2751) |
| Penalizer       | [0xA073Fb6e669e584738B6612656c8f015C16bCE22] (https://www.oklink.com/amoy/address/0xa073fb6e669e584738b6612656c8f015c16bce22) |
| Stake Manager   | [0x855D2D5a7850F32E937a83Dd0eE2763d37c07fF8] (https://www.oklink.com/amoy/address/0x855d2d5a7850f32e937a83dd0ee2763d37c07ff8) |
| Relay Registrar | [0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de] (https://www.oklink.com/amoy/address/0x701c4f4f0339d3a4cf12861e650a20fc7c8fc7de) |
