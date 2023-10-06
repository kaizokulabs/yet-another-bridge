
export const ethereum_bridge_addr = "0x960a18665215110c749a34eca4c49616db66a647"
export const starknet_bridge_addr = "0x0000000"

export const herodotus_api_endpoint = "https://api.herodotus.cloud/"
export const herodotus_api_key = process.env.HERODOTUS_API_KEY as string

export const available_networks = [
  {
    name: "Ethereum",
    id: "ethereum",
    logo: "/images/ethereum-logo.png",
    chainId: 1,
  },
  {
    name: "Starknet",
    id: "starknet",
    logo: "/images/starknet-logo.png",
    chainId: 2,
  },
]
 
export const available_tokens = [
  {
    name: "ETH",
    id: "eth",
    logo: "/images/ethereum-logo.png",
  },
  {
    name: "yabETH",
    id: "yabeth",
    logo: "/images/starknet-logo.png",
  },
]
