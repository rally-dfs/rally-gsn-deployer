// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Script, console2} from "forge-std/Script.sol";
import {RLYVerifyPaymaster} from "src/RLYVerifyPaymaster.sol";
import {ERC20ExecuteMetaTxToken} from "src/tokens/ERC20ExecuteMetaTx.sol";
import {ERC20PermitToken} from "src/tokens/ERC20Permit.sol";
import {TokenFaucet} from "src/TokenFaucet.sol";
import {IPaymaster} from "gsn/src/interfaces/IPaymaster.sol";
import {RelayHub} from "gsn/src/RelayHub.sol";


contract DeployRally is Script {

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

        RLYVerifyPaymaster paymaster = new RLYVerifyPaymaster();
        RelayHub relayHub = RelayHub(vm.envAddress("RELAY_HUB_ADDRESS"));

        paymaster.setSigner(vm.envAddress("AUTH_SIGNER"));
        paymaster.setRelayHub(relayHub);

        ERC20PermitToken rlyPermitToken = new ERC20PermitToken("RLY Permit" , "RLYpermit", 15_000_000_000 ether);
        ERC20ExecuteMetaTxToken rlyExecuteMetaTxToken = new ERC20ExecuteMetaTxToken();
        rlyExecuteMetaTxToken.initialize("RLY Metatx", "RLYmetaTx", 18, _deployerAddress, 15_000_000_000 ether);     

        TokenFaucet permitFaucet = new TokenFaucet(address(rlyPermitToken), 10 ether, vm.envAddress("GSN_FORWARDER"));
        TokenFaucet executeMetaTxFaucet = new TokenFaucet(address(rlyExecuteMetaTxToken), 10 ether, vm.envAddress("GSN_FORWARDER"));

        rlyPermitToken.transfer(address(permitFaucet), 1000000 ether);
        rlyExecuteMetaTxToken.transfer(address(executeMetaTxFaucet), 1000000 ether);

        console2.log("paymaster address");
        console2.logAddress(address(paymaster));
        console2.log("rly permit token address");
        console2.logAddress(address(rlyPermitToken));
        console2.log("rly execute meta tx token address");
        console2.logAddress(address(rlyExecuteMetaTxToken));
        console2.log("rly permit faucet address");
        console2.logAddress(address(permitFaucet));
        console2.log("rly execute meta tx faucet address");
        console2.logAddress(address(executeMetaTxFaucet));

        vm.stopBroadcast();

    }
}