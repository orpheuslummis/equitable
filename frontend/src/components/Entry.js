import React from "react";

const Entry = ({ onConnectWallet }) => {
  return (
    <div className="flex flex-col justify-center items-center min-h-screen">
      <h1 className="text-3xl">Please connect your wallet</h1>
      <button className="button m-10 p-5" onClick={onConnectWallet}>
        Connect Wallet
      </button>
    </div>
  );
};

export default Entry;
