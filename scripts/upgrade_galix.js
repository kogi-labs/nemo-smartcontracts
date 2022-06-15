// scripts/upgrade_x.js
const { ethers, upgrades } = require('hardhat');
require('dotenv').config();
const decimal = "000000000000000000";

async function main () {
  const galixERC20 = await ethers.getContractFactory('GalixERC20');
  console.log('Upgrading Galix Coin...');
  const t = await upgrades.upgradeProxy(process.env.galix_CONTRACT, galixERC20);
  await t.mintFrom(process.env.sias_TREASURY, process.env.galix_SUPPLY + decimal);
  console.log('Galix Coin upgraded to:', process.env.galix_CONTRACT);
}

main();