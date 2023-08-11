import React, { useState } from "react";
import Entry from "./components/Entry";
import Main from "./components/Main";

const App = () => {
  const [isWalletConnected, setWalletConnected] = useState(false);

  // Fonction pour connecter le wallet
  const connectWallet = () => {
    // Vérifier si MetaMask est disponible dans le navigateur
    if (typeof window.ethereum !== "undefined") {
      // Demander à l'utilisateur de se connecter
      window.ethereum
        .request({ method: "eth_requestAccounts" })
        .then(() => {
          setWalletConnected(true);
        })
        .catch((err) => {
          console.log(err);
          // Gérer les erreurs de connexion ici
        });
    } else {
      // MetaMask n'est pas disponible
      console.log("Install MetaMask");
      // Gérer l'absence de MetaMask ici
    }
  };

  return (
    <div>
      {isWalletConnected ? <Main /> : <Entry onConnectWallet={connectWallet} />}
    </div>
  );
};

export default App;
