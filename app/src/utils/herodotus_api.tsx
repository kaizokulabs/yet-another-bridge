import { herodotus_api_endpoint, herodotus_api_key } from "./constants";

export const herodotus_task_schedule = async (origin: string, destination: string, blockNum: number, address: string) => {
  const body = {
    originChain: origin,
    destinationChain: destination,
    blockNumber: blockNum,
    type: "ACCOUNT_ACCESS",
    requestedProperties: {
      ACCOUNT_ACCESS: {
        account: address,
        properties: [
          "balance",
          "storageHash"
        ]
      }
    },
  }

  const response = await fetch(herodotus_api_endpoint + '?apiKey=' + herodotus_api_key, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body)
  });
  const data = await response.json();
  return data;
}

export const herodotus_task_status = async (task_id: string) => {
  const response = await fetch(herodotus_api_endpoint + '/status/' + task_id + '?apiKey=' + herodotus_api_key);
  const data = await response.json();
  return data;
}
