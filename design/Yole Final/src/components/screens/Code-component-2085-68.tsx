import { useState } from 'react'
import { ArrowLeft, Mail, Clock } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'

export function EmailVerificationScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [isResending, setIsResending] = useState(false)
  const [countdown, setCountdown] = useState(0)
  
  const isDark = theme === 'dark'

  const handleResendEmail = () => {
    setIsResending(true)
    setCountdown(60)
    
    // Simulate sending email
    setTimeout(() => {
      setIsResending(false)
    }, 2000)
    
    // Countdown timer
    const timer = setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          clearInterval(timer)
          return 0
        }
        return prev - 1
      })
    }, 1000)
  }

  const handleCheckEmail = () => {
    // Simulate email verification success
    setCurrentView('kyc-phone')
  }

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d]' 
        : 'bg-white'
    }`}>
      {/* Header */}
      <div className={`flex items-center justify-between p-4 ${
        isDark ? 'border-b border-white/10' : 'border-b border-border'
      }`}>
        <button
          onClick={() => setCurrentView('register')}
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
          {locale === 'en' ? 'Verify Email' : 'Vérifier l\'email'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Content */}
      <div className="px-6 py-8 min-h-full flex flex-col">
        
        {/* Top Section - Logo & Illustration */}
        <motion.div 
          className="text-center flex-1 flex flex-col justify-center"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          {/* Logo */}
          <div className="flex justify-center mb-8">
            <YoleLogo 
              variant={isDark ? 'dark' : 'light'}
              className="h-16 w-auto"
            />
          </div>

          {/* Email Icon */}
          <motion.div 
            className={`w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-8 ${
              isDark 
                ? 'bg-white/10 border border-white/20' 
                : 'bg-gradient-primary'
            }`}
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.3, duration: 0.6, type: "spring" }}
          >
            <Mail className={`h-12 w-12 ${
              isDark ? 'text-white' : 'text-white'
            }`} />
          </motion.div>
          
          {/* Content */}
          <div className="space-y-4 max-w-sm mx-auto">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Check your email' : 'Vérifiez votre email'}
            </h2>
            
            <div className="space-y-3">
              <p className={`leading-relaxed ${
                isDark ? 'text-white/70' : 'text-muted-foreground'
              }`}>
                {locale === 'en' 
                  ? 'Verify your email to continue.'
                  : 'Vérifiez votre email pour continuer.'
                }
              </p>
              
              <p className={`text-sm ${
                isDark ? 'text-white/60' : 'text-muted-foreground'
              }`}>
                {locale === 'en' 
                  ? 'We sent a verification link to your email address. Click the link to activate your account.'
                  : 'Nous avons envoyé un lien de vérification à votre adresse email. Cliquez sur le lien pour activer votre compte.'
                }
              </p>
            </div>
          </div>
        </motion.div>

        {/* Bottom Section - Actions */}
        <motion.div 
          className="space-y-4 pt-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5, duration: 0.6 }}
        >
          {/* Mock "I've verified" button for demo */}
          <GradientButton 
            className="w-full h-12"
            onClick={handleCheckEmail}
          >
            {locale === 'en' ? 'Continue' : 'Continuer'}
          </GradientButton>

          {/* Resend Email */}
          <div className="text-center space-y-3">
            <p className={`text-sm ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}>
              {locale === 'en' ? 'Didn\'t receive the email?' : 'Vous n\'avez pas reçu l\'email ?'}
            </p>
            
            <button
              onClick={handleResendEmail}
              disabled={isResending || countdown > 0}
              className={`text-sm font-medium transition-colors disabled:opacity-50 ${
                isDark 
                  ? 'text-primary-gradient-start hover:text-primary-gradient-end disabled:text-white/30' 
                  : 'text-primary hover:underline disabled:text-muted-foreground'
              }`}
            >
              {isResending ? (
                <span className="flex items-center justify-center gap-2">
                  <Clock className="h-4 w-4 animate-spin" />
                  {locale === 'en' ? 'Sending...' : 'Envoi...'}
                </span>
              ) : countdown > 0 ? (
                `${locale === 'en' ? 'Resend in' : 'Renvoyer dans'} ${countdown}s`
              ) : (
                locale === 'en' ? 'Resend verification email' : 'Renvoyer l\'email de vérification'
              )}
            </button>
          </div>

          {/* Back to login */}
          <div className="text-center pt-4">
            <span className={`text-sm ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}>
              {locale === 'en' ? 'Wrong email? ' : 'Mauvais email ? '}
            </span>
            <button
              onClick={() => setCurrentView('register')}
              className={`text-sm font-medium transition-colors ${
                isDark 
                  ? 'text-primary-gradient-start hover:text-primary-gradient-end' 
                  : 'text-primary hover:underline'
              }`}
            >
              {locale === 'en' ? 'Go back' : 'Retourner'}
            </button>
          </div>
        </motion.div>
      </div>
    </div>
  )
}