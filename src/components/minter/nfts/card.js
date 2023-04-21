import React, { useState } from "react";
import PropTypes from "prop-types";
import { Card, Col, Badge, Stack, Row } from "react-bootstrap";
import { truncateAddress } from "../../../utils";
import Identicon from "../../ui/Identicon";
import { handleDonate, handleWithdraw } from "../../../utils/minter";
import { NotificationSuccess, NotificationError } from "../../ui/Notifications";
import { toast } from "react-toastify";
import { useContractKit } from "@celo-tools/use-contractkit";
import { useMinterContract } from "../../../hooks/useMinterContract";




const NftCard = ({ nft }) => {
  const { image, description, owner, name, index, goal, fundsRaised } = nft;

  const etherValue = fundsRaised / 10 ** 18;


  const [ setLoading] = useState(false);
  const [donated, setDonated] = useState(etherValue);
  const [tokenId, setTokenId] = useState("");
  const [donationAmount, setDonationAmount] = useState("");



  const { performActions, address } = useContractKit();
  const minterContract = useMinterContract();


////Function for Donating

  const forDonate = async () => {
    try {
      setLoading(true);

      // call the donate() function on the smart contract
      await handleDonate(minterContract, performActions, donationAmount, setDonated, tokenId);
      setDonationAmount("");
      setTokenId("");
      toast(<NotificationSuccess text="Donation made successfully!" />);
    } catch (error) {
      console.log({ error });
      toast(<NotificationError text="Failed to make donation." />);
    } finally {
      setLoading(false);
    }
  };

////Function for Withdrawing

  const forWithdraw = async () => {
    try {
      setLoading(true);

      // call the donate() function on the smart contract
      await handleWithdraw(minterContract, performActions, tokenId);
      
      toast(<NotificationSuccess text="Withdraw successfully!" />);
    } catch (error) {
      console.log({ error });
      toast(<NotificationError text="Failed to make withdrawal." />);
    } finally {
      setLoading(false);
    }
  };

  


  return (
    <Col key={index}>
      <Card className=" h-100">
        <Card.Header>
          <Stack direction="horizontal" gap={2}>
            <Identicon address={owner} size={28} />
            <span className="font-monospace text-secondary">
              {truncateAddress(owner)}
            </span>
            <Badge bg="secondary" className="ms-auto">
              {index} ID
            </Badge>
            {owner === address? 
            (
              <button onClick={forWithdraw}>Withdraw</button>
            )
            :
            (
              <button onClick={forDonate}>Donate</button>
            )

            }
           
          </Stack>
        </Card.Header>

        <div className=" ratio ratio-4x3">
          <img src={image} alt={description} style={{ objectFit: "cover" }} />
        </div>

        <Card.Body className="d-flex  flex-column text-center">
          <Card.Title>{name}</Card.Title>
          <Card.Text className="flex-grow-1">{description}</Card.Text>
          <div>
            <Row className="mt-2">

              <Col>
                <div className="border rounded bg-light">
                  <div className="text-secondary fw-lighter small text-capitalize">
                    Goal
                  </div>
                  <div className="text-secondary text-capitalize font-monospace">
                    {goal} CELO
                  </div>
                </div>
              </Col>
              <Col>
                <div className="border rounded bg-light">
                  <div className="text-secondary fw-lighter small text-capitalize">
                    funds raised:
                  </div>

                  <div className="text-secondary text-capitalize font-monospace ">
                    {Number(donated).toFixed(1)} CELO
                  </div>

                </div>
              </Col>


            </Row>

            <Col className="mt-3">
              {owner === address ? 
              (
              <div className="border rounded bg-light">
                <div className="text-secondary fw-lighter small text-capitalize">
                  Withdraw Funds
                </div>
                <div className="text-secondary text-capitalize font-monospace mb-2">
                  <input type="text" placeholder="campaign ID" value={tokenId} onChange={(e) => setTokenId(e.target.value)} />
                </div>
              </div>
              )


                :
                (
                  <div className="border rounded bg-light">
                    <div className="text-secondary fw-lighter small text-capitalize">
                      Donate to this campaign
                    </div>
                    <div className="text-secondary text-capitalize font-monospace mb-2">
                      <input type="text" placeholder="campaign ID" value={tokenId} onChange={(e) => setTokenId(e.target.value)} />
                      <input
                        type="number"
                        placeholder="Donation amount"
                        value={donationAmount}
                        onChange={(e) => setDonationAmount(parseInt(e.target.value))}
                      />

                    </div>
                  </div>
                )

              }
            </Col>

          </div>
        </Card.Body>
      </Card>
    </Col>
  );
};

NftCard.propTypes = {

  // props passed into this component
  nft: PropTypes.instanceOf(Object).isRequired,
};

export default NftCard;