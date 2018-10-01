# Ethereum Star Notary
This project shows a simple web application that interacts with a deployed smart contract in the Rinkeby network. Users can search and create planet and stars present in the ethereum blockchain. Currently only searching and creating stars is supported in the front-end application. However, the depoyed contract does support searching, creating, purchasing, and sale of stars and planets. I'm also working on a node API to support all above described functionalities.

# Installation - Before you start
Before we can do anything with this project, we must install all packaged dependencies. For this you will need to install node package *manager:https://nodejs.org/en/download/*. If you already have node, simply `cd` into the root folder of the application and run the command `npm install`. All dependencies should be installed sequentially.

# Where to start ? 
**If you just want to play with the application, skip all the testing, contract deployment, and API endpoints then:** 
- The `ROOT/frontend/`directory is where you need to be, so `cd` yourself into that folder
- Read onto and follow the instructions provided in the section labeled **"Running the Application"**.

**If you want to perform the tests provided, and or deploy the solidity contract, then:** 
- `cd` into the `ROOT/smart_contracts` directory
- Follow the instructions provided under **Testing and Deploying the Smart Contract**

**If you want to test the API endpoints provided, then:**
- `cd` into the `ROOT/backend` directory
- Follow the instructions provided under **Smart Contract API Endpoints**

## Required Libraries ##
### node ###
For instructions on installing node, please [visit this link right here](https://nodejs.org/en/download/).

## Running the Application ##
1. in your terminal, `cd` into the `ROOT/frontend/` directory.
2. run the command `http-server`. This should serve index.html locally at in HTTP port 8080. The application should be available in your browser at http://localhost:8080.

## How do I use the application ##
There are two functionalities in this application: 
1. You can search for stars by ID, typing the star or planet id in the search bar and hitting the search button. If a star with the requested ID is found, it's information will be shown in the middle.
2.  You can create a star by providing an ID, name, coordinates (dec, mag, and cent), and a story. For this however, you will need to have metamask installed and have some ether available (which you can get in Rinkeby's [faucet](https://www.rinkeby.io/#faucet)). For more information on how to install metamask, visit https://metamask.io/ and download the chrome extension. Afterwards, please visit rinkeby faucet and follow instructions in order to receive some play ether. *IMPORTANT: MAKE SURE YOU SET UP YOUR METAMASK NETWORK TO RINKEBY, OTHERWISE YOUR ETHER WILL NOT BE REFLECTED.*

Note: After creating a star, your METAMASK chrome extension will pop asking to confirm the transaction. You will need to provide some wei in order for your transaction to be validated timely.

## Testing and Deploying the Smart Contract ##
Currently the smart contract is deployed in the Rinkeby network with address `0x54ee0ed5Cb936e579c22C747A79e606d8eE0eB4E`. If you want to check out the transactions you can check them out at:

https://rinkeby.etherscan.io/address/0x54ee0ed5Cb936e579c22C747A79e606d8eE0eB4E

If you want to run some of the functions in the smart contract, you can use remix at https://remix.ethereum.org/. Just copy and paste the code under StarNotary.sol found under `ROOT/smart_contracts/contracts/` into remix. Please note that in this case, you will need to replace the import statement with 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol' as it is currently configured to use ERC721 under node_modules locally. The code will compile, and under the run tab just paste the contract address labeled by `At address`. This will load the contract functions for you, and will provide you with a menu for providing parameters for each call.

**Testing the contract functionality**
For testing purposes, we are using the *Truffle* framework, found at https://truffleframework.com/docs/ganache/quickstart. 

NOTE: Only implemented methods were tested, ERC721 methods are not tested, namely: mint(), approve(), safeTransferFrom(), SetApprovalForAll(), getApproved(), isApprovedForAll(), ownerOf() as they are inherited from the Open Zeppelin framework.

1. download and install ganache-cli: https://github.com/trufflesuite/ganache-cli. This will allow you to run a local blockchain network with a single local node. 
2. open a separate terminal window and run ganache-cli: `ganache-cli`. 
3. In a seperate terminal `cd` into `ROOT\smart_contracts\`. run the command `truffle test test/starNotaryTest.js`. the following test should be executed and passed:
    - **Can create a star**
       - cannot create a star with non-unique coordinates 
            -- *methods*-> createStar(), checkIfStarExists()
       -  can create a star and get its name
            --*methods*->tokenIdToStar()
    - **buying and selling stars**
       - user1 can put up their star for sale 
            --*methods*-> putStarUpForSale(), starsForSale()
       - user2 can buy a star that was put up for sale
            --*methods*-> putStarUpForSale() 
       -user2 is the owner of the star after they buy it
       -user2 ether balance changed correctly
            --*methods*-> buyStar()
    - **getting appropiate star info**
        -- *methods*-> tokenIdToStarInfo()

## Rinkeby Network Contract Transaction Hashes and Address ##
- Contract Address: `0x54ee0ed5Cb936e579c22C747A79e606d8eE0eB4E`
- Contract creation TX hash: `0x12be65658dfca7e908c14cd0c2d1f9ebe6e4a740e65593a680be3f3d3012737d`
- New Star Creation TX hash: `0x7c6f205583f57697dd734618c6b4777f084166e1293e012effbf113be1586537`
- New Star Token ID: `602933321`
- Placing star for sale TX hash: `0x91fa19b538d35c503c2da1bb7398767b4ea7fbbc981cd1f180f2c3a0722784fd`

##  Smart Contract API Endpoints ##
There is only one endpoint supports (http://localhost:3000/star/{id}). Currently, I'm working on the `/newstar` endpoint at the moment.
**Execute the following steps to test the API endpoints:**
1. `cd` into the `ROOT/backend/` directory.
2. Run the command `node server` in your terminal
3. access the url `http://localhost:3000/[starId]` in your browser. If there's a match for the [starID] provided, a json object with the star info should be returned and displayed in the browser. You can also use the `curl` commmand to execute a GET request if preferred, i.e. : `CURL "http:localhost/3000/20331"`.