
export default function Bridge() {
  return (
    <div className="w-96 bg-[#f0f0f0] rounded-lg">
      <div className="p-4">
        <div className="flex flex-col items-center justify-center">
          <div className="text-2xl font-bold">
            From:
          </div>
          Network - amount - token
          (Balance: available (clickable to fill))
        </div>

        <div className="flex flex-col items-center justify-center mt-8">
          <div className="text-2xl font-bold">
            To (estimated):
          </div>
          Network - amount - token
        </div>

      </div>
    </div>
  )
}
