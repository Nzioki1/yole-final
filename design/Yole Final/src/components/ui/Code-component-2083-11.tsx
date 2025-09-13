import { Send, Heart, Search, TrendingUp } from 'lucide-react'
import { Button } from './button'
import { ImageWithFallback } from '../figma/ImageWithFallback'

interface EmptyStateProps {
  type: 'no-transactions' | 'no-favorites' | 'no-search-results'
  onAction?: () => void
  className?: string
}

export function EmptyState({ type, onAction, className = '' }: EmptyStateProps) {
  const config = {
    'no-transactions': {
      icon: Send,
      headline: 'No transactions yet',
      subtext: 'When you start sending or receiving money, they\'ll show up here.',
      ctaText: 'Make your first transaction',
      illustration: 'financial transaction empty'
    },
    'no-favorites': {
      icon: Heart,
      headline: 'No favorites yet',
      subtext: 'Save frequent contacts to access them faster.',
      ctaText: 'Add a favorite',
      illustration: 'contacts favorites empty'
    },
    'no-search-results': {
      icon: Search,
      headline: 'No results found',
      subtext: 'Try adjusting your search or check spelling.',
      ctaText: 'Search again',
      illustration: 'search empty results'
    }
  }

  const { icon: Icon, headline, subtext, ctaText, illustration } = config[type]

  return (
    <div className={`text-center py-12 px-4 space-y-6 ${className}`}>
      {/* Illustration */}
      <div className="flex justify-center mb-6">
        <div className="relative w-32 h-32">
          <ImageWithFallback 
            src={`https://images.unsplash.com/photo-1631823794808-b359f1132de9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlbXB0eSUyMHN0YXRlJTIwaWxsdXN0cmF0aW9uJTIwZmluYW5jaWFsJTIwYXBwfGVufDF8fHx8MTc1NzA5NzI5N3ww&ixlib=rb-4.1.0&q=80&w=1080`}
            alt={headline}
            className="w-32 h-32 rounded-2xl object-cover opacity-40"
          />
          {/* Overlay icon for context */}
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center shadow-lg">
              <Icon className="h-8 w-8 text-white" />
            </div>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-sm mx-auto space-y-4">
        <h3 className="text-xl font-semibold text-foreground">
          {headline}
        </h3>
        <p className="text-muted-foreground leading-relaxed">
          {subtext}
        </p>
      </div>

      {/* CTA Button */}
      {onAction && (
        <div className="pt-4">
          <Button 
            onClick={onAction}
            className="w-full max-w-sm h-12 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-semibold shadow-lg hover:shadow-xl touch-target"
          >
            <Icon className="h-5 w-5 mr-2" />
            {ctaText}
          </Button>
        </div>
      )}
    </div>
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