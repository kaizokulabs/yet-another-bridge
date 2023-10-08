import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { CookiesProvider } from 'react-cookie';
import { EthereumProvider } from '@/components/wallet/ethereum/ethereum-provider'
import { StarknetProvider } from "@/components/wallet/starknet/starknet-provider"
import Footer from '@/components/footer'
import Header from '@/components/header'
import Warning from '@/components/warning'

export default function App({ Component, pageProps }: AppProps) {
  return (
    <CookiesProvider defaultSetOptions={{ path: '/' }}>
    <EthereumProvider>
    <StarknetProvider>
      <div className="min-h-screen p-2">
        <Header />
        <Warning />
        <Component {...pageProps} />
        <Footer />
      </div>
    </StarknetProvider>
    </EthereumProvider>
    </CookiesProvider>
  )
}
