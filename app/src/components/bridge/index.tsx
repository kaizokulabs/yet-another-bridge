import { ethereumBridgeBalance, ethereumBridgeDeposit } from "@/utils/ethereum_bridge";
import { Button, OutlinedInput, Select } from "@mui/material";
import { fetchBalance, getAccount } from "@wagmi/core";
import { ethers } from "ethers";
import { useEffect, useState } from "react";
import { useCookies } from "react-cookie";

export default function Bridge() {
  const account = getAccount()
  const [ethBalance, setEthBalance] = useState("0")
  const [bridgeBalance, setBridgeBalance] = useState("0")
  const [amount, setAmount] = useState(0)
  const [cookies, setCookie, _] = useCookies(['deposits'])

  let bridge_balance = ethereumBridgeBalance()

  console.log(account.status)
  useEffect(() => {
    if(!account.address) {
      return
    }
    fetchBalance({
      address: account.address
    }).then((balance) => {
      setEthBalance(Number(balance.formatted).toFixed(5))
    })
    bridge_balance.then((balance: any) => {
      setBridgeBalance(Number(ethers.formatEther(balance)).toFixed(5))
    })
  }, [account.status, bridge_balance])

  const handleSubmit = (e: any) => {
    e.preventDefault()
    let deposits = cookies.deposits
    if (deposits === undefined) {
      deposits = {}
    }

    //ethereumBridgeDeposit(amount)

    // get the id from the emited event
    let random_id = (Math.random() * 1000).toFixed(0)

    deposits[random_id] = {
      id: random_id,
      status: "pending",
      amount: amount,
    }
    setCookie('deposits', deposits)
  }

  return (
    <div className="p-1 w-[30vw] rounded-lg bg-gradient-to-br from-[#AB679F] to-[#FB9489]">
      <form
        className="p-4 w-full bg-[#f0f0f0] rounded-lg"
        onSubmit={handleSubmit}>
        <div className="mt-2">
          Token:
          <Select
            disabled
            className="w-1/5 mt-4 ml-3"
            variant="outlined"
            native
            value="eth"
            inputProps={{
              name: 'token',
              id: 'outlined-token-native-simple',
            }}
          >
            <option value="eth">ETH</option>
          </Select>
        </div>
        <div className="mt-2">
          <div className="text-2xl font-bold">
            From:
          </div>
          <div className="mt-5 flex flex-row items-center gap-2">
            <Select
              disabled
              className="w-1/3"
              variant="outlined"
              native
              value="ethereum"
              inputProps={{
                name: 'network',
                id: 'outlined-network-native-simple',
              }}
            >
              <option value="ethereum">Ethereum</option>
              <option value="starknet">Starknet</option>
            </Select>
            
            <OutlinedInput
              className="w-2/3"
              placeholder="Amount"
              type="number"
              endAdornment="ETH"
              value={amount}
              onChange={(e) => setAmount(Number(e.target.value))}
            />
          </div>

          (Balance: <span onClick={() => setAmount(Number(ethBalance))} className="cursor-pointer text-[#48A6B2]">{ethBalance} ETH</span>)
          <br/>
          (Bridge balance: {bridgeBalance} ETH)
        </div>

        <div className="mt-8">
          <div className="text-2xl font-bold">
            To (estimated):
          </div>

          <div className="mt-5 flex flex-row items-center gap-2">
            <Select
              disabled
              className="w-1/3"
              variant="outlined"
              native
              value="starknet"
              inputProps={{
                name: 'network',
                id: 'outlined-network-native-simple',
              }}
            >
              <option value="ethereum">Ethereum</option>
              <option value="starknet">Starknet</option>
            </Select>
            
            <OutlinedInput
              disabled
              className="w-2/3"
              placeholder="Amount"
              type="number"
              endAdornment="yabETH"
              value={amount}
            />
          </div>
        </div>

        <div className="mt-8">
          <Button
            variant="contained"
            className="w-full py-2 px-4 bg-[#48A6B2] hover:bg-[#FB9489] text-white"
            type="submit"
          >
            Bridge
          </Button>
        </div>
      </form>
    </div>
  )
}
