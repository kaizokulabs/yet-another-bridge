import Link from "next/link";
import ConnectEvmWallet from "./wallet/ethereum/wallet";
import ConnectStarknetWallet from "./wallet/starknet/wallet";

export default function Header() {
  return (
    <div className="flex flex-row items-center justify-between w-full">
      <div className="pl-10 flex flex-row items-center justify-start gap-8 text-white">
        <Link href="/">
          Bridge
        </Link>
        <Link href="/deposits">
          Deposits
        </Link>
      </div>
      <div className="flex flex-row items-center justify-end gap-4">
        <ConnectEvmWallet />
        <ConnectStarknetWallet />
      </div>
    </div>
  )
}
