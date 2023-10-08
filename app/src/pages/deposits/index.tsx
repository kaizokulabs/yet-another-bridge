import DepositsList from "@/components/deposits/list";
import { useEffect, useState } from "react";
import { useCookies } from "react-cookie";

export default function Deposits() {
  const [deposits, setDeposits] = useState({});
  const [cookies, _setCookie, _deleteCookie] = useCookies(['deposits'])

  useEffect(() => {
    let depositsCookie = cookies.deposits
    if (depositsCookie === undefined) {
      depositsCookie = {}
    }
    setDeposits(depositsCookie)
  }, [cookies])

  return (
    <div className="flex flex-col items-center justify-center w-full mt-24">
      <span className="text-2xl font-bold text-white">Deposits</span>
      <DepositsList
        deposits={deposits}
      />
    </div>
  )
}
