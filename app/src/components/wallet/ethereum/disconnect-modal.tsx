"use client";
import React from "react";

import { Box, Button, Modal, Typography } from "@mui/material";
import { useAccount, useDisconnect } from "wagmi";

export default function DisconnectModal() {
  const { address } = useAccount();
  const { disconnect } = useDisconnect();
  const [modalOpen, setModalOpen] = React.useState(false);

  const addressShort = address
    ? `${address.slice(0, 6)}...${address.slice(-4)}`
    : null;

  return (
    <div className="w-full flex justify-end">
      <Button onClick={() => setModalOpen(true)}>{addressShort}</Button>
      <Modal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description">
        <Box className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-[400px] max-w-[90vw] bg-gradient-to-r from-[#48A6B2] to-[#FB9489] p-1 rounded-lg">
          <div className="bg-[#1D1A35] text-white py-10 px-2 rounded-lg">
            <Typography id="modal-modal-title" variant="h6" component="h2" className="text-center">
              Disconnect Wallet
            </Typography>
            <div id="modal-modal-description" className="flex flex-col gap-4">
              <Button onClick={() => { disconnect(); setModalOpen(false)}}>Disconnect</Button>
            </div>
          </div>
        </Box>
      </Modal>
    </div>
  );
}
