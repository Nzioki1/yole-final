import { AlertTriangle, Wifi, WifiOff, X } from 'lucide-react'
import { useState } from 'react'
import { Button } from './button'

interface ErrorBannerProps {
  type: 'offline' | 'service-unavailable'
  onDismiss?: () => void
  className?: string
}

export function ErrorBanner({ type, onDismiss, className = '' }: ErrorBannerProps) {
  const [isVisible, setIsVisible] = useState(true)

  if (!isVisible) return null

  const handleDismiss = () => {
    setIsVisible(false)
    onDismiss?.()
  }

  const config = {
    offline: {
      icon: WifiOff,
      text: "You're offline — check your connection.",
      bgColor: 'bg-destructive/10',
      borderColor: 'border-destructive/20',
      textColor: 'text-destructive',
      iconColor: 'text-destructive'
    },
    'service-unavailable': {
      icon: AlertTriangle,
      text: "Service unavailable — please try again later.",
      bgColor: 'bg-orange-500/10',
      borderColor: 'border-orange-500/20',
      textColor: 'text-orange-600',
      iconColor: 'text-orange-500'
    }
  }

  const { icon: Icon, text, bgColor, borderColor, textColor, iconColor } = config[type]

  return (
    <div className={`${bgColor} ${borderColor} ${textColor} border rounded-2xl p-4 mx-4 mt-4 ${className}`}>
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3 flex-1 min-w-0">
          <div className={`w-8 h-8 ${bgColor} rounded-full flex items-center justify-center flex-shrink-0`}>
            <Icon className={`h-4 w-4 ${iconColor}`} />
          </div>
          <p className={`font-medium text-sm ${textColor} truncate`}>
            {text}
          </p>
        </div>
        
        {onDismiss && (
          <Button
            variant="ghost"
            size="sm"
            onClick={handleDismiss}
            className={`h-8 w-8 p-0 ml-2 hover:${bgColor} flex-shrink-0`}
          >
            <X className={`h-4 w-4 ${iconColor}`} />
          </Button>
        )}
      </div>
    </div>
  )
}

// Global banner that shows at the top of the app
export function GlobalErrorBanner({ type, onDismiss }: { type: 'offline' | 'service-unavailable', onDismiss?: () => void }) {
  return (
    <div className="fixed top-0 left-0 right-0 z-50 max-w-md mx-auto">
      <ErrorBanner type={type} onDismiss={onDismiss} className="mt-12" />
    </div>
  )
}