import React, { useState } from "react";

const FinishedSession = ({ sessionName, status, allowances, criteria }) => {
  const allowancesStr = allowances.join(", ");
  const criteriaStr = criteria.join(", ");

  const [displayAllowance, setDisplayAllowance] = useState(false);

  const handleAllowanceClick = () => {
    setDisplayAllowance(true);
  };

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
          onClick={handleAllowanceClick}
        >
          Get my allowance
        </div>
        {displayAllowance && (
          <span className="italic text-sm w-4/5 text-center pb-3">
            Allowance : {5000}
          </span>
        )}
        <div className="button p-2 mb-1 mt-1 min-w-full">
          Get all allowances
        </div>
      </div>
    </div>
  );
};

export default FinishedSession;
