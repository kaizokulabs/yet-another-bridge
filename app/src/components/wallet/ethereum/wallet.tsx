"use client";
import React from "react";

import dynamic from "next/dynamic";
import { useAccount } from "wagmi";

const ConnectModal = dynamic(
  () => import("./connect-modal"), { ssr: false }
);

const DisconnectModal = dynamic(
  () => import("./disconnect-modal"), { ssr: false }
);

export default function ConnectEvmWallet() {
  const { address } = useAccount();

  return (
    <div className="h-12 flex items-center">
      {address ? <DisconnectModal /> : <ConnectModal />}
    </div>
  );
}
