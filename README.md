# NFT Marketplace

## Table of Content

- [Task Description](#project-description)
- [Technologies Used](#technologies-used)
- [Folder Structure](#a-typical-top-level-directory-layout)
- [Install and Run](#install-and-run)
- [Test](#test)


## Task Description

Create a marketplace Smart contract to buy and sell NFT with your custom ERC20 token. 

Functionalities:
- Buy, Sell and mint NFT.
- You need to add 2.5% of the sell price/token to the platform fee.
- Users can set fractional Royalties of multiple Owners for the NFT's selling price.
- Create 3 different smart contracts for ERC20, ERC721 and Marketplace.


## For achiving this task I have done the following:

- Created a ERC20 token contract.
- Created a ERC721 token contract.
- Created a Marketplace contract.
## Technologies Used

- Soldity
- Openzepplein
- Hardhat

## A typical top-level directory layout

    .
    ├── Contracts               # Contract files (alternatively `dist`)
    ├── Scripts                 # Script files (alternatively `deploy`)
    ├── test                    # Automated tests (alternatively `spec` or `tests`)
    ├── LICENSE
    └── README.md

## Install and Run

To run this project, you must have the following installed:

1.  [nodejs](https://nodejs.org/en/)
2.  [npm](https://github.com/nvm-sh/nvm)

- Run `npm install` to install dependencies

```bash
$ npm install
```

- Run `npx hardhat compile` to compile all contracts.

```bash
$ npx hardhat compile
```
