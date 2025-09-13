import { Home, Send, Heart, User } from 'lucide-react'
import { cn } from '../ui/utils'
import { useTranslation } from '../../lib/i18n'

interface GlowMenuVariantsProps {
  activeTab: 'home' | 'send' | 'favorites' | 'profile'
  onTabChange: (tab: 'home' | 'send' | 'favorites' | 'profile') => void
  locale: 'en' | 'fr'
  variant?: 'default' | 'minimal' | 'bold'
  theme?: 'light' | 'dark' | 'auto'
}

interface TabItemProps {
  id: 'home' | 'send' | 'favorites' | 'profile'
  icon: React.ComponentType<{ className?: string }>
  label: string
  isActive: boolean
  onClick: () => void
  variant?: 'default' | 'minimal' | 'bold'
}

function TabItem({ id, icon: Icon, label, isActive, onClick, variant = 'default' }: TabItemProps) {
  const variantStyles = {
    default: {
      container: cn(
        "px-3 py-2 rounded-2xl",
        isActive && "bg-gradient-to-br from-blue-500 to-purple-600"
      ),
      glow: "opacity-30 dark:opacity-50 blur-sm",
      icon: isActive ? "h-6 w-6" : "h-5 w-5",
    },
    minimal: {
      container: cn(
        "px-2 py-1 rounded-xl",
        isActive && "bg-gradient-to-r from-blue-500 to-purple-500"
      ),
      glow: "opacity-20 dark:opacity-40 blur-lg",
      icon: "h-5 w-5",
    },
    bold: {
      container: cn(
        "px-4 py-3 rounded-3xl",
        isActive && "bg-gradient-to-br from-blue-600 via-purple-600 to-indigo-600"
      ),
      glow: "opacity-40 dark:opacity-70 blur-md scale-110",
      icon: isActive ? "h-7 w-7" : "h-6 w-6",
    }
  }

  const styles = variantStyles[variant]

  return (
    <button
      onClick={onClick}
      className={cn(
        // Base styles
        "relative flex flex-col items-center justify-center",
        "transition-all duration-300 ease-out touch-target group transform-gpu",
        // Hover effects
        "hover:scale-105 active:scale-95",
        "hover:[transform:perspective(500px)_rotateY(3deg)] active:[transform:perspective(500px)_rotateY(-3deg)]",
        // Container variant styles
        styles.container,
        // Text colors
        isActive 
          ? "text-white contrast-enhanced" 
          : "text-muted-foreground hover:text-foreground"
      )}
    >
      {/* Glow Effects - Only for active state */}
      {isActive && (
        <>
          {/* Outer glow */}
          <div className={cn(
            "absolute inset-0 rounded-inherit",
            "bg-gradient-to-br from-blue-400 to-purple-500",
            styles.glow,
            "-z-10"
          )} />
          
          {/* Ambient glow for dark mode */}
          {variant === 'bold' && (
            <div className={cn(
              "absolute inset-0 rounded-inherit blur-xl",
              "bg-gradient-to-br from-blue-300 to-purple-400",
              "opacity-0 dark:opacity-30 dark:scale-125",
              "-z-20"
            )} />
          )}
        </>
      )}
      
      {/* Content */}
      <div className="relative z-10 flex flex-col items-center">
        <Icon className={cn(
          "mb-1 transition-all duration-200",
          styles.icon,
          "group-hover:scale-110 group-active:scale-95",
          isActive && "drop-shadow-sm"
        )} />
        <span className={cn(
          "text-xs transition-all duration-200",
          "group-hover:scale-105 group-active:scale-95",
          variant === 'bold' ? "font-bold" : isActive ? "font-semibold" : "font-medium",
          isActive && "drop-shadow-sm"
        )}>
          {label}
        </span>
      </div>
    </button>
  )
}

export function GlowMenuVariants({ 
  activeTab, 
  onTabChange, 
  locale, 
  variant = 'default',
  theme = 'auto'
}: GlowMenuVariantsProps) {
  const { t } = useTranslation(locale)

  const tabs = [
    { id: 'home' as const, icon: Home, label: t('home') },
    { id: 'send' as const, icon: Send, label: t('send') },
    { id: 'favorites' as const, icon: Heart, label: t('favorites') },
    { id: 'profile' as const, icon: User, label: t('profile') },
  ]

  const containerVariants = {
    default: "py-3 px-4 rounded-t-2xl",
    minimal: "py-2 px-3 rounded-t-xl", 
    bold: "py-4 px-5 rounded-t-3xl"
  }

  return (
    <div className={cn(
      // Fixed positioning
      "fixed bottom-0 left-0 right-0 z-50",
      // Theme-specific backgrounds
      theme === 'light' && "bg-white/95 border-gray-200/50",
      theme === 'dark' && "bg-gray-900/95 border-gray-700/50", 
      theme === 'auto' && "bg-card/95 border-border/50",
      // Glassmorphism effect
      "backdrop-blur-xl border-t shadow-lg dark:shadow-2xl"
    )}>
      <div className={cn(
        "flex items-center justify-around max-w-md mx-auto gap-2",
        containerVariants[variant]
      )}>
        {tabs.map((tab) => (
          <TabItem
            key={tab.id}
            id={tab.id}
            icon={tab.icon}
            label={tab.label}
            isActive={activeTab === tab.id}
            onClick={() => onTabChange(tab.id)}
            variant={variant}
          />
        ))}
      </div>
      
      {/* Safe area */}
      <div className={cn(
        "h-safe-bottom",
        theme === 'light' && "bg-white/95",
        theme === 'dark' && "bg-gray-900/95", 
        theme === 'auto' && "bg-card/95"
      )} />
    </div>
  )
}

// Example usage components for demonstration
export function LightThemeExample({ activeTab, onTabChange, locale }: Omit<GlowMenuVariantsProps, 'theme'>) {
  return (
    <GlowMenuVariants
      activeTab={activeTab}
      onTabChange={onTabChange}
      locale={locale}
      variant="default"
      theme="light"
    />
  )
}

export function DarkThemeExample({ activeTab, onTabChange, locale }: Omit<GlowMenuVariantsProps, 'theme'>) {
  return (
    <GlowMenuVariants
      activeTab={activeTab}
      onTabChange={onTabChange}
      locale={locale}
      variant="bold"
      theme="dark"
    />
  )
}

export function MinimalVariantExample({ activeTab, onTabChange, locale }: Omit<GlowMenuVariantsProps, 'variant'>) {
  return (
    <GlowMenuVariants
      activeTab={activeTab}
      onTabChange={onTabChange}
      locale={locale}
      variant="minimal"
    />
  )
}