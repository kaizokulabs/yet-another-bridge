import Bridge from "@/abi/Bridge.json"
import { ethereum_bridge_addr } from "./constants"
import { getAccount, prepareWriteContract, readContract, writeContract } from "@wagmi/core"
import { ethers } from "ethers"

export const ethereumBridgeDeposit = async (amount: number) => {
  const { request } = await prepareWriteContract({
    address: ethereum_bridge_addr,
    abi: Bridge.abi,
    functionName: 'deposit',
    value: ethers.parseEther(amount.toString())
  })
  const { hash } = await writeContract(request)
  return hash
}

export const ethereumBridgeBalance = async () => {
  let address = getAccount().address;
  if(!address) {
    return 0
  }
  
  return await readContract({
    address: ethereum_bridge_addr,
    abi: Bridge.abi,
    functionName: 'addrAmount',
    args: [address]
  })
}
