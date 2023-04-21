import React from "react";
import { Container, Nav } from "react-bootstrap";
import { useContractKit } from "@celo-tools/use-contractkit";
import { Notification } from "./components/ui/Notifications";
import Wallet from "./components/Wallet";
import Cover from "./components/minter/Cover";
//import Counter from "./components/Counter";
import { useBalance, useMinterContract } from "./hooks";
import coverImg from "./assests/img/Giving.webp";
import "./App.css";
//import Cover from "./components/minter/Cover";
import Nfts from "./components/minter/nfts";

const App = function AppWrapper() {
  const { address, destroy, connect } = useContractKit();
  const { balance, getBalance } = useBalance();
  const minterContract = useMinterContract();

  // ...
  return (
    <>
      <Notification />
      {address ? (
        <Container fluid="md">
          <Nav className="justify-content-end pt-3 pb-5">
            <Nav.Item>
              <Wallet
                address={address}
                amount={balance.CELO}
                symbol="CELO"
                destroy={destroy}
              />
            </Nav.Item>
          </Nav>
          <main>
            <Nfts
              name="Campaign Collection"
              updateBalance={getBalance}
              minterContract={minterContract}
            />
          </main>
        </Container>
      ) : (
        <Cover name="CELO CROWD FUNDING" coverImg={coverImg} connect={connect} />
      )}
    </>
  );
};

export default App;