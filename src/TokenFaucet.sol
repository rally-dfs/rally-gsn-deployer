// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "gsn/src/ERC2771Recipient.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenFaucet is ERC2771Recipient {
    IERC20 public immutable token;
    uint256 public immutable claimAllowance;

    mapping(address => bool) private _claimedAddresses;

    event Claim(address sender, uint256 amount);

    constructor(address _token, uint256 _claimAllowance, address _forwarder) {
        token = IERC20(_token);
        claimAllowance = _claimAllowance;
        _setTrustedForwarder(_forwarder);
    }

    function claim() public returns (bool) {
        address sender = _msgSender();
        require(
            !_claimedAddresses[sender],
            "Address has already received tokens."
        );
        require(
            token.balanceOf(address(this)) >= claimAllowance,
            "Insufficient faucet balance."
        );

        _claimedAddresses[sender] = true;
        token.transfer(sender, claimAllowance);
        emit Claim(sender, claimAllowance);
        return true;
    }
}