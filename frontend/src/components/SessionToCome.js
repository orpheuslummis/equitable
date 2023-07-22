import React, { useState } from "react";
import Configure from "./Configure";

const CurrentSession = ({ sessionName }) => {
  const [isConfiguring, setIsConfiguring] = useState(false);

  const handleConfigureClick = () => {
    setIsConfiguring(true);
  };

  const handleClose = () => {
    setIsConfiguring(false);
  };

  return (
    <div className="flex flex-row p-7 border-b border-slate-200">
      <div className="flex flex-col items-end italic p-10">
        <span>Session name</span>
      </div>
      <div className="flex flex-col items-start p-10 w-80">
        <span className="font-semibold text-l">{sessionName}</span>
      </div>
      <div className="flex flex-col items-center justify-center w-56 text-center">
        <div
          className="important-button p-2 mb-1 mt-1 min-w-full cursor-pointer"
          onClick={handleConfigureClick}
        >
          Configure
        </div>
      </div>
      {isConfiguring && (
        <Configure onClose={handleClose} sessionName={sessionName} />
      )}
    </div>
  );
};

export default CurrentSession;
