// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Marketplace is  ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    // Interface for NFT
    IERC721 public  nftContract;
    IERC20 public  tokenContract;
    address payable  owner;
    //set platform fee 2.5%
    uint256 public  platformFee = 250;
    address payable public platformWallet;
    
    struct MarketItem {
        address nftAddress;
        uint256 itemId;
        uint256 tokenId;
        address seller;
        address owner;
        uint256 price;
        uint256 platformFee;
        uint256 feeAmount;
        uint256 totalPrice;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated(
        address nftAddress,
        uint256 indexed itemId,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        uint256 platformFee,
        uint256 feeAmount,
        uint256 totalPrice,
        bool sold
    );
    constructor(address _nftContract, address _tokenContract,address _platformWallet) {
        owner = payable(msg.sender);
        nftContract = IERC721(_nftContract);
        tokenContract = IERC20(_tokenContract);
        platformWallet = payable(_platformWallet);
    }
    
    function createMarketItem(uint256 tokenId, uint256 priceInToken) public nonReentrant {
        require(nftContract.ownerOf(tokenId) == msg.sender, "You must own the token");
        require(priceInToken != 0, "Price must be greater than 0");    

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        //calculate platform fee 2.5% of price
        uint256 calFee = (priceInToken * platformFee) / 10000;  //platformFee = 250 = 2.5%
        uint256 totalPrice = priceInToken + calFee;

        idToMarketItem[itemId] = MarketItem(
            address(nftContract),
            itemId,
            tokenId,
            msg.sender,
            address(0),
            priceInToken,
            platformFee,
            calFee,
            totalPrice,
            false
        );

        nftContract.safeTransferFrom(
            msg.sender,
            address(this),
            tokenId
        );

        emit MarketItemCreated(
            address(nftContract),
            itemId,
            tokenId,
            msg.sender,
            address(0),
            priceInToken,
            platformFee,
            calFee,
            totalPrice,
            false
        );
    }

    //user can buy nft using erc20 token
    function BuyNFT(uint256 itemId) public nonReentrant {
        uint256 totalPrice = idToMarketItem[itemId].totalPrice;

        uint256 tokenId = idToMarketItem[itemId].tokenId;
        address seller = idToMarketItem[itemId].seller;        
        uint256 feeAmount = idToMarketItem[itemId].feeAmount; 

        require(
            idToMarketItem[itemId].owner == address(0),
            "Item is already sold"
        );

        require(
            idToMarketItem[itemId].seller != msg.sender,
            "Cannot buy your own item"
        );

        uint256 actualPrice = totalPrice - feeAmount;

        //transfer token from buyer to seller
        tokenContract.transferFrom(msg.sender, seller, actualPrice);
        //transfer token from buyer to platformWallet
        tokenContract.transferFrom(msg.sender, platformWallet, feeAmount);     

        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);

        idToMarketItem[itemId].owner = msg.sender;
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
    }

    /* Calnce the sale of a marketplace item */
    /* Transfers ownership of the item */
    function cancelMarketItem(uint256 itemId) public nonReentrant {
        uint256 tokenId = idToMarketItem[itemId].tokenId;
        require(
            idToMarketItem[itemId].seller == msg.sender,
            "Caller not an owner of the market item"
        );

        nftContract = IERC721(idToMarketItem[itemId].nftAddress);        
        
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);

        idToMarketItem[itemId].owner = msg.sender;
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
    } 
}