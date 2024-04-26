// SPDX-License-Identifier:MIT

pragma solidity ^0.8.17;

import "@openzeppelin/token/ERC20/ERC20.sol";

/**
 * @notice minimal "wrapped eth" implementation.
 */
contract TestWrappedNativeToken is ERC20{

    // solhint-disable-next-line no-empty-blocks
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
    }

    receive() external payable {
        deposit();
    }

    function deposit() public  payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public  {
        _burn(msg.sender, amount);
        // solhint-disable-next-line avoid-low-level-calls
        (bool success,) = msg.sender.call{value:amount}("");
        require(success, "transfer failed");
    }
}