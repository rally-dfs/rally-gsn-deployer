// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {Forwarder} from "gsn/src/forwarder/Forwarder.sol";
import {Penalizer} from "gsn/src/Penalizer.sol";
import {StakeManager} from "gsn/src/StakeManager.sol";
import {RelayRegistrar} from "gsn/src/utils/RelayRegistrar.sol";
import {RelayHub} from "gsn/src/RelayHub.sol";
import {ArbRelayHub} from "gsn/src/arbitrum/ArbRelayHub.sol";
import {ArbSys} from "gsn/src/arbitrum/ArbSys.sol";
import {IRelayHub} from "gsn/src/interfaces/IRelayHub.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {RLYVerifyPaymaster} from "src/RLYVerifyPaymaster.sol";
import {TestWrappedNativeToken} from "src/tokens/TestWrappedNativeToken.sol";

contract DeployGSN is Script {

    IERC20[] _stakingTokens;
    uint256[] _minimumStakes;
    RelayHub relayHub;

    function run() public {      

        bytes32 _salt;
        uint _deployerPrivateKey;
        address devAddress = vm.envAddress("GSN_DEV_ADDRESS");

        if(keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("local")))){
           _deployerPrivateKey =  vm.envUint("LOCAL_PK");
        } else if (keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("testnet"))))  {
            _salt = vm.envBytes32("TESTNET_SALT");
            _deployerPrivateKey =  vm.envUint("TESTNET_PK");
        } else if (keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("mainnet"))))  {
            _salt = vm.envBytes32("MAINNET_SALT");
            _deployerPrivateKey =  vm.envUint("MAINNET_PK");
        }

        vm.startBroadcast(_deployerPrivateKey);

        Forwarder forwarder = new Forwarder{salt: _salt} ();
        forwarder.registerRequestType(vm.envString("RELAY_REQUEST_NAME"), vm.envString("RELAY_REQUEST_SUFFIX"));
        forwarder.registerDomainSeparator(
            vm.envString("GSN_DOMAIN_SEPERATOR_NAME"),
            vm.envString("GSN_VERSION")
        );
        Penalizer penalizer = new Penalizer{salt: _salt}(
            vm.envUint("PENALIZE_BLOCK_DELAY"),
            vm.envUint("PENALIZE_BLOCK_EXPIRATION")
        );

        StakeManager stakemanager = new StakeManager(
            vm.envUint("DEFAULT_STAKE_MANAGER_MAX_UNSTAKE_DELAY"),
            vm.envUint("ABANDONMENT_DELAY"),
            vm.envUint("ESCHEATMENT_DELAY"),
            vm.envAddress("BURN_ADDRESS"),
            devAddress
        );

        RelayRegistrar relayRegistrar = new RelayRegistrar(vm.envUint("REGISTRATION_MAX_AGE"));
        IRelayHub.RelayHubConfig memory config = IRelayHub.RelayHubConfig({
            maxWorkerCount: vm.envUint("MAX_WORKER_COUNT"),
            gasReserve: vm.envUint("GAS_RESERVE"),
            postOverhead: vm.envUint("POST_OVERHEAD"),
            gasOverhead: vm.envUint("GAS_OVERHEAD"),
            minimumUnstakeDelay: vm.envUint("MINIMUM_UNSTAKE_DELAY_RELAYHUB"),
            devAddress: devAddress,
            devFee: uint8(vm.envUint("DEV_FEE")),
            baseRelayFee: uint8(vm.envUint("BASE_RELAY_FEE")),
            pctRelayFee: uint8(vm.envUint("PCT_RELAY_FEE"))
        });

        if(vm.envBool("IS_ARBITRUM")){
            relayHub = new ArbRelayHub(
            ArbSys(vm.envAddress("ARB_SYS")),
            stakemanager,
            address(penalizer),
            address(0),
            address(relayRegistrar),
            config
        );
        } else {
            relayHub = new RelayHub(
            stakemanager,
            address(penalizer),
            address(0),
            address(relayRegistrar),
            config
        );
        }

        IERC20 stakingToken; 

        if(vm.envBool("DEPLOY_TEST_WRAPPED_NATIVE_TOKEN")){
            stakingToken = new TestWrappedNativeToken{salt: _salt}(vm.envString("WRAPPED_NATIVE_TOKEN_NAME"), vm.envString("WRAPPED_NATIVE_TOKEN_SYMBOL"));
        } else {
            stakingToken = IERC20(vm.envAddress("WRAPPED_NATIVE_TOKEN_ADDRESS"));
        }

        _stakingTokens.push(stakingToken);
        _minimumStakes.push(vm.envUint("MINIMUM_STAKE"));

      
        relayHub.setMinimumStakes(_stakingTokens, _minimumStakes);
        
    
        console2.log("forwarder address");
        console2.logAddress(address(forwarder));
        console2.log("penalizer address");
        console2.logAddress(address(penalizer));
        console2.log("stake manager address");
        console2.logAddress(address(stakemanager));
        console2.log("relay registrar address");
        console2.logAddress(address(relayRegistrar));
        console2.log("relay hub address");
        console2.logAddress(address(relayHub));
        console2.log("staking token address");
        console2.logAddress(address(stakingToken));
        vm.stopBroadcast();
    }
}