pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {TestNFT} from "src/tokens/TestNFT.sol";
import {Forwarder} from "gsn/src/forwarder/Forwarder.sol";

contract TestNFTTest is Test {
    TestNFT _nft;

    function setUp() public {
        Forwarder forwarder = new Forwarder();
        _nft = new TestNFT(address(forwarder));
    }

    function test_Mint() public {
        vm.prank(address(1));
        _nft.mint();
        assertEq(_nft.tokenIds(), 1);
    }
}