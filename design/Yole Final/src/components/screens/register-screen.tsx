import { useState } from 'react'
import { ArrowLeft, Eye, EyeOff, ChevronDown } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'

// Prioritize African countries, then others alphabetically
const countries = [
  { code: 'CD', name: 'Democratic Republic of Congo', flag: '🇨🇩' },
  { code: 'GH', name: 'Ghana', flag: '🇬🇭' },
  { code: 'KE', name: 'Kenya', flag: '🇰🇪' },
  { code: 'NG', name: 'Nigeria', flag: '🇳🇬' },
  { code: 'ZA', name: 'South Africa', flag: '🇿🇦' },
  { code: 'TZ', name: 'Tanzania', flag: '🇹🇿' },
  { code: 'UG', name: 'Uganda', flag: '🇺🇬' },
  { code: 'BE', name: 'Belgium', flag: '🇧🇪' },
  { code: 'CA', name: 'Canada', flag: '🇨🇦' },
  { code: 'FR', name: 'France', flag: '🇫🇷' },
  { code: 'DE', name: 'Germany', flag: '🇩🇪' },
  { code: 'US', name: 'United States', flag: '🇺🇸' },
]

export function RegisterScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const { t } = useTranslation(locale)
  const [showPassword, setShowPassword] = useState(false)
  const [formData, setFormData] = useState({
    email: '',
    firstName: '',
    lastName: '',
    password: '',
    country: ''
  })

  const isDark = theme === 'dark'

  const handleRegister = () => {
    // Navigate to email verification
    setCurrentView('email-verification')
  }

  const updateFormData = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }))
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
          onClick={() => setCurrentView('welcome')}
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
          {locale === 'en' ? 'Create Account' : 'Créer un compte'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Content */}
      <div className="px-6 py-6 sm:py-8 min-h-[calc(100vh-80px)] flex flex-col">
        
        {/* Logo & Welcome */}
        <motion.div 
          className="text-center mb-8 sm:mb-12"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <div className="flex justify-center mb-4 sm:mb-6">
            <YoleLogo 
              variant={isDark ? 'dark' : 'light'}
              className="h-12 sm:h-16 w-auto"
            />
          </div>
          
          <div className="space-y-2">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Join Yole today' : 'Rejoignez Yole aujourd\'hui'}
            </h2>
            <p className={`${
              isDark ? 'text-white/70' : 'text-muted-foreground'
            }`}>
              {locale === 'en' 
                ? 'Create your account to start sending money'
                : 'Créez votre compte pour commencer à envoyer de l\'argent'
              }
            </p>
          </div>
        </motion.div>

        {/* Form */}
        <motion.div 
          className={`w-full max-w-sm mx-auto flex-1 ${
            isDark 
              ? 'bg-white/8 backdrop-blur-medium border border-white/10 rounded-2xl p-6 sm:p-8' 
              : 'p-1 sm:p-2'
          }`}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.6 }}
        >
          <div className="space-y-5 sm:space-y-6">
            {/* Email */}
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

            {/* First Name */}
            <div>
              <Label 
                htmlFor="firstName"
                className={isDark ? 'text-white/90' : ''}
              >
                {t('firstName')}
              </Label>
              <Input
                id="firstName"
                value={formData.firstName}
                onChange={(e) => updateFormData('firstName', e.target.value)}
                placeholder={t('firstName')}
                className={isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50' : ''}
              />
            </div>

            {/* Last Name */}
            <div>
              <Label 
                htmlFor="lastName"
                className={isDark ? 'text-white/90' : ''}
              >
                {t('lastName')}
              </Label>
              <Input
                id="lastName"
                value={formData.lastName}
                onChange={(e) => updateFormData('lastName', e.target.value)}
                placeholder={t('lastName')}
                className={isDark ? 'bg-white/5 border-white/20 text-white placeholder:text-white/50' : ''}
              />
            </div>

            {/* Password */}
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
                  placeholder={locale === 'en' ? 'Create a password' : 'Créez un mot de passe'}
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

            {/* Country */}
            <div>
              <Label 
                htmlFor="country"
                className={isDark ? 'text-white/90' : ''}
              >
                {locale === 'en' ? 'Country' : 'Pays'}
              </Label>
              <Select value={formData.country} onValueChange={(value) => updateFormData('country', value)}>
                <SelectTrigger className={isDark ? 'bg-white/5 border-white/20 text-white' : ''}>
                  <SelectValue placeholder={locale === 'en' ? 'Select your country' : 'Sélectionnez votre pays'} />
                </SelectTrigger>
                <SelectContent>
                  {countries.map((country) => (
                    <SelectItem key={country.code} value={country.code}>
                      <span className="flex items-center gap-2">
                        <span>{country.flag}</span>
                        <span>{country.name}</span>
                      </span>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Create Account Button */}
          <div className="pt-6 sm:pt-8">
            <GradientButton 
              className="w-full h-12 touch-target"
              onClick={handleRegister}
            >
              {locale === 'en' ? 'Create account' : 'Créer un compte'}
            </GradientButton>
          </div>
        </motion.div>

        {/* Sign In Link */}
        <motion.div 
          className="text-center mt-6 sm:mt-10 pb-4 sm:pb-6"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4, duration: 0.6 }}
        >
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
        </motion.div>
      </div>
    </div>
  )
}