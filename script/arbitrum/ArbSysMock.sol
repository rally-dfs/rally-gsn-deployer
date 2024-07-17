pragma solidity ^0.8.0;

import {ArbSys} from "gsn/src/arbitrum/ArbSys.sol";


/**
* @title Precompiled contract that exists in every Arbitrum chain at address(100), 0x0000000000000000000000000000000000000064. Exposes a variety of system-level functionality.
 */
contract ArbSysMock is ArbSys {

    /**
        * @notice Get Arbitrum block number (distinct from L1 block number; Arbitrum genesis block has block number 0)
    * @return block number as int
     */
    function arbBlockNumber() external override pure returns (uint){
        return 0;
    }

    function getStorageGasAvailable() external override view returns (uint256) {
        // we need some really large value as for gasleft but also one that does decrease on every call
        return gasleft() * 100;
    }
}