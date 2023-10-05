import Header from '@/components/header';
import Footer from '@/components/footer';
import Bridge from '@/components/bridge';

export default function Home() {
  return (
    <main className="min-h-screen p-2">
      <Header />
      <div className="flex flex-col items-center justify-center w-full mt-24">
        <Bridge />
      </div>
      <Footer />
    </main>
  )
}
