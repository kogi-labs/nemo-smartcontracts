// scripts/deploy_x.js
const { ethers, upgrades } = require('hardhat');
require('dotenv').config();
const decimal = "000000000000000000";

async function main () {
  const siasERC20 = await ethers.getContractFactory('SiasERC20');
  console.log('Deploying Sias Coin...');
  
  const t = await upgrades.deployProxy(siasERC20, [
    process.env.sias_TOKEN_NAME,
    process.env.sias_TOKEN_SYMBOL,
    process.env.sias_TREASURY + decimal
  ], { initializer: 'initialize' });
  await t.deployed();
  //await t.mintFrom(process.env.sias_TREASURY, "500000000" + decimal);
  console.log('Sias Coin deployed to:', t.address);
}

main();