// scripts/upgrade_x.js
const { ethers, upgrades } = require('hardhat');
require('dotenv').config();
const decimal = "000000000000000000";

async function main () {
  const siasERC20 = await ethers.getContractFactory('SiasERC20');
  console.log('Upgrading Sias Coin...');
  const t = await upgrades.upgradeProxy(process.env.sias_CONTRACT, siasERC20);
  await t.mintFrom(process.env.sias_TREASURY, process.env.sias_SUPPLY + decimal);
  console.log('Sias Coin upgraded to:', process.env.sias_CONTRACT);
}

main();