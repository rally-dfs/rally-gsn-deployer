// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";

import {IRelayHub} from "gsn/src/interfaces/IRelayHub.sol";
import {IStakeManager} from "gsn/src/interfaces/IStakeManager.sol";
import {RelayHub} from "gsn/src/RelayHub.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {TestWrappedNativeToken} from "src/tokens/TestWrappedNativeToken.sol";

contract RegisterRelayer is Script {

    function run() public {      

        uint _deployerPrivateKey;
        address _deployerAddress;

        if(keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("local")))){
           _deployerPrivateKey =  vm.envUint("LOCAL_PK");
           _deployerAddress = vm.envAddress("LOCAL_ADDRESS");
        } else if (keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("testnet"))))  {
            _deployerPrivateKey =  vm.envUint("TESTNET_PK");
            _deployerAddress = vm.envAddress("TESTNET_ADDRESS");
        } else if (keccak256(abi.encodePacked(vm.envString("NETWORK_ENV"))) == keccak256(abi.encodePacked(string("mainnet"))))  {
            _deployerPrivateKey =  vm.envUint("MAINNET_PK");
            _deployerAddress = vm.envAddress("MAINNET_ADDRESS");
        }

        vm.startBroadcast(_deployerPrivateKey);

        TestWrappedNativeToken stakingToken = TestWrappedNativeToken(payable(vm.envAddress("STAKING_TOKEN_ADDRESS")));
        RelayHub relayHub = RelayHub(vm.envAddress("RELAY_HUB_ADDRESS"));
        address relayManager = vm.envAddress("RELAY_MANAGER_ADDRESS");

        uint minimumStakeForToken =  relayHub.getMinimumStakePerToken(stakingToken);
        IStakeManager stakeManager = relayHub.getStakeManager();
        IRelayHub.RelayHubConfig memory relayConfig = relayHub.getConfiguration();


        stakingToken.deposit{value: minimumStakeForToken}();
        stakingToken.approve(address(stakeManager), minimumStakeForToken);

        //stakeManager.setRelayManagerOwner(_deployerAddress);
        stakeManager.stakeForRelayManager(stakingToken, relayManager, relayConfig.minimumUnstakeDelay, minimumStakeForToken);
        console2.log("authorizing hub...");
        stakeManager.authorizeHubByOwner(relayManager, address(relayHub));

        try relayHub.verifyRelayManagerStaked(relayManager) {
            console2.log("Relay Manager Staked");
        } catch  {
            console2.log("Relay Manager Not Staked");
        }

        vm.stopBroadcast();

    }
}