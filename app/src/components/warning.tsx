import { Alert } from "@mui/material";

export default function Warning() {
  return (
    <div className="mt-8 w-full flex items-center justify-center">
      <Alert severity="error">This bridge is highly experimental, interacting with it will lead to loss of funds!</Alert>
    </div>
  )
}
