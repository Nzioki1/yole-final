import { useState, useEffect } from 'react'
import { ArrowLeft, Eye, EyeOff } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { mockUser } from '../../lib/mock-data'
import { YoleLogo } from '../ui/yole-logo'

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
      // Minimal sparkles for subtle depth
      for (let i = 0; i < 15; i++) {
        newSparkles.push({
          delay: Math.random() * 3,
          duration: Math.random() * 4 + 6, // 6-10s gentle movement
          x: `${Math.random() * 100}%`,
          y: `${Math.random() * 100}%`,
          size: Math.random() * 2 + 1, // 1-3px
          opacity: Math.random() * 0.2 + 0.1, // 0.1-0.3 very subtle
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

export function LoginScreen() {
  const { locale, setCurrentView, setUser, setIsAuthenticated, theme } = useAppContext()
  const { t } = useTranslation(locale)
  const [showPassword, setShowPassword] = useState(false)
  const [formData, setFormData] = useState({
    email: '',
    password: ''
  })

  const isDark = theme === 'dark'

  const handleLogin = () => {
    // Mock login - in real app, would validate credentials
    setUser(mockUser)
    setIsAuthenticated(true)
    setCurrentView('home')
  }

  const updateFormData = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }))
  }

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d] relative overflow-hidden' 
        : 'bg-white'
    }`}>
      {/* Sparkle layer for dark variant only */}
      {isDark && <SparkleLayer />}

      {/* Header */}
      <div className={`relative z-10 flex items-center justify-between p-4 ${
        isDark ? 'border-b border-white/10' : 'border-b border-border'
      }`}>
        <button
          onClick={() => setCurrentView('splash')}
          className={`p-2 rounded-lg touch-target transition-colors ${
            isDark 
              ? 'hover:bg-white/5 text-white' 
              : 'hover:bg-muted text-foreground'
          }`}
        >
          <ArrowLeft className="h-6 w-6" />
        </button>
        <h1 className={`font-semibold ${
          isDark ? 'text-white' : 'text-foreground'
        }`}>
          {t('logIn')}
        </h1>
        <div className="w-10" />
      </div>

      {/* Content - Three-section layout with responsive spacing */}
      <div className="relative z-10 min-h-full flex flex-col px-6">
        
        {/* Top Section - YOLE Logo & Welcome (Fixed spacing: 24px + 8px) */}
        <motion.div 
          className="text-center pt-8 pb-8"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          {/* YOLE Logo - centered at top, 64-80px height, adaptive for light/dark */}
          <div className="flex justify-center mb-6">
            <YoleLogo 
              variant={isDark ? 'dark' : 'light'}
              className="h-20 w-auto"
            />
          </div>
          
          {/* Welcome back text - 24px spacing from logo, 8px between title/subtitle */}
          <div className="space-y-2">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Welcome back' : 'Bon retour'}
            </h2>
            <p className={`${
              isDark ? 'text-white/70' : 'text-muted-foreground'
            }`}>
              {locale === 'en' 
                ? 'Sign in to your Yole account'
                : 'Connectez-vous à votre compte Yole'
              }
            </p>
          </div>
        </motion.div>

        {/* Middle Section - Form Block (Vertically centered) */}
        <div className="flex-1 flex items-center justify-center">
          <motion.div 
            className={`w-full max-w-sm ${
              isDark 
                ? 'bg-white/8 backdrop-blur-medium border border-white/10 rounded-2xl p-6' 
                : ''
            }`}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3, duration: 0.6 }}
          >
            {/* Form fields - 16px spacing */}
            <div className="space-y-4">
              <div>
                <Label 
                  htmlFor="email"
                  className={isDark ? 'text-white/90' : ''}
                >
                  {t('email')}
                </Label>
                <Input
                  id="email"
                  type="email"
                  value={formData.email}
                  onChange={(e) => updateFormData('email', e.target.value)}
                  placeholder="you@example.com"
                  className={isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50' : ''}
                />
              </div>
              
              <div>
                <Label 
                  htmlFor="password"
                  className={isDark ? 'text-white/90' : ''}
                >
                  {t('password')}
                </Label>
                <div className="relative">
                  <Input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={formData.password}
                    onChange={(e) => updateFormData('password', e.target.value)}
                    placeholder={locale === 'en' ? 'Enter your password' : 'Entrez votre mot de passe'}
                    className={isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50 pr-12' : 'pr-12'}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className={`absolute right-3 top-3 transition-colors ${
                      isDark 
                        ? 'text-white/50 hover:text-white/80' 
                        : 'text-muted-foreground hover:text-foreground'
                    }`}
                  >
                    {showPassword ? (
                      <EyeOff className="h-5 w-5" />
                    ) : (
                      <Eye className="h-5 w-5" />
                    )}
                  </button>
                </div>
              </div>

              {/* Forgot password link - 8px spacing */}
              <div className="pt-2">
                <button 
                  onClick={() => setCurrentView('forgot-password')}
                  className={`text-sm font-medium transition-colors ${
                    isDark 
                      ? 'text-primary-gradient-start hover:text-primary-gradient-end' 
                      : 'text-primary hover:underline'
                  }`}
                >
                  {locale === 'en' ? 'Forgot password?' : 'Mot de passe oublié ?'}
                </button>
              </div>
            </div>

            {/* Log In button - 24px spacing from links */}
            <div className="pt-6">
              <GradientButton 
                className="w-full h-12"
                onClick={handleLogin}
              >
                {t('logIn')}
              </GradientButton>
            </div>
          </motion.div>
        </div>

        {/* Bottom Section - Sign Up link (24-32px from bottom edge) */}
        <motion.div 
          className="text-center pb-8"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.5, duration: 0.6 }}
        >
          <span className={`text-sm ${
            isDark ? 'text-white/60' : 'text-muted-foreground'
          }`}>
            {locale === 'en' ? 'Don\'t have an account? ' : 'Vous n\'avez pas de compte ? '}
          </span>
          <button
            onClick={() => setCurrentView('signup')}
            className={`text-sm font-medium transition-colors ${
              isDark 
                ? 'text-primary-gradient-start hover:text-primary-gradient-end' 
                : 'text-primary hover:underline'
            }`}
          >
            {t('signUp')}
          </button>
        </motion.div>
      </div>
    </div>
  )
}