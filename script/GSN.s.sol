// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Forwarder} from "gsn/src/forwarder/Forwarder.sol";
import {Penalizer} from "gsn/src/Penalizer.sol";
import {StakeManager} from "gsn/src/StakeManager.sol";
import {RelayRegistrar} from "gsn/src/utils/RelayRegistrar.sol";
import {RelayHub} from "gsn/src/RelayHub.sol";
import {IRelayHub} from "gsn/src/interfaces/IRelayHub.sol";
import {RLYVerifyPaymaster} from "src/RLYVerifyPaymaster.sol";

contract GSNScript is Script {
    address constant devAddress = 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789;
    address constant paymasterSigner =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    Forwarder public forwarder;
    Penalizer public penalizer;
    StakeManager public stakemanager;
    RelayRegistrar public relayRegistrar;
    RelayHub public relayHub;
    RLYVerifyPaymaster public rlyVerifyPaymaster;
    string constant RELAY_REQUEST_NAME = "RelayRequest";
    string constant RELAY_REQUEST_TYPE =
        "RelayData relayData)RelayData(uint256 maxFeePerGas,uint256 maxPriorityFeePerGas,uint256 transactionCalldataGasUsed,address relayWorker,address paymaster,address forwarder,bytes paymasterData,uint256 clientId)";
    string constant GSN_DOMAIN_SEPERATOR_NAME = "GSN Relayed Transaction";
    string constant GSN_VERSION = "3";
    uint256 constant PENALIZE_BLOCK_DELAY = 5;
    uint256 constant PENALIZE_BLOCK_EXPIRATION = 60000;
    uint256 constant DEFAULT_STAKE_MANAGER_MAX_UNSTAKE_DELAY = 100000000;
    uint256 constant ABANDONMENT_DELAY = 31536000;
    uint256 constant ESCHEATMENT_DELAY = 2629746;
    address constant BURN_ADDRESS = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
    uint256 constant REGISTRATION_MAX_AGE = 180 * 24 * 3600;
    IRelayHub.RelayHubConfig public config;

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("MUMBAI_PK");
        vm.startBroadcast(deployerPrivateKey);

        forwarder = new Forwarder();
        forwarder.registerRequestType(RELAY_REQUEST_NAME, RELAY_REQUEST_TYPE);
        forwarder.registerDomainSeparator(
            GSN_DOMAIN_SEPERATOR_NAME,
            GSN_VERSION
        );
        penalizer = new Penalizer(
            PENALIZE_BLOCK_DELAY,
            PENALIZE_BLOCK_EXPIRATION
        );

        stakemanager = new StakeManager(
            DEFAULT_STAKE_MANAGER_MAX_UNSTAKE_DELAY,
            ABANDONMENT_DELAY,
            ESCHEATMENT_DELAY,
            BURN_ADDRESS,
            devAddress
        );

        relayRegistrar = new RelayRegistrar(REGISTRATION_MAX_AGE);
        config = IRelayHub.RelayHubConfig({
            maxWorkerCount: 10,
            gasReserve: 100000,
            postOverhead: 38516,
            gasOverhead: 34909,
            minimumUnstakeDelay: 15000,
            devAddress: devAddress,
            devFee: 0,
            baseRelayFee: 0,
            pctRelayFee: 0
        });
        relayHub = new RelayHub(
            stakemanager,
            address(penalizer),
            address(0),
            address(relayRegistrar),
            config
        );

        rlyVerifyPaymaster = new RLYVerifyPaymaster();
        rlyVerifyPaymaster.setSigner(paymasterSigner);

        vm.stopBroadcast();
    }
}