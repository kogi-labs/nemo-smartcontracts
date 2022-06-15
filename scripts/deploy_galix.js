// scripts/deploy_x.js
const { ethers, upgrades } = require('hardhat');
require('dotenv').config();
const decimal = "000000000000000000";

async function main () {
  const galixERC20 = await ethers.getContractFactory('GalixERC20');
  console.log('Deploying Galix Coin...');
  
  const t = await upgrades.deployProxy(galixERC20, [
    process.env.galix_TOKEN_NAME,
    process.env.galix_TOKEN_SYMBOL,
    process.env.galix_TREASURY + decimal
  ], { initializer: 'initialize' });
  await t.deployed();
  //await t.mintFrom(process.env.sias_TREASURY, "500000000" + decimal);
  console.log('Galix Coin deployed to:', t.address);
}

main();