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

| Contract Name   | Verified Contract                                                                                                            |
| --------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Forwarder       | [0x0ae8FC9867CB4a124d7114B8bd15C4c78C4D40E5](https://www.oklink.com/amoy/address/0x0ae8fc9867cb4a124d7114b8bd15c4c78c4d40e5) |
| Relay Hub       | [0xe213A20A9E6CBAfd8456f9669D8a0b9e41Cb2751](https://www.oklink.com/amoy/address/0xe213a20a9e6cbafd8456f9669d8a0b9e41cb2751) |
| Penalizer       | [0xA073Fb6e669e584738B6612656c8f015C16bCE22](https://www.oklink.com/amoy/address/0xa073fb6e669e584738b6612656c8f015c16bce22) |
| Stake Manager   | [0x855D2D5a7850F32E937a83Dd0eE2763d37c07fF8](https://www.oklink.com/amoy/address/0x855d2d5a7850f32e937a83dd0ee2763d37c07ff8) |
| Relay Registrar | [0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de](https://www.oklink.com/amoy/address/0x701c4f4f0339d3a4cf12861e650a20fc7c8fc7de) |

#### Base Mainnet

| Contract Name        | Verified Contract                                                                                                          |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Forwarder            | [0x524266345fB331cb624E27D2Cf5B61E769527FCC](https://basescan.org/address/0x524266345fB331cb624E27D2Cf5B61E769527FCC#code) |
| Relay Hub            | [0x54623092d2dB00D706e0Ad4ADaCc024F9cB9E915](https://basescan.org/address/0x54623092d2dB00D706e0Ad4ADaCc024F9cB9E915#code) |
| Penalizer            | [0x8B29D3251Bc1375A3dd216A70C980d6d676792fd](https://basescan.org/address/0x8B29D3251Bc1375A3dd216A70C980d6d676792fd#code) |
| Stake Manager        | [0x572cf3C8342A79Da85420A248dA8C3005c1aA52f](https://basescan.org/address/0x572cf3C8342A79Da85420A248dA8C3005c1aA52f#code) |
| Relay Registrar      | [0x713A90b371945d5e807B2f5b21733F602Fc2A79e](https://basescan.org/address/0x713A90b371945d5e807B2f5b21733F602Fc2A79e#code) |
| Staking Token (WETH) | [0x4200000000000000000000000000000000000006](https://basescan.org/address/0x4200000000000000000000000000000000000006#code) |

#### Base Sepolia

| Contract Name        | Verified Contract                                                                                                                  |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Forwarder            | [0xabf9Fa3b2b2d9bDd77f4271A0d5A309AA465BCBa](https://sepolia.basescan.org/address/0xabf9Fa3b2b2d9bDd77f4271A0d5A309AA465BCBa#code) |
| Relay Hub            | [0xb570b57b821670707fF4E38Ea53fcb67192278F8](https://sepolia.basescan.org/address/0xb570b57b821670707fF4E38Ea53fcb67192278F8#code) |
| Penalizer            | [0xb383A58F83f3C40ac6A981a93fBdb91031945e7f](https://sepolia.basescan.org/address/0xb383A58F83f3C40ac6A981a93fBdb91031945e7f#code) |
| Stake Manager        | [0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD](https://sepolia.basescan.org/address/0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD#code) |
| Relay Registrar      | [0x6b3469Ef584F932A8b0AC86FCDfC8C4617d87026](https://sepolia.basescan.org/address/0x6b3469Ef584F932A8b0AC86FCDfC8C4617d87026#code) |
| Staking Token (WETH) | [0xf1BC75Bea77a43e0a2891C694a1BA760a87C30af](https://sepolia.basescan.org/address/0xf1BC75Bea77a43e0a2891C694a1BA760a87C30af#code) |

#### Arbitrum Mainnet

| Contract Name        | Verified Contract                                                                                                         |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Forwarder            | [0x524266345fB331cb624E27D2Cf5B61E769527FCC](https://arbiscan.io/address/0x524266345fB331cb624E27D2Cf5B61E769527FCC#code) |
| Relay Hub            | [0xCcF30E6fd38B292F79E0AfF3cE2FC97BD4Fc8948](https://arbiscan.io/address/0xCcF30E6fd38B292F79E0AfF3cE2FC97BD4Fc8948#code) |
| Penalizer            | [0x8B29D3251Bc1375A3dd216A70C980d6d676792fd](https://arbiscan.io/address/0x8B29D3251Bc1375A3dd216A70C980d6d676792fd#code) |
| Stake Manager        | [0x572cf3C8342A79Da85420A248dA8C3005c1aA52f](https://arbiscan.io/address/0x572cf3C8342A79Da85420A248dA8C3005c1aA52f#code) |
| Relay Registrar      | [0x713A90b371945d5e807B2f5b21733F602Fc2A79e](https://arbiscan.io/address/0x713A90b371945d5e807B2f5b21733F602Fc2A79e#code) |
| Staking Token (WETH) | [0x82aF49447D8a07e3bd95BD0d56f35241523fBab1](https://arbiscan.io/address/0x82aF49447D8a07e3bd95BD0d56f35241523fBab1#code) |

#### Arbitrum Sepolia

| Contract Name        | Verified Contract                                                                                                                 |
| -------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Forwarder            | [0xAdB19AFE14a665558179d88c39040579150C905a](https://sepolia.arbiscan.io/address/0xAdB19AFE14a665558179d88c39040579150C905a#code) |
| Relay Hub            | [0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD](https://sepolia.arbiscan.io/address/0xbA402ebB287539b29D73C78ea9b5bc53CD9737fD#code) |
| Penalizer            | [0x19D45f6c322157708975B93f22920800054b193a](https://sepolia.arbiscan.io/address/0x19D45f6c322157708975B93f22920800054b193a#code) |
| Stake Manager        | [0x855D2D5a7850F32E937a83Dd0eE2763d37c07fF8](https://sepolia.arbiscan.io/address/0x855D2D5a7850F32E937a83Dd0eE2763d37c07fF8#code) |
| Relay Registrar      | [0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de](https://sepolia.arbiscan.io/address/0x701C4f4F0339d3A4cf12861E650a20fC7c8FC7de#code) |
| Staking Token (WETH) | [0x2144c1d6f0734dDb11469406f05ff2E4d4C07a94](https://sepolia.arbiscan.io/address/0x2144c1d6f0734dDb11469406f05ff2E4d4C07a94#code) |

### Rally Deployments

Below are the chains and addresses that the Rally core contracts have been deployed to

#### Base Mainnet

| Contract Name | Verified Contract                                                                                                          |
| ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Paymaster     | [0x01B83B33F0DD8be68627a9BE68E9e7E3c209a6b1](https://basescan.org/address/0x01B83B33F0DD8be68627a9BE68E9e7E3c209a6b1#code) |

#### Base Sepolia

| Contract Name           | Verified Contract                                                                                                                  |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Paymaster               | [0x9bf59A7924cBa2475A03AD77e92fcf1Eaddb2Cc2](https://sepolia.basescan.org/address/0x9bf59A7924cBa2475A03AD77e92fcf1Eaddb2Cc2#code) |
| ERC20 Permit Token      | [0x846D8a5fb8a003b431b67115f809a9B9FFFe5012](https://sepolia.basescan.org/address/0x846D8a5fb8a003b431b67115f809a9B9FFFe5012#code) |
| ERC20 Exec Metatx Token | [0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2](https://sepolia.basescan.org/address/0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2#code) |
| ERC20 Permit Faucet     | [0xFCfC511B8915D3aFD0eadc794A0c4151278fE7D1](https://sepolia.basescan.org/address/0xFCfC511B8915D3aFD0eadc794A0c4151278fE7D1#code) |
| ERC20 Metatx Faucet     | [0xCeCFB48a9e7C0765Ed1319ee1Bc0F719a30641Ce](https://sepolia.basescan.org/address/0xCeCFB48a9e7C0765Ed1319ee1Bc0F719a30641Ce#code) |
| TestNFT                 | [0xBe1b586eA7D09062b924b0899908B48801615013](https://sepolia.basescan.org/address/0xBe1b586eA7D09062b924b0899908B48801615013#code) |

#### Arbitrum Mainnet

| Contract Name | Verified Contract                                                                                                         |
| ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| Paymaster     | [0x974f6DB83C5F6f4a4f75a97D43f80a0b5d058eF8](https://arbiscan.io/address/0x974f6DB83C5F6f4a4f75a97D43f80a0b5d058eF8#code) |

#### Arbitrum Sepolia

| Contract Name           | Verified Contract                                                                                                                 |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Paymaster               | [0x758641a1b566998CaC5Bc5fC8032F001e1CEBeEf](https://sepolia.arbiscan.io/address/0x758641a1b566998CaC5Bc5fC8032F001e1CEBeEf#code) |
| ERC20 Permit Token      | [0x0e20E8A953a1e7D5FD4B24F12aC021b6345F364F](https://sepolia.arbiscan.io/address/0x0e20E8A953a1e7D5FD4B24F12aC021b6345F364F#code) |
| ERC20 Exec Metatx Token | [0xE23A288513BbeA9e5Cd19CE4114bf75C34D794AD](https://sepolia.arbiscan.io/address/0xE23A288513BbeA9e5Cd19CE4114bf75C34D794AD#code) |
| ERC20 Permit Faucet     | [0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2](https://sepolia.arbiscan.io/address/0x16723e9bb894EfC09449994eC5bCF5b41EE0D9b2#code) |
| ERC20 Metatx Faucet     | [0xb8c8274f775474f4F2549EdcC4Db45cbAD936fac](https://sepolia.arbiscan.io/address/0xb8c8274f775474f4F2549EdcC4Db45cbAD936fac#code) |
