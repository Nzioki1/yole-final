import { useState } from 'react'
import { ArrowLeft, Mail, CheckCircle } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'

export function ForgotPasswordScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [step, setStep] = useState<'request' | 'success'>('request')
  const [email, setEmail] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  
  const isDark = theme === 'dark'

  const handleSendResetLink = () => {
    setIsLoading(true)
    
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false)
      setStep('success')
    }, 2000)
  }

  const handleBackToLogin = () => {
    setCurrentView('login')
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
          onClick={handleBackToLogin}
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
          {locale === 'en' ? 'Reset Password' : 'Réinitialiser le mot de passe'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Content */}
      <div className="px-6 py-6 sm:py-8 min-h-[calc(100vh-80px)] flex flex-col">
        
        {step === 'request' && (
          <>
            {/* Top Section - Logo & Content */}
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

              {/* Mail Icon */}
              <motion.div 
                className={`w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-8 ${
                  isDark 
                    ? 'bg-white/10 border border-white/20' 
                    : 'bg-gradient-primary'
                }`}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.3, duration: 0.6, type: "spring" }}
              >
                <Mail className={`h-10 w-10 ${
                  isDark ? 'text-white' : 'text-white'
                }`} />
              </motion.div>
              
              {/* Content */}
              <div className="space-y-4 max-w-sm mx-auto mb-6 sm:mb-8">
                <h2 className={`text-xl sm:text-2xl font-bold ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Enter your email to reset your password.' : 'Entrez votre email pour réinitialiser votre mot de passe.'}
                </h2>
                
                <p className={`leading-relaxed ${
                  isDark ? 'text-white/70' : 'text-muted-foreground'
                }`}>
                  {locale === 'en' 
                    ? 'We\'ll send you reset instructions.'
                    : 'Nous vous enverrons les instructions de réinitialisation.'
                  }
                </p>
              </div>

              {/* Form */}
              <motion.div 
                className={`w-full max-w-sm mx-auto ${
                  isDark 
                    ? 'bg-white/8 backdrop-blur-medium border border-white/10 rounded-2xl p-6' 
                    : ''
                }`}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.4, duration: 0.6 }}
              >
                <div className="space-y-4">
                  <div>
                    <Label 
                      htmlFor="email"
                      className={isDark ? 'text-white/90' : ''}
                    >
                      {locale === 'en' ? 'Email address' : 'Adresse email'}
                    </Label>
                    <Input
                      id="email"
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="you@example.com"
                      className={isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50' : ''}
                    />
                  </div>
                </div>
              </motion.div>
            </motion.div>

            {/* Bottom Section - Actions */}
            <motion.div 
              className="space-y-4 pt-8"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6, duration: 0.6 }}
            >
              <GradientButton 
                className="w-full h-12"
                onClick={handleSendResetLink}
                disabled={!email || isLoading}
              >
                {isLoading 
                  ? (locale === 'en' ? 'Sending...' : 'Envoi...') 
                  : (locale === 'en' ? 'Send reset link' : 'Envoyer le lien de réinitialisation')
                }
              </GradientButton>

              {/* Back to login */}
              <div className="text-center">
                <span className={`text-sm ${
                  isDark ? 'text-white/60' : 'text-muted-foreground'
                }`}>
                  {locale === 'en' ? 'Remember your password? ' : 'Vous vous souvenez de votre mot de passe ? '}
                </span>
                <button
                  onClick={handleBackToLogin}
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
          </>
        )}

        {step === 'success' && (
          <>
            {/* Success State */}
            <motion.div 
              className="text-center flex-1 flex flex-col justify-center"
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ duration: 0.8, ease: "easeOut" }}
            >
              {/* Logo */}
              <div className="flex justify-center mb-8">
                <YoleLogo 
                  variant={isDark ? 'dark' : 'light'}
                  className="h-16 w-auto"
                />
              </div>

              {/* Success Icon */}
              <motion.div 
                className={`w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-8 ${
                  isDark 
                    ? 'bg-success/20 border border-success/30' 
                    : 'bg-success/10 border border-success/20'
                }`}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: 0.3, duration: 0.6, type: "spring" }}
              >
                <CheckCircle className="h-12 w-12 text-success" />
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
                      ? 'Check your email — we\'ve sent you reset instructions.'
                      : 'Vérifiez votre email — nous vous avons envoyé les instructions de réinitialisation.'
                    }
                  </p>
                  
                  <p className={`text-sm ${
                    isDark ? 'text-white/60' : 'text-muted-foreground'
                  }`}>
                    {locale === 'en' 
                      ? 'Follow the link in the email to reset your password.'
                      : 'Suivez le lien dans l\'email pour réinitialiser votre mot de passe.'
                    }
                  </p>
                </div>
              </div>
            </motion.div>

            {/* Bottom Actions */}
            <motion.div 
              className="space-y-4 pt-8"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5, duration: 0.6 }}
            >
              <GradientButton 
                className="w-full h-12"
                onClick={handleBackToLogin}
              >
                {locale === 'en' ? 'Back to login' : 'Retour à la connexion'}
              </GradientButton>

              {/* Resend */}
              <div className="text-center">
                <span className={`text-sm ${
                  isDark ? 'text-white/60' : 'text-muted-foreground'
                }`}>
                  {locale === 'en' ? 'Didn\'t receive the email? ' : 'Vous n\'avez pas reçu l\'email ? '}
                </span>
                <button
                  onClick={() => setStep('request')}
                  className={`text-sm font-medium transition-colors ${
                    isDark 
                      ? 'text-primary-gradient-start hover:text-primary-gradient-end' 
                      : 'text-primary hover:underline'
                  }`}
                >
                  {locale === 'en' ? 'Try again' : 'Réessayer'}
                </button>
              </div>
            </motion.div>
          </>
        )}
      </div>
    </div>
  )
}