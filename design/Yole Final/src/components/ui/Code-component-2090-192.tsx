import { AlertTriangle, Wifi, WifiOff } from 'lucide-react'
import { motion, AnimatePresence } from 'motion/react'
import { useAppContext } from '../../lib/app-context'

interface NetworkBannerProps {
  type: 'offline' | 'partner-unavailable' | 'error'
  message?: string
  onRetry?: () => void
  isVisible: boolean
}

export function NetworkBanner({ 
  type, 
  message, 
  onRetry, 
  isVisible 
}: NetworkBannerProps) {
  const { locale, theme } = useAppContext()
  const isDark = theme === 'dark'

  const getContent = () => {
    switch (type) {
      case 'offline':
        return {
          icon: <WifiOff className="h-4 w-4" />,
          title: locale === 'en' ? 'You\'re offline' : 'Vous êtes hors ligne',
          subtitle: locale === 'en' ? 'Check your connection' : 'Vérifiez votre connexion',
          bgColor: isDark ? 'bg-orange-500/10' : 'bg-orange-50',
          borderColor: isDark ? 'border-orange-500/20' : 'border-orange-200',
          textColor: isDark ? 'text-orange-300' : 'text-orange-700'
        }
      case 'partner-unavailable':
        return {
          icon: <AlertTriangle className="h-4 w-4" />,
          title: locale === 'en' ? 'Service unavailable' : 'Service indisponible',
          subtitle: locale === 'en' ? 'Please try again later' : 'Veuillez réessayer plus tard',
          bgColor: isDark ? 'bg-red-500/10' : 'bg-red-50',
          borderColor: isDark ? 'border-red-500/20' : 'border-red-200',
          textColor: isDark ? 'text-red-300' : 'text-red-700'
        }
      default:
        return {
          icon: <AlertTriangle className="h-4 w-4" />,
          title: message || (locale === 'en' ? 'Something went wrong' : 'Une erreur s\'est produite'),
          subtitle: locale === 'en' ? 'Please try again' : 'Veuillez réessayer',
          bgColor: isDark ? 'bg-red-500/10' : 'bg-red-50',
          borderColor: isDark ? 'border-red-500/20' : 'border-red-200',
          textColor: isDark ? 'text-red-300' : 'text-red-700'
        }
    }
  }

  const content = getContent()

  return (
    <AnimatePresence>
      {isVisible && (
        <motion.div
          initial={{ opacity: 0, y: -50 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: -50 }}
          transition={{ type: "spring", stiffness: 400, damping: 25 }}
          className={`mx-4 my-2 p-4 rounded-2xl border ${content.bgColor} ${content.borderColor} ${content.textColor}`}
        >
          <div className="flex items-center gap-3">
            <div className="flex-shrink-0">
              {content.icon}
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-medium text-sm">
                {content.title}
              </p>
              <p className="text-xs opacity-80 mt-1">
                {content.subtitle}
              </p>
            </div>
            {onRetry && (
              <button
                onClick={onRetry}
                className={`px-3 py-1.5 text-xs font-medium rounded-lg transition-colors touch-target ${
                  isDark 
                    ? 'bg-white/10 hover:bg-white/20 text-white' 
                    : 'bg-gray-900/10 hover:bg-gray-900/20 text-gray-900'
                }`}
              >
                {locale === 'en' ? 'Retry' : 'Réessayer'}
              </button>
            )}
          </div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}