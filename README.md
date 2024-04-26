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

#### Polygon Amoy

| Contract Name   | Verified Contract                                                                                                             |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Forwarder       | [0x0ae8FC9867CB4a124d7114B8bd15C4c78C4D40E5] (https://www.oklink.com/amoy/address/0x0ae8fc9867cb4a124d7114b8bd15c4c78c4d40e5) |
| Relay Hub       | [0xe213A20A9E6CBAfd8456f9669D8a0b9e41Cb2751] (https://www.oklink.com/amoy/address/0xe213a20a9e6cbafd8456f9669d8a0b9e41cb2751) |
| Penalizer       | [0xA073Fb6e669e584738B6612656c8f015C16bCE22] (https://www.oklink.com/amoy/address/0xa073fb6e669e584738b6612656c8f015c16bce22) |
| Stake Manager   | [0x855D2D5a7850F32E937a83Dd0eE2763d37c07fF8] (https://www.oklink.com/amoy/address/0x855d2d5a7850f32e937a83dd0ee2763d37c07ff8) |
| Relay Registrar | [0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de] (https://www.oklink.com/amoy/address/0x701c4f4f0339d3a4cf12861e650a20fc7c8fc7de) |

#### Base Sepolia

| Contract Name        | Verified Contract                                                                                                                   |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Forwarder            | [0xabf9Fa3b2b2d9bDd77f4271A0d5A309AA465BCBa] (https://sepolia.basescan.org/address/0xabf9Fa3b2b2d9bDd77f4271A0d5A309AA465BCBa#code) |
| Relay Hub            | [0xb570b57b821670707fF4E38Ea53fcb67192278F8] (https://sepolia.basescan.org/address/0xb570b57b821670707fF4E38Ea53fcb67192278F8#code) |
| Penalizer            | [0xb383A58F83f3C40ac6A981a93fBdb91031945e7f] (https://sepolia.basescan.org/address/0xb383A58F83f3C40ac6A981a93fBdb91031945e7f#code) |
| Stake Manager        | [0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD] (https://sepolia.basescan.org/address/0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD#code) |
| Relay Registrar      | [0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de] (https://sepolia.basescan.org/address/0x6b3469Ef584F932A8b0AC86FCDfC8C4617d87026#code) |
| Staking Token (WETH) | [0xf1BC75Bea77a43e0a2891C694a1BA760a87C30af] (https://sepolia.basescan.org/address/0x6b3469Ef584F932A8b0AC86FCDfC8C4617d87026#code) |

### Rally Deployments

### Base Sepolia

| Contract Name           | Verified Contract                                                                                                                   |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Paymaster               | [0x0e20E8A953a1e7D5FD4B24F12aC021b6345F364F] (https://sepolia.basescan.org/address/0x0e20E8A953a1e7D5FD4B24F12aC021b6345F364F#code) |
| ERC20 Permit Token      | [0x846D8a5fb8a003b431b67115f809a9B9FFFe5012] (https://sepolia.basescan.org/address/0x846D8a5fb8a003b431b67115f809a9B9FFFe5012#code) |
| ERC20 Exec Metatx Token | [0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2] (https://sepolia.basescan.org/address/0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2#code) |
| ERC20 Permit Faucet     | [0x5e2a2800dc11c3884032B1E7c2882Ac68c9C35c0] (https://sepolia.basescan.org/address/0x5e2a2800dc11c3884032B1E7c2882Ac68c9C35c0#code) |
| ERC20 Metatx Faucet     | [0x1544267c4E158dFD81541fBbCcEBfCda96768A6E] (https://sepolia.basescan.org/address/0x1544267c4E158dFD81541fBbCcEBfCda96768A6E#code) |
