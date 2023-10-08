import { useRouter } from "next/router";
import { useEffect, useState } from "react"

export default function DepositsList(props: any) {
  const [deposits, setDeposits] = useState({})
  const router = useRouter()

  useEffect(() => {
    console.log(props)
    setDeposits(props.deposits)
  }, [props])

  return (
    <table className="table-auto w-1/2 mt-6 text-white">
      <thead>
        <tr>
          <th className="px-4 py-2">Deposit ID</th>
          <th className="px-4 py-2">Amount</th>
          <th className="px-4 py-2">Status</th>
        </tr>
      </thead>
      <tbody>
        { Object.entries(deposits).map((deposit: any) => {
          return (
            <tr onClick={() => router.push('/deposits/' + deposit[1].id)} key={deposit[1].id} className="cursor-pointer">
              <td className="border px-4 py-2">{deposit[1].id}</td>
              <td className="border px-4 py-2">{deposit[1].amount}</td>
              <td className="border px-4 py-2">{deposit[1].status}</td>
            </tr>
          )
        })}
      </tbody>
    </table>
  )
}
