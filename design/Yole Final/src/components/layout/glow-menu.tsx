import { Home, Send, Heart, User } from 'lucide-react'
import { motion } from 'motion/react'
import { cn } from '../ui/utils'
import { useTranslation } from '../../lib/i18n'

interface GlowMenuProps {
  activeTab: 'home' | 'send' | 'favorites' | 'profile'
  onTabChange: (tab: 'home' | 'send' | 'favorites' | 'profile') => void
  locale: 'en' | 'fr'
}

interface TabItemProps {
  id: 'home' | 'send' | 'favorites' | 'profile'
  icon: React.ComponentType<{ className?: string }>
  label: string
  isActive: boolean
  onClick: () => void
}

function TabItem({ id, icon: Icon, label, isActive, onClick }: TabItemProps) {
  return (
    <button
      onClick={onClick}
      className={cn(
        // Base styles
        "relative flex flex-col items-center justify-center",
        "px-3 py-2 rounded-2xl transition-all duration-300 ease-out",
        "touch-target group transform-gpu",
        // Subtle hover effects (reduced since icon has its own animations)
        "hover:scale-102 active:scale-98",
        // Active/inactive states
        isActive 
          ? "text-white" 
          : "text-muted-foreground hover:text-foreground"
      )}
    >
      {/* Glow Background - Only visible when active */}
      {isActive && (
        <>
          {/* Main glow effect */}
          <div className={cn(
            "absolute inset-0 rounded-2xl opacity-90",
            "bg-gradient-to-br from-blue-500 to-purple-600",
            "animate-pulse-glow"
          )} />
          
          {/* Outer glow ring - theme adaptive */}
          <div className={cn(
            "absolute inset-0 rounded-2xl blur-lg opacity-40",
            "bg-gradient-to-br from-blue-400 to-purple-500",
            "dark:opacity-60 dark:blur-xl",
            "-z-10 scale-110"
          )} />
        </>
      )}
      
      {/* Content */}
      <div className="relative z-10 flex flex-col items-center">
        <motion.div
          whileHover={{ 
            scale: 1.15,
            filter: isActive ? "drop-shadow(0 0 8px rgba(59, 130, 246, 0.5))" : "drop-shadow(0 0 6px rgba(148, 163, 184, 0.3))"
          }}
          whileTap={{ scale: 0.9 }}
          transition={{ 
            type: "spring", 
            stiffness: 400, 
            damping: 25 
          }}
          className="flex items-center justify-center"
        >
          <Icon className={cn(
            "h-6 w-6 mb-1",
            // Icon sizing - 20-24px as specified
            isActive ? "h-6 w-6" : "h-5 w-5"
          )} />
        </motion.div>
        <span className={cn(
          // Label sizing - 12-14px as specified
          "text-xs font-medium transition-all duration-200",
          "group-hover:scale-105 group-active:scale-95",
          // Ensure readability
          isActive ? "font-semibold" : "font-medium"
        )}>
          {label}
        </span>
      </div>
    </button>
  )
}

export function GlowMenu({ activeTab, onTabChange, locale }: GlowMenuProps) {
  const { t } = useTranslation(locale)

  const tabs = [
    { id: 'home' as const, icon: Home, label: t('home') },
    { id: 'send' as const, icon: Send, label: t('send') },
    { id: 'favorites' as const, icon: Heart, label: t('favorites') },
    { id: 'profile' as const, icon: User, label: t('profile') },
  ]

  return (
    <div className={cn(
      // Fixed positioning
      "fixed bottom-0 left-0 right-0 z-50",
      // Container styling with glassmorphism
      "bg-card/95 backdrop-blur-xl border-t border-border/50",
      // Enhanced shadow for depth
      "shadow-lg dark:shadow-2xl"
    )}>
      <div className={cn(
        // Container with corner radius 16-20px as specified
        "flex items-center justify-around rounded-t-2xl",
        "py-3 px-4 max-w-md mx-auto",
        // Material 3 spacing
        "gap-2"
      )}>
        {tabs.map((tab) => (
          <TabItem
            key={tab.id}
            id={tab.id}
            icon={tab.icon}
            label={tab.label}
            isActive={activeTab === tab.id}
            onClick={() => onTabChange(tab.id)}
          />
        ))}
      </div>
      
      {/* Bottom safe area for devices with home indicators */}
      <div className="h-safe-bottom bg-card/95" />
    </div>
  )
}