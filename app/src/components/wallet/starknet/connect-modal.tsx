import React, { useState } from "react";

import { useConnect, Connector } from "@starknet-react/core";
import { Box, Button, Modal, Typography } from "@mui/material";

export default function ConnectModal() {
  const { connect, connectors } = useConnect();
  const [modalOpen, setModalOpen] = useState(false);

  return (
    <div className="w-full flex justify-end">
      <Button
        variant="outlined"
        className="py-2 px-4 border-1 border-[#FB9489] hover:border-[#AB679F] text-white"
        onClick={() => setModalOpen(true)}>
        <img
          src="/images/starknet-logo.png"
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
              Connect Starknet Wallet
            </Typography>
            <div id="modal-modal-description" className="mt-5 flex flex-col gap-4">
              {connectors.map((connector: Connector) => (
                <Button
                  key={connector.id}
                  onClick={() => {
                    connect({ connector });
                    setModalOpen(false);
                  }}
                  disabled={!connector.available()}
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
