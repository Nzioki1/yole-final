import { Send, Heart, Search } from 'lucide-react'
import { GradientButton } from './gradient-button'
import { useAppContext } from '../../lib/app-context'
import { motion } from 'motion/react'

interface EmptyStateProps {
  type: 'no-transactions' | 'no-favorites' | 'no-search-results'
  onAction?: () => void
  className?: string
}

export function EmptyState({ type, onAction, className = '' }: EmptyStateProps) {
  const { locale, theme } = useAppContext()
  const isDark = theme === 'dark'

  const config = {
    'no-transactions': {
      icon: Send,
      headline: locale === 'en' ? 'No transactions yet' : 'Aucune transaction encore',
      subtext: locale === 'en' 
        ? 'When you start sending or receiving money, they\'ll show up here.'
        : 'Lorsque vous commencerez à envoyer ou recevoir de l\'argent, cela apparaîtra ici.',
      ctaText: locale === 'en' ? 'Make your first transaction' : 'Faire votre première transaction'
    },
    'no-favorites': {
      icon: Heart,
      headline: locale === 'en' ? 'No favorites yet' : 'Aucun favori encore',
      subtext: locale === 'en'
        ? 'Save frequent contacts to access them faster.'
        : 'Enregistrez des contacts fréquents pour y accéder plus rapidement.',
      ctaText: locale === 'en' ? 'Add a favorite' : 'Ajouter un favori'
    },
    'no-search-results': {
      icon: Search,
      headline: locale === 'en' ? 'No results found' : 'Aucun résultat trouvé',
      subtext: locale === 'en'
        ? 'Try adjusting your search or check spelling.'
        : 'Essayez d\'ajuster votre recherche ou vérifiez l\'orthographe.',
      ctaText: locale === 'en' ? 'Search again' : 'Rechercher à nouveau'
    }
  }

  const { icon: Icon, headline, subtext, ctaText } = config[type]

  return (
    <motion.div 
      className={`text-center py-16 px-6 space-y-8 max-w-sm mx-auto ${className}`}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
    >
      {/* Icon Illustration */}
      <motion.div 
        className="flex justify-center mb-8"
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ delay: 0.2, type: "spring", stiffness: 400, damping: 25 }}
      >
        <div className={`w-24 h-24 sm:w-32 sm:h-32 rounded-full flex items-center justify-center ${
          isDark 
            ? 'bg-white/8 border border-white/10' 
            : 'bg-gradient-primary'
        }`}>
          <Icon className={`h-10 w-10 sm:h-12 sm:w-12 ${
            isDark ? 'text-white' : 'text-white'
          }`} />
        </div>
      </motion.div>

      {/* Content */}
      <motion.div 
        className="space-y-4"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.4, duration: 0.6 }}
      >
        <h3 className={`text-xl sm:text-2xl font-bold ${
          isDark ? 'text-white' : 'text-foreground'
        }`}>
          {headline}
        </h3>
        <p className={`leading-relaxed ${
          isDark ? 'text-white/70' : 'text-muted-foreground'
        }`}>
          {subtext}
        </p>
      </motion.div>

      {/* CTA Button */}
      {onAction && (
        <motion.div 
          className="pt-8"
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6, duration: 0.6 }}
        >
          <GradientButton 
            onClick={onAction}
            className="w-full h-12 touch-target"
          >
            <Icon className="h-4 w-4 mr-2" />
            {ctaText}
          </GradientButton>
        </motion.div>
      )}
    </motion.div>
  )
}

// Specific empty state components for easier usage
export function NoTransactionsEmpty({ onAction }: { onAction?: () => void }) {
  return <EmptyState type="no-transactions" onAction={onAction} />
}

export function NoFavoritesEmpty({ onAction }: { onAction?: () => void }) {
  return <EmptyState type="no-favorites" onAction={onAction} />
}

export function NoSearchResultsEmpty({ onAction }: { onAction?: () => void }) {
  return <EmptyState type="no-search-results" onAction={onAction} />
}