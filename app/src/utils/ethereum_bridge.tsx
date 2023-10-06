import Bridge from "@/abi/Bridge.json"
import { useAccount, useContractRead, useContractWrite, usePrepareContractWrite } from "wagmi"
import { ethereum_bridge_addr } from "./constants"

export const deposit = async (amount: number) => {
}

export const ethereumBridgeBalance = () => {
  return useContractRead({
    address: ethereum_bridge_addr,
    abi: Bridge.abi,
    functionName: 'addrAmount',
    args: [useAccount().address]
  })
}
