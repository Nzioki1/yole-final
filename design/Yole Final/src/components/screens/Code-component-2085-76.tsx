import { useState } from 'react'
import { ArrowLeft, Phone } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import { useAppContext } from '../../lib/app-context'

const countryCodes = [
  { code: '+1', country: 'US', flag: '🇺🇸', name: 'United States' },
  { code: '+1', country: 'CA', flag: '🇨🇦', name: 'Canada' },
  { code: '+33', country: 'FR', flag: '🇫🇷', name: 'France' },
  { code: '+32', country: 'BE', flag: '🇧🇪', name: 'Belgium' },
  { code: '+49', country: 'DE', flag: '🇩🇪', name: 'Germany' },
  { code: '+243', country: 'CD', flag: '🇨🇩', name: 'DRC' },
]

export function KYCPhoneScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [countryCode, setCountryCode] = useState('+1')
  const [phoneNumber, setPhoneNumber] = useState('')
  const [isLoading, setIsLoading] = useState(false)
  
  const isDark = theme === 'dark'

  const handleSendOTP = () => {
    setIsLoading(true)
    
    // Simulate sending OTP
    setTimeout(() => {
      setIsLoading(false)
      setCurrentView('kyc-otp')
    }, 2000)
  }

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
          onClick={() => setCurrentView('email-verification')}
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
          {locale === 'en' ? 'Phone Verification' : 'Vérification du téléphone'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className={`text-sm ${
            isDark ? 'text-white/70' : 'text-muted-foreground'
          }`}>
            {locale === 'en' ? 'Step 1 of 4' : 'Étape 1 sur 4'}
          </span>
          <span className={`text-sm font-medium ${
            isDark ? 'text-white' : 'text-foreground'
          }`}>25%</span>
        </div>
        <div className={`w-full rounded-full h-2 ${
          isDark ? 'bg-white/10' : 'bg-muted'
        }`}>
          <div 
            className="bg-gradient-primary h-2 rounded-full transition-all duration-300"
            style={{ width: '25%' }}
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
          {/* Phone Icon */}
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
            <Phone className={`h-10 w-10 ${
              isDark ? 'text-white' : 'text-white'
            }`} />
          </motion.div>
          
          {/* Content */}
          <div className="space-y-4 max-w-sm mx-auto mb-8">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Enter your phone number' : 'Entrez votre numéro de téléphone'}
            </h2>
            
            <p className={`leading-relaxed ${
              isDark ? 'text-white/70' : 'text-muted-foreground'
            }`}>
              {locale === 'en' 
                ? 'We\'ll send a verification code to confirm your identity.'
                : 'Nous enverrons un code de vérification pour confirmer votre identité.'
              }
            </p>
          </div>

          {/* Form */}
          <motion.div 
            className={`w-full max-w-sm mx-auto ${
              isDark 
                ? 'bg-white/8 backdrop-blur-medium border border-white/10 rounded-2xl p-6' 
                : 'bg-card border border-border rounded-2xl p-6'
            }`}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4, duration: 0.6 }}
          >
            <div className="space-y-4">
              {/* Country Code Selector */}
              <div>
                <Label 
                  htmlFor="countryCode"
                  className={isDark ? 'text-white/90' : ''}
                >
                  {locale === 'en' ? 'Country' : 'Pays'}
                </Label>
                <Select value={countryCode} onValueChange={setCountryCode}>
                  <SelectTrigger className={isDark ? 'bg-white/5 border-white/20 text-white' : ''}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {countryCodes.map((country, index) => (
                      <SelectItem key={index} value={country.code}>
                        <span className="flex items-center gap-2">
                          <span>{country.flag}</span>
                          <span>{country.name}</span>
                          <span className="text-muted-foreground">({country.code})</span>
                        </span>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Phone Number */}
              <div>
                <Label 
                  htmlFor="phone"
                  className={isDark ? 'text-white/90' : ''}
                >
                  {locale === 'en' ? 'Phone number' : 'Numéro de téléphone'}
                </Label>
                <div className="flex gap-2">
                  <div className={`px-3 py-2 rounded-xl border flex items-center ${
                    isDark 
                      ? 'bg-white/5 border-white/20 text-white' 
                      : 'bg-muted border-border text-foreground'
                  }`}>
                    <span className="text-sm font-medium">{countryCode}</span>
                  </div>
                  <Input
                    id="phone"
                    type="tel"
                    value={phoneNumber}
                    onChange={(e) => setPhoneNumber(e.target.value)}
                    placeholder="123 456 7890"
                    className={`flex-1 ${isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50' : ''}`}
                  />
                </div>
              </div>

              {/* Info */}
              <div className={`text-xs ${
                isDark ? 'text-white/60' : 'text-muted-foreground'
              }`}>
                <p>
                  {locale === 'en' 
                    ? 'Standard message and data rates may apply.'
                    : 'Les tarifs standard de messages et de données peuvent s\'appliquer.'
                  }
                </p>
              </div>
            </div>
          </motion.div>
        </motion.div>

        {/* Bottom Section - Actions */}
        <motion.div 
          className="pt-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6, duration: 0.6 }}
        >
          <GradientButton 
            className="w-full h-12"
            onClick={handleSendOTP}
            disabled={!phoneNumber || isLoading}
          >
            {isLoading 
              ? (locale === 'en' ? 'Sending...' : 'Envoi...') 
              : (locale === 'en' ? 'Send verification code' : 'Envoyer le code de vérification')
            }
          </GradientButton>
        </motion.div>
      </div>
    </div>
  )
}