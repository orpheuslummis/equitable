import React from "react";

const Vote = ({ onClose, sessionName, participants, criteria }) => {
  return (
    <div className="fixed top-0 left-0 w-full h-full flex items-center justify-center z-50 bg-gray-700 bg-opacity-50">
      <div className="bg-white py-4 px-10 w- rounded-lg flex flex-col justify-center items-center">
        <h2 className="text-lg mb-3">
          Vote for <span className="font-semibold">{sessionName}</span>
        </h2>
        <div className="w-full pb-5 pt-5">
          <div className="flex justify-start items-center border-b pb-5 border-slate-300">
            <div className="m-5 text-xl">Criterium</div>
            <div className="flex flex-col justify-start items-center space-y-2 w-96">
              <h3 className="text-lg">Address</h3>
              {participants.map((participant, index) => (
                <span key={index} className="span-field">
                  {participant}
                </span>
              ))}
            </div>

            <div className="flex flex-col justify-start items-center space-y-2 ml-2">
              <h3 className="text-lg">Score</h3>
              {participants.map((participant, index) => (
                <input
                  type="number"
                  className="input-field border border-gray-300 rounded px-2 py-1 w-full focus:outline-none focus:ring focus:border-blue-500"
                />
              ))}
            </div>
          </div>
        </div>

        <button className="button mb-2 py-4 px-10" onClick={onClose}>
          Submit
        </button>
      </div>
    </div>
  );
};

export default Vote;
