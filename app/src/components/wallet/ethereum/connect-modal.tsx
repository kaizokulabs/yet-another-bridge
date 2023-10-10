import React, { useState } from "react";

import { Box, Button, Modal, Typography } from "@mui/material";
import { Connector, useConnect } from "wagmi";

export default function ConnectModal() {
  const { connect, connectors } = useConnect();
  const [modalOpen, setModalOpen] = useState(false);

  return (
    <div className="w-full flex justify-end">
      <Button
        variant="outlined"
        className="py-2 px-4 border-1 border-[#48A6B2] hover:border-[#FB9489] text-white"
        onClick={() => setModalOpen(true)}>
        <img
          src="/images/ethereum-logo.png"
          alt="Starknet Logo"
          className="h-8 mr-2"
        />
        Connect Wallet
      </Button>
      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description">
        <Box className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[400px] max-w-[90vw] bg-gradient-to-r from-[#48A6B2] to-[#FB9489] p-1 rounded-lg">
          <div className="bg-[#1D1A35] text-white py-10 px-2 rounded-lg">
            <Typography id="modal-modal-title" variant="h6" component="h2" className="text-center">
              Connect Ethereum Wallet
            </Typography>
            <div id="modal-modal-description" className="mt-5 flex flex-col gap-4">
              {connectors.map((connector: Connector) => (
                <Button
                  key={connector.id}
                  onClick={() => {
                    connect({ connector });
                    setModalOpen(false);
                  }}
                  disabled={connector.getAccount === undefined}
                >
                  Connect {connector.name}
                </Button>
              ))}
            </div>
          </div>
        </Box>
      </Modal>
    </div>
  );
}
