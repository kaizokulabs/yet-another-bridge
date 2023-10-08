import DepositStatus from "@/components/deposits/status";
import { herodotus_task_schedule } from "@/utils/herodotus_api";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { useCookies } from "react-cookie";
import { useWaitForTransaction } from "wagmi";

export default function Deposit() {
  const router = useRouter()

  const [deposit, setDeposit] = useState({})
  const [cookies, setCookie, _deleteCookie] = useCookies(['deposits'])
  const [ethTxHash, setEthTxHash]: any = useState("")

  const { data } = useWaitForTransaction({
    hash: ethTxHash,
  })

  useEffect(() => {
    let depositsCookie = cookies.deposits
    if (depositsCookie === undefined) {
      router.push('/deposits')
      return
    }
    let deposit: any = Object.entries(depositsCookie).filter(
      (deposit: any) => deposit[1].id === router.query.id)
    if (deposit.length === 0) {
      router.push('/deposits')
      return
    }
    deposit = deposit[0][1]
    setDeposit(deposit)

    setEthTxHash(deposit.ethereum_tx?.hash)
    deposit.ethereum_tx.status = data?.status

    if(deposit.status === "complete") {
      return
    } else if(deposit.ethereum_tx?.status === "success"
      && deposit.starknet_tx?.status === "success"
      && deposit.herodotus_task?.status === "FINALIZED") {
      deposit.status = "complete"
    } else if(deposit.ethereum_tx.status === "success"
      && deposit.starknet_tx === undefined
      && deposit.herodotus_task?.status === "FINALIZED") {
      // TODO call withdraw on starknet bridge
      // TODO add balance on starknet in the interface
    } else if (deposit.ethereum_tx?.status === "success"
      && deposit.herodotus_task === undefined) {
      console.log("scheduling herodotus task")
      /*
      herodotus_task_schedule("GOERLI", "STARKNET_GOERLI", deposit.id, deposit.amount)
        .then((task: any) => {
          deposit.herodotus_task = {
            id: task.taskId,
            status: task.taskStatus,
          }
        })
      */
    }

    if(depositsCookie[deposit.id] !== deposit) {
      depositsCookie[deposit.id] = deposit
      setCookie('deposits', depositsCookie)
    }
  }, [cookies, data])

  return (
    <div className="flex flex-col items-center justify-center w-full mt-16">
      <DepositStatus
        deposit={deposit}
      />
    </div>
  )
}
