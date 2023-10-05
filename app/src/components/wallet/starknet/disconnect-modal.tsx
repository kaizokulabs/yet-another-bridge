"use client";
import React from "react";

import { useAccount, useDisconnect } from "@starknet-react/core";
import { Button, Dialog, DialogContent, DialogTitle } from "@mui/material";

export default function DisconnectModal() {
  const { address } = useAccount();
  const { disconnect } = useDisconnect();
  const [dialogOpen, setDialogOpen] = React.useState(false);

  const addressShort = address
    ? `${address.slice(0, 6)}...${address.slice(-4)}`
    : null;

  return (
    <div className="w-full flex justify-end">
      <Button onClick={() => setDialogOpen(true)}>{addressShort}</Button>
      <Dialog
        open={dialogOpen}>
        <DialogContent>
          <DialogTitle>Disconnect Wallet</DialogTitle>
          <div className="flex flex-col gap-4">
            <Button onClick={() => { disconnect(); setDialogOpen(false)}}>Disconnect</Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
