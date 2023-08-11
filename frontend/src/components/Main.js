import React from "react";
import CurrentSession from "./CurrentSession";
import SessionToCome from "./SessionToCome";
import FinishedSession from "./FinishedSession";

const Main = () => {
  const sessionToComeDetails = {
    contractAddress: "",
    sessionName: "My Session To Come",
  };

  const currentSessionDetails = {
    contractAddress: "",
    sessionName: "My Current Session",
    status: "Running",
    allowances: ["3000", "2500", "2000", "1000", "500"],
    participants: [
      "0x1b3cb81e51011b549d78bf720b0d924ac763a7c2",
      "0x0c05ec4db907cfb91b2a1a29e7b86688b7568a6d",
      "0x084ef8564b4f75a70b7ad5e8aabf73edac005397",
      "0x04b7f4195595d8132dd8249cc8dc7e79a6ae772b",
    ],
    criteria: ["General"],
  };

  const finishedSession = {
    contractAddress: "",
    sessionName: "My Finished Session",
    status: "Finished",
    allowances: ["12000", "7000", "5000", "3000", "1000"],
    participants: ["addressA", "addressB", "addressC"],
    criteria: ["General"],
  };

  return (
    <div className="flex flex-col  items-center justify-center min-h-screen">
      <h1 className="text-3xl mt-10">Existing Sessions</h1>
      <SessionToCome sessionName={sessionToComeDetails.sessionName} />{" "}
      <CurrentSession
        sessionName={currentSessionDetails.sessionName}
        status={currentSessionDetails.status}
        allowances={currentSessionDetails.allowances}
        participants={currentSessionDetails.participants}
        criteria={currentSessionDetails.criteria}
      />{" "}
      <FinishedSession
        sessionName={finishedSession.sessionName}
        status={finishedSession.status}
        allowances={finishedSession.allowances}
        criteria={finishedSession.criteria}
      />{" "}
      <div className="mt-10 mb-20 flex items-center justify-center w-full">
        <div className="mr-4">Campaign name :</div>
        <input
          type="text"
          className="border border-gray-300 rounded px-2 py-1 mr-4"
        />
        <button className="button p-5 ml-10 mr-10">New session</button>
      </div>
    </div>
  );
};

export default Main;
