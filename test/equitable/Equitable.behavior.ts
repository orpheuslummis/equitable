import { expect } from "chai";
import hre from "hardhat";

import { waitForBlock } from "../../utils/block";

const CRITERIA = [
  { name: "criteria1", weight: 1 },
  { name: "criteria2", weight: 2 },
];

export function setupTest(): void {
  it("A", async function () {
    const signers = await hre.ethers.getSigners();

    let roundStarted = await this.equitable.getRoundStarted();
    expect(roundStarted).to.be.false;

    const voters = signers.slice(1, 4); // first is admin
    const voterAddresses = voters.map(voter => voter.address);

    // add a number of allowances equal to the number of voters
    const allowances = voters.map((_, i) => voters.length - i);

    const criteriaNames = CRITERIA.map(c => c.name);
    const criteriaWeights = CRITERIA.map(c => c.weight);

    await this.equitable.connect(signers[0]).startRound(criteriaNames, criteriaWeights, voterAddresses, allowances);

    await waitForBlock(hre);

    // check roundStarted state after starting voting session
    roundStarted = await this.equitable.getRoundStarted();
    expect(roundStarted).to.be.true;
  });

  // it("start round resets state", async function () {
}
