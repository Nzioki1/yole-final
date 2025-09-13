import { SendMoneyFlow } from './send-money-flow'
import { useAppContext } from '../../lib/app-context'

export function SendScreen() {
  const { setCurrentView } = useAppContext()

  return (
    <SendMoneyFlow onBack={() => setCurrentView('home')} />
  )
}