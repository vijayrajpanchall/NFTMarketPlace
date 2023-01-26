// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is ERC20, Ownable{
    constructor() ERC20("ERC20 Token", "Token"){
        _mint(msg.sender, 1000 * 10 ** 18);
    }

    function mint(address account, uint256 amount) public onlyOwner{
        _mint(account, amount);
    }
}

