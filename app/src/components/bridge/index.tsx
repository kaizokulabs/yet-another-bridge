import { Button, OutlinedInput, Select } from "@mui/material";
import { useState } from "react";
import { useAccount, useBalance } from "wagmi";

export default function Bridge() {
  let balance = Number(useBalance({
    address: useAccount().address
  }).data?.formatted)
  let eth_balance = isNaN(balance) ? 0 : balance.toFixed(5)
  let [amount, setAmount] = useState(0)

  const handleSubmit = (e: any) => {
    e.preventDefault()
    console.log(amount)
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

          (Balance: <span onClick={() => setAmount(Number(eth_balance))} className="cursor-pointer text-[#48A6B2]">{eth_balance} ETH</span>)
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
