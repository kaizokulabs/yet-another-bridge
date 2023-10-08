import DepositStatus from "@/components/deposits/status";
import { herodotus_task_schedule } from "@/utils/herodotus_api";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { useCookies } from "react-cookie";
import { useWaitForTransaction } from "wagmi";

export default function Deposit() {
  const router = useRouter()

  const [deposit, setDeposit] = useState({})
  const [cookies, _setCookie, _deleteCookie] = useCookies(['deposits'])
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

    setEthTxHash(deposit.ethereum_tx?.hash)
    deposit.ethereum_tx.status = data?.status

    if (deposit.ethereum_tx?.status === "success"
      && deposit.herodotus_tasks?.length !== 0) {
      console.log("scheduling herodotus task")
      herodotus_task_schedule("GOERLI", "STARKNET_GOERLI", deposit.id, deposit.amount)
        .then((task: any) => {
          deposit.herodotus_tasks = [...deposit.herodotus_tasks, task]
        })
    }

    setDeposit(deposit)
  }, [cookies, data])

  return (
    <div className="flex flex-col items-center justify-center w-full mt-24">
      <DepositStatus
        deposit={deposit}
      />
    </div>
  )
}
