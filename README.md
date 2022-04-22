### Installation
- Required: nodejs 14+

```bash
yarn install
```

### Configuration
- Link file .env to .env.mumbai for testnet

```bash
yarn testnet:env
```

- Link file .env to .env.polygon for mainnet
```bash
yarn mainnet:env
```


### BUILD & DEPLOY

```bash
yarn build # Compile all of solidity smart contract files
yarn deploy_sias:mumbai #deploy smartcontract to mumbai network
yarn upgrade_sias:mumbai #upgrade smartcontract to mumbai network
yarn update:abi #Compile and extract abi for dapps
```