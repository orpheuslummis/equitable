import { ethers } from "hardhat";
import hre from "hardhat";

import { waitForBlock } from "../../utils/block";
import { createFheInstance } from "../../utils/instance";
import type { Signers } from "../types";
import { setupTest } from "./Equitable.behavior";
import { deployEquitableFixture, getTokensFromFaucet } from "./Equitable.fixture";

async function setupBeforeTest(context: any) {
  context.signers = {} as Signers;
  // get tokens from faucet if we're on localfhenix and don't have a balance
  await getTokensFromFaucet();
  // deploy test contract
  const { equitable, address } = await deployEquitableFixture();
  context.equitable = equitable;
  // initiate fhevmjs
  context.instance = await createFheInstance(hre, address);
  // set admin account/signer
  const signers = await ethers.getSigners();
  context.signers.admin = signers[0];
  // wait for deployment block to finish
  await waitForBlock(hre);
}

async function setupBeforeTestWithBasicSetup(context: any) {
  await setupBeforeTest(context);

  // a basic round setup: 3 players, 2 criterias

  const signers = await hre.ethers.getSigners();

  const voters = signers.slice(1, 4);
  const voterAddresses = voters.map(voter => voter.address);

  const allowances = voters.map((_, i) => i + 1);

  const criteria = [
    { name: "criteria1", weight: 2 },
    { name: "criteria2", weight: 3 },
  ];
  const criteriaNames = criteria.map(c => c.name);
  const criteriaWeights = criteria.map(c => c.weight);

  await context.equitable.connect(signers[0]).startRound(criteriaNames, criteriaWeights, voterAddresses, allowances);

  await waitForBlock(hre);
}

describe("TestSetup", function () {
  before(async function () {
    await setupBeforeTest(this);
  });

  describe("A", function () {
    setupTest();
  });
});

describe("TestVotingA", function () {
  before(async function () {
    await setupBeforeTestWithBasicSetup(this);
  });

  describe("A", function () {
    // basicVotingTest();
  });
});

