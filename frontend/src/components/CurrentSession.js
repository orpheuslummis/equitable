import React, { useState } from "react";
import Vote from "./Vote";

const CurrentSession = ({
  sessionName,
  status,
  allowances,
  participants,
  criteria,
}) => {
  const [isVoting, setIsVoting] = useState(false);

  const handleVoteClick = () => {
    setIsVoting(true);
  };

  const handleClose = () => {
    setIsVoting(false);
  };
  const allowancesStr = allowances.join(", ");
  const criteriaStr = criteria.join(", ");

  return (
    <div className="flex flex-row p-7 border-b border-slate-200">
      <div className="flex flex-col items-end italic p-10">
        <span>Session name</span>
        <span>Status</span>
        <span>Allowances</span>
        <span>Criteria</span>
      </div>
      <div className="flex flex-col items-start p-10 w-80">
        <span className="font-semibold text-l">{sessionName}</span>
        <span>{status}</span>
        <span>{allowancesStr}</span>
        <span>{criteriaStr}</span>
      </div>
      <div className="flex flex-col items-center justify-center w-56 text-center">
        <div
          className="important-button p-2 mb-1 mt-1 min-w-full"
          onClick={handleVoteClick}
        >
          Vote
        </div>
        <div className="button p-2 mb-1 mt-1 min-w-full">End session</div>
      </div>
      {isVoting && (
        <Vote
          onClose={handleClose}
          sessionName={sessionName}
          participants={participants}
        />
      )}
    </div>
  );
};

export default CurrentSession;
