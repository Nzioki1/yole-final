import { useState, useRef, useEffect } from 'react'
import { ArrowLeft, MessageSquare, Clock } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { useAppContext } from '../../lib/app-context'

export function KYCOTPScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [otp, setOtp] = useState(['', '', '', '', '', ''])
  const [isVerifying, setIsVerifying] = useState(false)
  const [countdown, setCountdown] = useState(60)
  const [canResend, setCanResend] = useState(false)
  const inputRefs = useRef<(HTMLInputElement | null)[]>([])
  
  const isDark = theme === 'dark'
  const phoneNumber = '+1 (555) 123-4567' // Mock phone number

  useEffect(() => {
    // Countdown timer for resend
    const timer = setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          setCanResend(true)
          clearInterval(timer)
          return 0
        }
        return prev - 1
      })
    }, 1000)

    return () => clearInterval(timer)
  }, [])

  const handleOtpChange = (index: number, value: string) => {
    if (value.length > 1) return // Prevent multiple characters
    
    const newOtp = [...otp]
    newOtp[index] = value
    setOtp(newOtp)

    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus()
    }
  }

  const handleKeyDown = (index: number, e: React.KeyboardEvent) => {
    // Handle backspace
    if (e.key === 'Backspace' && !otp[index] && index > 0) {
      inputRefs.current[index - 1]?.focus()
    }
  }

  const handleVerifyOTP = () => {
    setIsVerifying(true)
    
    // Simulate verification
    setTimeout(() => {
      setIsVerifying(false)
      setCurrentView('kyc-id-capture')
    }, 2000)
  }

  const handleResendOTP = () => {
    setCountdown(60)
    setCanResend(false)
    // Reset timer
    const timer = setInterval(() => {
      setCountdown((prev) => {
        if (prev <= 1) {
          setCanResend(true)
          clearInterval(timer)
          return 0
        }
        return prev - 1
      })
    }, 1000)
  }

  const isOtpComplete = otp.every(digit => digit !== '')

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d]' 
        : 'bg-background'
    }`}>
      {/* Header */}
      <div className={`flex items-center justify-between p-4 ${
        isDark ? 'border-b border-white/10' : 'border-b border-border'
      }`}>
        <button
          onClick={() => setCurrentView('kyc-phone')}
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
          {locale === 'en' ? 'Enter Verification Code' : 'Entrez le code de vérification'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className={`text-sm ${
            isDark ? 'text-white/70' : 'text-muted-foreground'
          }`}>
            {locale === 'en' ? 'Step 2 of 4' : 'Étape 2 sur 4'}
          </span>
          <span className={`text-sm font-medium ${
            isDark ? 'text-white' : 'text-foreground'
          }`}>50%</span>
        </div>
        <div className={`w-full rounded-full h-2 ${
          isDark ? 'bg-white/10' : 'bg-muted'
        }`}>
          <div 
            className="bg-gradient-primary h-2 rounded-full transition-all duration-300"
            style={{ width: '50%' }}
          />
        </div>
      </div>

      {/* Content */}
      <div className="px-6 py-8 min-h-full flex flex-col">
        
        {/* Top Section - Icon & Content */}
        <motion.div 
          className="text-center flex-1 flex flex-col justify-center"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          {/* Message Icon */}
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
            <MessageSquare className={`h-10 w-10 ${
              isDark ? 'text-white' : 'text-white'
            }`} />
          </motion.div>
          
          {/* Content */}
          <div className="space-y-4 max-w-sm mx-auto mb-8">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Enter the 6-digit code' : 'Entrez le code à 6 chiffres'}
            </h2>
            
            <div className="space-y-2">
              <p className={`leading-relaxed ${
                isDark ? 'text-white/70' : 'text-muted-foreground'
              }`}>
                {locale === 'en' 
                  ? `Enter the 6-digit code we sent to ${phoneNumber}.`
                  : `Entrez le code à 6 chiffres que nous avons envoyé au ${phoneNumber}.`
                }
              </p>
            </div>
          </div>

          {/* OTP Input */}
          <motion.div 
            className="flex justify-center gap-3 mb-8"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            {otp.map((digit, index) => (
              <input
                key={index}
                ref={(el) => (inputRefs.current[index] = el)}
                type="text"
                inputMode="numeric"
                pattern="[0-9]*"
                maxLength={1}
                value={digit}
                onChange={(e) => handleOtpChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                className={`w-12 h-12 text-center text-xl font-semibold rounded-xl border-2 transition-all duration-200 focus:outline-none focus:ring-0 ${
                  isDark 
                    ? 'bg-white/5 border-white/20 text-white focus:border-primary-gradient-start' 
                    : 'bg-white border-border text-foreground focus:border-primary'
                } ${digit ? 'border-primary' : ''}`}
              />
            ))}
          </motion.div>

          {/* Resend section */}
          <motion.div 
            className="text-center space-y-2"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.6, duration: 0.6 }}
          >
            <p className={`text-sm ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}>
              {locale === 'en' ? 'Didn\'t receive the code?' : 'Vous n\'avez pas reçu le code ?'}
            </p>
            
            <button
              onClick={handleResendOTP}
              disabled={!canResend}
              className={`text-sm font-medium transition-colors disabled:opacity-50 ${
                isDark 
                  ? 'text-primary-gradient-start hover:text-primary-gradient-end disabled:text-white/30' 
                  : 'text-primary hover:underline disabled:text-muted-foreground'
              }`}
            >
              {canResend ? (
                locale === 'en' ? 'Resend' : 'Renvoyer'
              ) : (
                <span className="flex items-center justify-center gap-1">
                  <Clock className="h-3 w-3" />
                  {`${countdown}s`}
                </span>
              )}
            </button>
          </motion.div>
        </motion.div>

        {/* Bottom Section - Actions */}
        <motion.div 
          className="pt-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8, duration: 0.6 }}
        >
          <GradientButton 
            className="w-full h-12"
            onClick={handleVerifyOTP}
            disabled={!isOtpComplete || isVerifying}
          >
            {isVerifying 
              ? (locale === 'en' ? 'Verifying...' : 'Vérification...') 
              : (locale === 'en' ? 'Verify code' : 'Vérifier le code')
            }
          </GradientButton>
        </motion.div>
      </div>
    </div>
  )
}