import { expect } from "chai";
import hre from "hardhat";

import { waitForBlock } from "../../utils/block";

/*
export function shouldBehaveLikeCounter(): void {
  it("should add amount to the counter and verify the result", async function () {
    const amountToCount = 10;

    const eAmountCount = this.instance.instance.encrypt32(amountToCount);
    await this.counter.connect(this.signers.admin).add(eAmountCount);

    await waitForBlock(hre);

    const eAmount = await this.counter.connect(this.signers.admin).getCounter(this.instance.publicKey);
    const amount = this.instance.instance.decrypt(await this.counter.getAddress(), eAmount);

    expect(amount === amountToCount);
  });
}
*/

export function setupTest(): void {
  it("basicSetup", async function () {
    const signers = await hre.ethers.getSigners();

    let roundStarted = await this.equitable.getRoundStarted();
    expect(roundStarted).to.be.false;

    const voters = signers.slice(1, 4); // first is admin

    for (let i = 0; i < voters.length; i++) {
      await this.equitable.connect(this.signers.admin).addVoter(voters[i].address);
    }

    // add a number of allowances equal to the number of voters
    for (let i = 0; i < voters.length; i++) {
      const allowance = i + 1;
      await this.equitable.connect(this.signers.admin).addAllowance(allowance);
    }

    // add two weighted criteria
    const criteria = [
      { name: "criteria1", weight: 2 },
      { name: "criteria2", weight: 3 },
    ];
    for (let i = 0; i < criteria.length; i++) {
      await this.equitable.connect(this.signers.admin).addCriterium(criteria[i].name, criteria[i].weight);
    }

    await waitForBlock(hre);

    await this.equitable.connect(this.signers.admin).startVotingRound();
    await waitForBlock(hre);

    // check roundStarted state after starting voting session
    roundStarted = await this.equitable.getRoundStarted();
    expect(roundStarted).to.be.true;
  });
}
