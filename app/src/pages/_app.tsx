import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { EthereumProvider } from '@/components/wallet/ethereum/ethereum-provider'
import { StarknetProvider } from "@/components/wallet/starknet/starknet-provider"

export default function App({ Component, pageProps }: AppProps) {
  return (
    <EthereumProvider>
      <StarknetProvider>
        <Component {...pageProps} />
      </StarknetProvider>
    </EthereumProvider>
  )
}
