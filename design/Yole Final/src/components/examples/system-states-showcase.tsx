import { useState } from 'react'
import { Button } from '../ui/button'
import { Card } from '../ui/card'
import { ErrorBanner, GlobalErrorBanner } from '../ui/error-banner'
import { EmptyState, NoTransactionsEmpty, NoFavoritesEmpty, NoSearchResultsEmpty } from '../ui/empty-state'
import { 
  TransactionListSkeleton, 
  SendFlowCardsSkeleton, 
  QuoteResultSkeleton,
  ActivityCardsSkeleton,
  ProfileHeaderSkeleton,
  LoadingOverlay,
  PageSkeleton
} from '../ui/loading-states'
import { useAppContext } from '../../lib/app-context'

export function SystemStatesShowcase() {
  const { locale } = useAppContext()
  const [showGlobalBanner, setShowGlobalBanner] = useState(false)
  const [bannerType, setBannerType] = useState<'offline' | 'service-unavailable'>('offline')
  const [activeDemo, setActiveDemo] = useState<'banners' | 'empty' | 'loading'>('banners')

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Global banner demo */}
      {showGlobalBanner && (
        <GlobalErrorBanner 
          type={bannerType} 
          onDismiss={() => setShowGlobalBanner(false)} 
        />
      )}

      {/* Header */}
      <div className="p-4 pt-12 pb-6">
        <h1 className="text-2xl font-semibold text-foreground mb-2">
          {locale === 'en' ? 'System States Demo' : 'Démo des états système'}
        </h1>
        <p className="text-muted-foreground mb-6">
          {locale === 'en' 
            ? 'Showcasing error banners, empty states, and loading skeletons' 
            : 'Présentation des bannières d\'erreur, états vides et squelettes de chargement'
          }
        </p>

        {/* Navigation tabs */}
        <div className="flex bg-muted rounded-2xl p-1 mb-6">
          {[
            { key: 'banners', label: locale === 'en' ? 'Error Banners' : 'Bannières d\'erreur' },
            { key: 'empty', label: locale === 'en' ? 'Empty States' : 'États vides' },
            { key: 'loading', label: locale === 'en' ? 'Loading States' : 'États de chargement' }
          ].map((tab) => (
            <button
              key={tab.key}
              onClick={() => setActiveDemo(tab.key as any)}
              className={`flex-1 px-4 py-2 rounded-xl text-sm font-medium transition-all duration-200 ${
                activeDemo === tab.key
                  ? 'bg-card text-foreground shadow-sm'
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Content based on active demo */}
      <div className="px-4 space-y-6">
        {activeDemo === 'banners' && (
          <>
            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Global Error Banners' : 'Bannières d\'erreur globales'}
              </h2>
              <div className="space-y-3">
                <Button 
                  onClick={() => {
                    setBannerType('offline')
                    setShowGlobalBanner(true)
                  }}
                  variant="outline"
                  className="w-full"
                >
                  {locale === 'en' ? 'Show Offline Banner' : 'Afficher bannière hors ligne'}
                </Button>
                <Button 
                  onClick={() => {
                    setBannerType('service-unavailable')
                    setShowGlobalBanner(true)
                  }}
                  variant="outline"
                  className="w-full"
                >
                  {locale === 'en' ? 'Show Service Unavailable Banner' : 'Afficher bannière service indisponible'}
                </Button>
              </div>
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Inline Error Banners' : 'Bannières d\'erreur en ligne'}
              </h2>
              <div className="space-y-3">
                <ErrorBanner type="offline" />
                <ErrorBanner type="service-unavailable" onDismiss={() => console.log('Dismissed')} />
              </div>
            </div>
          </>
        )}

        {activeDemo === 'empty' && (
          <>
            <Card className="p-0 overflow-hidden rounded-2xl">
              <NoTransactionsEmpty onAction={() => console.log('Make first transaction')} />
            </Card>

            <Card className="p-0 overflow-hidden rounded-2xl">
              <NoFavoritesEmpty onAction={() => console.log('Add favorite')} />
            </Card>

            <Card className="p-0 overflow-hidden rounded-2xl">
              <NoSearchResultsEmpty onAction={() => console.log('Search again')} />
            </Card>
          </>
        )}

        {activeDemo === 'loading' && (
          <>
            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Dashboard List Skeleton' : 'Squelette de liste du tableau de bord'}
              </h2>
              <TransactionListSkeleton count={3} />
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Activity Cards Skeleton' : 'Squelette des cartes d\'activité'}
              </h2>
              <ActivityCardsSkeleton />
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Send Flow Cards' : 'Cartes de flux d\'envoi'}
              </h2>
              <SendFlowCardsSkeleton count={2} />
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Quote Result Skeleton' : 'Squelette de résultat de devis'}
              </h2>
              <QuoteResultSkeleton />
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Profile Header Skeleton' : 'Squelette d\'en-tête de profil'}
              </h2>
              <ProfileHeaderSkeleton />
            </div>

            <div>
              <h2 className="font-semibold text-foreground mb-4">
                {locale === 'en' ? 'Loading Overlay' : 'Superposition de chargement'}
              </h2>
              <Card className="rounded-2xl">
                <LoadingOverlay message={locale === 'en' ? 'Processing transaction...' : 'Traitement de la transaction...'} />
              </Card>
            </div>
          </>
        )}
      </div>
    </div>
  )
}