### Installation
- Required: nodejs 14+

```bash
yarn install
```

### Configuration
- Link file .env to .env.fuji for testnet

```bash
yarn testnet:env
```

- Link file .env to .env.fuji for mainnet
```bash
yarn mainnet:env
```


### BUILD & DEPLOY

```bash
yarn build # Compile all of solidity smart contract files
yarn deploy_sias:fuji #deploy smartcontract to fuji network
yarn upgrade_sias:fuji #upgrade smartcontract to fuji network
yarn update:abi #Compile and extract abi for dapps
```