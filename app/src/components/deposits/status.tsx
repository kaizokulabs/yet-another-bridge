import { useEffect, useState } from "react"

export default function DepositStatus(props: any) {
  const [deposit, setDeposit]: any = useState({})

  useEffect(() => {
    setDeposit(props.deposit)
  }, [props])

  return (
    <div className="flex flex-col items-center justify-center w-full mt-8">
      <h1 className="text-2xl font-bold text-white">Deposit {deposit.id}</h1>
        <div className="flex flex-col items-center justify-start mt-8">
          <div className="gap-4 mt-4">
            <span className="text-white">ID: </span>
            <span className="text-white">{deposit.id}</span>
          </div>
          <div className="gap-4 mt-4">
            <span className="text-white">Status: </span>
            <span className="text-white">{deposit.status}</span>
          </div>
          <div className="gap-4 mt-4">
            <span className="text-white">Amount: </span>
            <span className="text-white">{deposit.amount}</span>
          </div>
          { deposit.ethereum_tx === undefined ? null :
            <div className="gap-4 mt-4">
              <span className="text-white">Ethereum Transaction: </span>
              <span className="text-white">
                <a href={`https://goerli.etherscan.io/tx/${deposit.ethereum_tx.hash}`} target="_blank" className="text-cyan-500">{deposit.ethereum_tx.hash}</a>
                &nbsp;({deposit.ethereum_tx.status})
              </span>
            </div>
          }
          { deposit.herodotus_tasks?.map((task: any) => {
            return (
              <div className="gap-4 mt-4">
                <span className="text-white">Herodotus Task: </span>
                <span className="text-white">{task.id} ({task.status})</span>
              </div>
            )
          })}
          { deposit.starknet_tx === undefined ? null :
            <div className="gap-4 mt-4">
              <span className="text-white">Starknet Transaction: </span>
              <span className="text-white">
                <a href={`https://starkcompass.com/testnet/transactions/${deposit.starknet_tx.hash}`} target="_blank" className="text-cyan-500">{deposit.starknet_tx.hash}</a>
                &nbsp;({deposit.starknet_tx.status})
              </span>
            </div>
          }
        </div>
    </div>
  )
}
