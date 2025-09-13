import { Home, Send, Heart, User } from 'lucide-react'
import { cn } from '../ui/utils'
import { useTranslation } from '../../lib/i18n'

interface BottomNavigationProps {
  activeTab: 'home' | 'send' | 'favorites' | 'profile'
  onTabChange: (tab: 'home' | 'send' | 'favorites' | 'profile') => void
  locale: 'en' | 'fr'
}

export function BottomNavigation({ activeTab, onTabChange, locale }: BottomNavigationProps) {
  const { t } = useTranslation(locale)

  const tabs = [
    { id: 'home' as const, icon: Home, label: t('home') },
    { id: 'send' as const, icon: Send, label: t('send') },
    { id: 'favorites' as const, icon: Heart, label: t('favorites') },
    { id: 'profile' as const, icon: User, label: t('profile') },
  ]

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-card border-t border-border">
      <div className="flex items-center justify-around py-2 px-4 max-w-md mx-auto">
        {tabs.map((tab) => {
          const Icon = tab.icon
          const isActive = activeTab === tab.id
          
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={cn(
                "flex flex-col items-center justify-center py-2 px-3 rounded-lg transition-colors touch-target",
                isActive 
                  ? "text-primary" 
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              <Icon className={cn("h-6 w-6 mb-1", isActive && "fill-current")} />
              <span className="text-xs font-medium">{tab.label}</span>
            </button>
          )
        })}
      </div>
    </div>
  )
}