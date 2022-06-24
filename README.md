# NestDrive Dapp

> ## Table of contents
- [Overview](#overview)
- [Project Features](#project-features)
- [Technologies](#technologies)
- [Repo Setup](#repo-setup)
- [Requirements](#requirements)
- [Setup the Project](#setup-the-project)
  - [Install Hardhat](#install-hardhat)
  - [Env Setup](#env-setup)
  - [Setup Hardhat.config](#setup-hardhatconfig)
- [Create the SmartContract](#create-the-smartcontract)
  - [Compile](#compile)
  - [Deploy](#deploy)
  - [Verify](#verify)
- [Setup the Frontend](#setup-the-frontend)
  - [Install Dependencies](#install-dependencies)
  - [Start Server](#start-server)
  - [Build the Frontend](#build-the-frontend)
- [Testing the Smartcontract](#testing-the-smartcontract)
- [NestDrive Contract Address](#nestdrive-contract-address)
- [Live Link](#live-link)
- [Contributors](#contributors)
- [Contributing to the project](#contributing-to-the-project)
#
> ## Overview
<p align="justify">
You got hired by a Web3 startup trying to build a novel solution to file sharing and storage.
</p>

<p align="justify">
They would like to build a proof of concept (POC) to pitch to investors. The POC will be a Decentralized Library, that allows users to upload files, retrieve files, share files with other users from the service.
</p>

<p align="justify">
These files could be articles, books or similar. The default permission for uploads shhould be public.
</p>

#
> ## Project Features

- Upload files.

- Retrieve files.

- Share files to other users

</p>

#
> ## Technologies
| <b><u>Stack</u></b> | <b><u>Usage</u></b> |
| :------------------ | :------------------ |
| **`Solidity`**      | Smart contract      |
| **`React JS`**      | Frontend            |

#
> ## Repo Setup

<p align="justify">
To setup the repo, first fork the TeamResilient NestDrive repo, then clone the forked repository to create a copy on the local machine.
</p>

    $ git clone https://github.com/pauline-banye/NestDrive.git

<p align="justify">
Change directory to the cloned repo and set the original NestDrive repository as the "upstream" and your forked repository as the "origin" using gitbash.
</p>

    $ git remote add upstream https://github.com/TeamResilient/NestDrive.git

#

> ## Requirements
#
- Hardhat
- Alchemy key
- Metamask key
- Etherscan.io API Url
- Node JS
#
> ## Setup the Project
**`*Note:`**

<p align="justify">
This project was setup on a windows 10 system using the gitbash terminal. Some of the commands used may not work with the VScode terminal, command prompt or powershell.
</p>

The steps involved are outlined below:-
#
> ### Install Hardhat
The first step involves cloning and installing hardhat.
```shell
$ cd NestDrive

$ npm i -D hardhat

$ npm install

$ npm install --save-dev "@nomiclabs/hardhat-waffle" "ethereum-waffle" "chai" "@nomiclabs/hardhat-ethers" "ethers" "web3" "@nomiclabs/hardhat-web3" "@nomiclabs/hardhat-etherscan" "@openzeppelin/contracts" "dotenv"

# If you encounter errors installing the dependencies above, delete the old package-lock.json and run the `npm install --save-dev` command again
```
> ### Env Setup
 Next create a `.env` file by using the sample.env. Retrieve your information from the relevant sites and input the information where needed in the `.env` file.

`To retrieve your metamask private key.`
- Open your account details by clicking on the three dots on the metamask extension on your chrome browser
- Click on export private key
- Verify your password
- Copy your private key and place it in the .env file

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=1oDl0IbicD7LhNOcYUbGzBYTJdduWim1t" alt="metamask"/>
</p>

#
`To retrieve your alchemy key.`
- Login to your account on https://www.alchemy.com/
- Once youre redirected to your [dashboard](https://dashboard.alchemyapi.io/), click on create app.
- Fill in the relevant details especially the chain and network
- Once the app has been created, click on view key.
- Copy the HTTP and place it in the .env file.

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=1vPvT5LJRJy6B8hSi_3mPo16wC4u6MnEK" alt="alchemy"/>
</p>

#
`To retrieve your etherscan key.`
- Login to [etherscan](https://etherscan.io/) and hover over the dropdown arrow for your profile on the navbar.
- Click on API keys and add to create a new project (optional step).
- Once the project has been created, click on the copy button to copy the API key.
- Paste it in the .env file

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=1Gq-hPuwjwb3TOCH2dqUA93VxfyrbUDN6" alt="etherscan key"/>
</p>

#
> ### Setup Hardhat.config


Below is the setup for the hardhat.config.json

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=1Wmc2o2DnF5K6Q5y0CTCjVUfUIoLVm2ei" alt="hardhat"/>
</p>

#
> ## Create the SmartContract
  - First write the Smartcontract codes within the contracts folder.
  - The next step involves the compilation, deployment and verification of the contract on the testnet.

> ### Compile
- To compile the smartcontract before deployment:
```
$ npx hardhat compile
```
#
> ### Deploy
- To deploy the smartcontract:
```
$ npx hardhat run scripts/deploy.js --network rinkeby
```
#
> ### Verify
- To verify the smartcontract:
```
$ npx hardhat verify 0x459eBd3d66cfBfC118e8a20c4F16Fc75B376253d --network rinkeby
```

#
> ## Setup the Frontend
- First run the frontend on your local server to ensure it's fully functional before building for production.
#
> ### Install Dependencies
- Setup and install dependencies

```shell
$ cd frontend

$ npm install

$ npm install react-scripts@latest
```
#
> ### Start Server
- Start the server on localhost
```
$ npm run start
```
#
> ### Build the Frontend
- Create an optimized production build, which can be hosted on sites like Heroku, Netlify, Surge etc.
```
$ npm run build
```
#
> ## Testing the Smartcontract

- Coverage is used to view the percentage of the code required by tests and unittests were implemented to ensure that the code functions as expected
#
**`Coverage Test`**
- To test the smartcontract, first open a terminal and run the following command:

- First install Solidity Coverage
```
  $ npm i solidity-coverage
```
- Add `require('solidity-coverage')` to hardhat.config.json

- Install Ganache
``` 
  $ npm i ganache-cli
``` 
- Run coverage
```
$ npx hardhat coverage --network localhost

# if you get errors and you want to trace the error in the terminal
$ npx hardhat coverage --network localhost --show-stack-traces
```
#

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=1tMhIUrDVPcIsMxTd4FAzapB04_R93Rcc" alt="coverage tests"/>
</p>

#
> ## NestDrive Contract Address

- https://rinkeby.etherscan.io/address/0x4dfBB942B4147596A03e1A76EFD72f12a0046FaA#code

#  
> ## Live Link
  
  - nestdrive.surge.sh
#

> ## Contributors

This Project was created by the members of TeamResilient during the Blockgames Internship.

<p align="center" width="100%">
  <img src="https://drive.google.com/uc?export=view&id=13Gt4morUWHd7QNLk4e6Om7itygJiCOSl" alt="teamresilient"/>
</p>

#
> ## Contributing to the project

If you find something worth contributing, please fork the repo, make a pull request and add valid and well-reasoned explanations about your changes or comments.

Before adding a pull request, please note:

- This is an open source project.
- Your contributions should be inviting and clear.
- Any additions should be relevant.
- New features should be easy to contribute to.

All **`suggestions`** are welcome!
#
> ###### README Created by `Pauline Banye` for TeamResilient
