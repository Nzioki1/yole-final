import { useState } from 'react'
import { ArrowLeft, Wifi, WifiOff, AlertTriangle, RefreshCw } from 'lucide-react'
import { motion } from 'motion/react'
import { Button } from '../ui/button'
import { Card } from '../ui/card'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../ui/tabs'
import { NetworkBanner } from '../ui/network-banner'
import { NoTransactionsEmpty, NoFavoritesEmpty, NoSearchResultsEmpty } from '../ui/empty-state'
import { 
  TransactionListSkeleton, 
  SendFlowCardsSkeleton, 
  QuoteResultSkeleton,
  ActivityCardsSkeleton,
  LoadingOverlay,
  PageSkeleton
} from '../ui/loading-states'
import { useAppContext } from '../../lib/app-context'

export function SystemStatesDemoScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const isDark = theme === 'dark'

  const [networkState, setNetworkState] = useState<'online' | 'offline' | 'partner-error'>('online')
  const [showBanner, setShowBanner] = useState(false)

  const handleNetworkToggle = (state: 'online' | 'offline' | 'partner-error') => {
    setNetworkState(state)
    setShowBanner(true)
    // Auto-hide banner after 5 seconds
    setTimeout(() => setShowBanner(false), 5000)
  }

  const handleRetry = () => {
    setShowBanner(false)
    setNetworkState('online')
  }

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d]' 
        : 'bg-background'
    }`}>
      {/* Header */}
      <div className={`flex items-center justify-between p-4 pt-12 ${
        isDark ? 'border-b border-white/10' : 'border-b border-border'
      }`}>
        <button
          onClick={() => setCurrentView('home')}
          className={`p-2 rounded-lg touch-target transition-colors ${
            isDark 
              ? 'hover:bg-white/5 text-white' 
              : 'hover:bg-muted text-foreground'
          }`}
        >
          <ArrowLeft className="h-6 w-6" />
        </button>
        <h1 className={`font-semibold ${
          isDark ? 'text-white' : 'text-foreground'
        }`}>
          {locale === 'en' ? 'System States Demo' : 'Démo États Système'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Network Banner Demo */}
      <NetworkBanner
        type={networkState === 'offline' ? 'offline' : 'partner-unavailable'}
        isVisible={showBanner && networkState !== 'online'}
        onRetry={networkState === 'partner-error' ? handleRetry : undefined}
      />

      {/* Content */}
      <div className="px-6 py-6">
        <Tabs defaultValue="network" className="w-full">
          <TabsList className={`grid w-full grid-cols-3 mb-8 ${
            isDark ? 'bg-white/5 border-white/10' : ''
          }`}>
            <TabsTrigger value="network" className="text-sm">
              {locale === 'en' ? 'Network' : 'Réseau'}
            </TabsTrigger>
            <TabsTrigger value="empty" className="text-sm">
              {locale === 'en' ? 'Empty States' : 'États Vides'}
            </TabsTrigger>
            <TabsTrigger value="loading" className="text-sm">
              {locale === 'en' ? 'Loading' : 'Chargement'}
            </TabsTrigger>
          </TabsList>

          {/* Network States Tab */}
          <TabsContent value="network" className="space-y-6">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
            >
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-4 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Network Banner States' : 'États Bannières Réseau'}
                </h3>
                
                <div className="space-y-4">
                  <Button
                    onClick={() => handleNetworkToggle('offline')}
                    variant="outline"
                    className="w-full justify-start"
                  >
                    <WifiOff className="h-4 w-4 mr-2" />
                    {locale === 'en' ? 'Simulate Offline' : 'Simuler Hors Ligne'}
                  </Button>
                  
                  <Button
                    onClick={() => handleNetworkToggle('partner-error')}
                    variant="outline"
                    className="w-full justify-start"
                  >
                    <AlertTriangle className="h-4 w-4 mr-2" />
                    {locale === 'en' ? 'Simulate Partner Error' : 'Simuler Erreur Partenaire'}
                  </Button>
                  
                  <Button
                    onClick={() => {
                      setNetworkState('online')
                      setShowBanner(false)
                    }}
                    variant="outline"
                    className="w-full justify-start"
                  >
                    <Wifi className="h-4 w-4 mr-2" />
                    {locale === 'en' ? 'Back Online' : 'Retour En Ligne'}
                  </Button>
                </div>
              </Card>
            </motion.div>
          </TabsContent>

          {/* Empty States Tab */}
          <TabsContent value="empty" className="space-y-8">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
              className="space-y-8"
            >
              {/* No Transactions */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'No Transactions State' : 'État Aucune Transaction'}
                </h3>
                <NoTransactionsEmpty />
              </Card>

              {/* No Favorites */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'No Favorites State' : 'État Aucun Favori'}
                </h3>
                <NoFavoritesEmpty />
              </Card>

              {/* No Search Results */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'No Search Results State' : 'État Aucun Résultat'}
                </h3>
                <NoSearchResultsEmpty />
              </Card>
            </motion.div>
          </TabsContent>

          {/* Loading States Tab */}
          <TabsContent value="loading" className="space-y-8">
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.6 }}
              className="space-y-8"
            >
              {/* Transaction List Skeleton */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Transaction List Loading' : 'Chargement Liste Transactions'}
                </h3>
                <TransactionListSkeleton count={3} />
              </Card>

              {/* Send Flow Cards Skeleton */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Send Flow Cards Loading' : 'Chargement Cartes Envoi'}
                </h3>
                <SendFlowCardsSkeleton count={2} />
              </Card>

              {/* Activity Cards Skeleton */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Activity Cards Loading' : 'Chargement Cartes Activité'}
                </h3>
                <ActivityCardsSkeleton />
              </Card>

              {/* Quote Result Skeleton */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Quote Result Loading' : 'Chargement Résultat Devis'}
                </h3>
                <QuoteResultSkeleton />
              </Card>

              {/* Loading Overlay */}
              <Card className={`p-6 rounded-2xl ${
                isDark ? 'bg-white/8 border-white/10' : ''
              }`}>
                <h3 className={`text-lg font-semibold mb-6 ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Loading Overlay' : 'Superposition Chargement'}
                </h3>
                <LoadingOverlay 
                  message={locale === 'en' ? 'Processing your request...' : 'Traitement de votre demande...'}
                />
              </Card>
            </motion.div>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  )
}