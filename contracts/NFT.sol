// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NFT is  ERC721Royalty,  Ownable{
    constructor() ERC721("MY NFT", "MNFT"){
        _safeMint(msg.sender, 1);

    }

    function safeMint(address account, uint256 amount) public onlyOwner{
        _safeMint(account, amount);
    }

    //set token royalty
    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 royaltyAmount) public onlyOwner{
        _setTokenRoyalty(tokenId, receiver, royaltyAmount);
    }

}
