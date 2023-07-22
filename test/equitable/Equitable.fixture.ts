import axios from "axios";
import { ethers } from "hardhat";
import hre from "hardhat";

import type { Equitable } from "../../types/Equitable";
import { waitForBlock } from "../../utils/block";

export async function deployEquitableFixture(): Promise<{ equitable: Equitable; address: string }> {
  const signers = await ethers.getSigners();
  const admin = signers[0];

  const equitableFactory = await ethers.getContractFactory("Equitable");
  const equitable = await equitableFactory.connect(admin).deploy();
  // await greeter.waitForDeployment();
  const address = await equitable.getAddress();
  return { equitable, address };
}

export async function getTokensFromFaucet() {
  if (hre.network.name === "localfhenix") {
    const signers = await hre.ethers.getSigners();

    if ((await hre.ethers.provider.getBalance(signers[0].address)).toString() === "0") {
      console.log("Balance for signer is 0 - getting tokens from faucet");
      await axios.get(`http://localhost:6000/faucet?address=${signers[0].address}`);
      await waitForBlock(hre);
    }
  }
}