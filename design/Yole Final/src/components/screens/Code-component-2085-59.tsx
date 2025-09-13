import { useState, useEffect } from 'react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'
import { ImageWithFallback } from '../figma/ImageWithFallback'

// Sparkle component for dark variant background
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
      initial={{ opacity: 0, scale: 0 }}
      animate={{
        opacity: [0, opacity, 0],
        scale: [0, 1, 0],
        y: [0, -8, 0],
      }}
      transition={{
        duration: duration,
        delay: delay,
        repeat: Infinity,
        repeatDelay: Math.random() * 4 + 3,
        ease: "easeInOut"
      }}
    />
  )
}

// Subtle sparkle layer for dark variant
function SparkleLayer() {
  const [sparkles, setSparkles] = useState<SparkleProps[]>([])

  useEffect(() => {
    const generateSparkles = () => {
      const newSparkles: SparkleProps[] = []
      for (let i = 0; i < 20; i++) {
        newSparkles.push({
          delay: Math.random() * 3,
          duration: Math.random() * 4 + 6,
          x: `${Math.random() * 100}%`,
          y: `${Math.random() * 100}%`,
          size: Math.random() * 2 + 1,
          opacity: Math.random() * 0.3 + 0.1,
        })
      }
      setSparkles(newSparkles)
    }

    generateSparkles()
  }, [])

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {sparkles.map((sparkle, index) => (
        <Sparkle key={index} {...sparkle} />
      ))}
    </div>
  )
}

export function WelcomeScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const isDark = theme === 'dark'

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d] relative overflow-hidden' 
        : 'bg-gradient-to-b from-blue-50 to-purple-50'
    }`}>
      {/* Sparkle layer for dark variant only */}
      {isDark && <SparkleLayer />}

      {/* Content */}
      <div className="relative z-10 min-h-full flex flex-col px-6">
        
        {/* Top Section - Hero Image */}
        <motion.div 
          className="flex-1 flex items-center justify-center pt-16 pb-8"
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          <div className="relative">
            <ImageWithFallback 
              src="https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb25leSUyMHRyYW5zZmVyJTIwZmluYW5jaWFsJTIwYXBwfGVufDF8fHx8MTc1NzA5NzI5N3ww&ixlib=rb-4.1.0&q=80&w=1080"
              alt="Money transfer illustration"
              className="w-64 h-64 object-cover rounded-3xl shadow-2xl"
            />
            {/* Overlay gradient for illustration */}
            <div className={`absolute inset-0 rounded-3xl ${
              isDark 
                ? 'bg-gradient-to-t from-purple-900/40 to-blue-600/40' 
                : 'bg-gradient-to-t from-purple-100/60 to-blue-100/60'
            }`} />
          </div>
        </motion.div>

        {/* Middle Section - YOLE Logo & Content */}
        <motion.div 
          className="text-center space-y-6 pb-8"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3, duration: 0.8, ease: "easeOut" }}
        >
          {/* YOLE Logo */}
          <div className="flex justify-center mb-8">
            <YoleLogo 
              variant={isDark ? 'dark' : 'light'}
              className="h-16 w-auto"
            />
          </div>
          
          {/* Headline */}
          <div className="space-y-4">
            <h1 className={`text-3xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Quick and convenient' : 'Rapide et pratique'}
            </h1>
            
            {/* Subtext */}
            <p className={`text-lg leading-relaxed ${
              isDark ? 'text-white/70' : 'text-muted-foreground'
            }`}>
              {locale === 'en' 
                ? 'Send and receive money in minutes.' 
                : 'Envoyez et recevez de l\'argent en quelques minutes.'
              }
            </p>
          </div>
        </motion.div>

        {/* Bottom Section - CTA */}
        <motion.div 
          className="pb-12 space-y-4"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6, duration: 0.6 }}
        >
          <GradientButton 
            className="w-full h-14 text-lg font-semibold shadow-lg hover:shadow-xl"
            onClick={() => setCurrentView('register')}
          >
            {locale === 'en' ? 'Get started' : 'Commencer'}
          </GradientButton>
          
          {/* Sign In Link */}
          <div className="text-center">
            <span className={`text-sm ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}>
              {locale === 'en' ? 'Already have an account? ' : 'Vous avez déjà un compte ? '}
            </span>
            <button
              onClick={() => setCurrentView('login')}
              className={`text-sm font-medium transition-colors ${
                isDark 
                  ? 'text-primary-gradient-start hover:text-primary-gradient-end' 
                  : 'text-primary hover:underline'
              }`}
            >
              {locale === 'en' ? 'Sign in' : 'Se connecter'}
            </button>
          </div>
        </motion.div>
      </div>
    </div>
  )
}