
export default function Footer() {
  return (
    <div className="w-full mt-24">
      <div className="flex items-center justify-center text-xl text-white">
        Powered by:
      </div>
      <div className="flex flex-row items-center justify-center">
        <a href="https://yetanotherswap.com" target="_blank">
          <div className="font-['Comic_Neue'] text-4xl font-bold text-fuchsia-500">
            YAS.
          </div>
        </a>
        <a href="https://herodotus.dev" target="_blank">
          <img
            className="ml-10 h-10"
            src="/images/herodotus-logo.svg"
            alt="logo"
          />
        </a>
        <a href="https://github.com/kaizokulabs" target="_blank">
          <img
            className="ml-10 h-24"
            src="/images/kaizoku-logo.png"
            alt="logo"
          />
        </a>
      </div>
    </div>
  )
}
