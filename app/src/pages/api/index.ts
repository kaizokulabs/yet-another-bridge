import type { NextApiRequest, NextApiResponse } from 'next'

export default function handler(
  _req: NextApiRequest,
  res: NextApiResponse<any>
) {
  res.status(200).json({ data: 'Alive' })
}
