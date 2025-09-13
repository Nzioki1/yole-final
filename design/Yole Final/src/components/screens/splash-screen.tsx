import { motion } from 'motion/react'
import { Button } from '../ui/button'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { useEffect, useState } from 'react'

// Individual sparkle component
interface SparkleProps {
  delay: number
  duration: number
  x: string
  y: string
  size: number
  opacity: number
}

function Sparkle({ delay, duration, x, y, size, opacity }: SparkleProps) {
  return (
    <motion.div
      className="absolute rounded-full bg-white"
      style={{
        left: x,
        top: y,
        width: size,
        height: size,
      }}
      initial={{ opacity: 0, scale: 0, y: 10 }}
      animate={{
        opacity: [0, opacity, opacity * 0.8, opacity, 0],
        scale: [0, 1, 1, 1, 0],
        y: [10, 0, -5, 0, 10],
        x: [0, Math.random() * 4 - 2, Math.random() * 6 - 3, 0],
      }}
      transition={{
        duration: duration,
        delay: delay,
        repeat: Infinity,
        repeatDelay: Math.random() * 3 + 2,
        ease: "easeInOut"
      }}
    />
  )
}

// Toggleable sparkle layer component
interface SparkleLayerProps {
  enabled?: boolean
}

function SparkleLayer({ enabled = true }: SparkleLayerProps) {
  const [sparkles, setSparkles] = useState<SparkleProps[]>([])

  useEffect(() => {
    if (!enabled) return

    const generateSparkles = () => {
      const newSparkles: SparkleProps[] = []
      // 120 sparkles for medium density across phone viewport
      for (let i = 0; i < 120; i++) {
        newSparkles.push({
          delay: Math.random() * 1, // Fade in over ~1s on load
          duration: Math.random() * 6 + 8, // 8-14s slow drift
          x: `${Math.random() * 100}%`,
          y: `${Math.random() * 100}%`,
          size: Math.random() * 0.7 + 0.5, // 0.5-1.2px size
          opacity: Math.random() * 0.25 + 0.35, // 35-60% opacity
        })
      }
      setSparkles(newSparkles)
    }

    generateSparkles()
  }, [enabled])

  if (!enabled) return null

  return (
    <motion.div 
      className="absolute inset-0 overflow-hidden pointer-events-none"
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 1, ease: "easeInOut" }} // Fade in over 1s
    >
      {sparkles.map((sparkle, index) => (
        <Sparkle key={index} {...sparkle} />
      ))}
    </motion.div>
  )
}

// Main splash screen component with variants
interface SplashScreenProps {
  variant?: 'dark' | 'light'
  sparklesEnabled?: boolean
}

export function SplashScreen({ 
  variant = 'dark', 
  sparklesEnabled = true 
}: SplashScreenProps) {
  const { locale, setCurrentView } = useAppContext()
  const { t } = useTranslation(locale)

  const isDark = variant === 'dark'

  return (
    <div className={`min-h-screen relative overflow-hidden ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d]' 
        : 'bg-gradient-to-b from-slate-50 to-white'
    }`}>
      {/* Sparkle layer - behind content, toggleable */}
      <SparkleLayer enabled={sparklesEnabled} />
      
      {/* Main Content - Three-section balanced layout */}
      <div className="relative z-10 min-h-screen flex flex-col px-6 py-8">
        
        {/* Top Section - Equal air space above logo */}
        <div className="flex-1 min-h-[80px]" />
        
        {/* Top Third - YOLE Logo/Title */}
        <motion.div 
          className="text-center"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          <h1 className={`text-6xl font-bold tracking-tight leading-none ${
            isDark ? 'text-white' : 'text-slate-900'
          }`}>
            YOLE
          </h1>
        </motion.div>

        {/* Middle Section - Tagline and CTAs */}
        <motion.div 
          className="text-center space-y-8 pt-8 max-w-sm mx-auto"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3, duration: 0.6 }}
        >
          {/* Tagline - 24-32px spacing from title, smaller font, medium weight, ~70% opacity */}
          <p className={`text-base font-medium leading-relaxed max-w-xs mx-auto ${
            isDark ? 'text-white/70' : 'text-slate-600'
          }`}>
            {locale === 'en' 
              ? 'Send money to the DRC quickly and securely'
              : 'Envoyez de l\'argent en RDC rapidement et en sécurité'
            }
          </p>

          {/* CTAs with ample breathing space */}
          <div className="space-y-5 pt-4">
            {/* Primary Get Started - positioned directly below tagline with ample breathing space */}
            <Button
              className="w-full h-12 rounded-2xl bg-gradient-to-r from-[#3B82F6] to-[#8B5CF6] hover:from-blue-600 hover:to-purple-700 text-white font-semibold shadow-lg hover:shadow-xl transition-all duration-200 touch-target"
              onClick={() => setCurrentView('welcome')}
            >
              {locale === 'en' ? 'Get started' : 'Commencer'}
            </Button>
            
            {/* Secondary Log In - 16-20px consistent spacing below Sign Up */}
            <Button
              variant="ghost"
              className={`w-full h-12 font-medium transition-colors touch-target hover:bg-transparent ${
                isDark 
                  ? 'text-white/80 hover:text-white' 
                  : 'text-slate-700 hover:text-slate-900'
              }`}
              onClick={() => setCurrentView('login')}
            >
              {t('logIn')}
            </Button>
          </div>
        </motion.div>

        {/* Bottom Section - Equal air space below language selector */}
        <div className="flex-1 min-h-[80px]" />

        {/* Language Selector - anchored to bottom center with 24-32px safe area padding */}
        <motion.div 
          className="text-center pb-8"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.6 }}
        >
          <Button
            variant="ghost"
            size="sm"
            onClick={() => setCurrentView('language')}
            className={`flex items-center space-x-3 text-sm transition-colors mx-auto touch-target hover:bg-transparent px-4 py-2 ${
              isDark 
                ? 'text-white/70 hover:text-white/90' 
                : 'text-slate-500 hover:text-slate-700'
            }`}
          >
            <span className="text-base">
              {locale === 'en' ? '🇺🇸' : '🇫🇷'}
            </span>
            <span className="font-medium">
              {locale === 'en' ? 'English' : 'Français'}
            </span>
          </Button>
        </motion.div>
      </div>
    </div>
  )
}

// Default export using app context for automatic theme detection
export default function SplashScreenWithContext() {
  const { theme } = useAppContext()
  
  return (
    <SplashScreen 
      variant={theme === 'dark' ? 'dark' : 'light'} 
      sparklesEnabled={true} 
    />
  )
}