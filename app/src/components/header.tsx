import ConnectEvmWallet from "./wallet/ethereum/wallet";
import ConnectStarknetWallet from "./wallet/starknet/wallet";

export default function Header() {
  return (
    <div className="flex flex-row items-center justify-between w-full">
      <div className="flex flex-row items-center justify-start">
      </div>
      <div className="flex flex-row items-center justify-end gap-4">
        <ConnectEvmWallet />
        <ConnectStarknetWallet />
      </div>
    </div>
  )
}
