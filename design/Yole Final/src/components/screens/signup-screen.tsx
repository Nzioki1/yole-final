import { useState } from 'react'
import { ArrowLeft, Check } from 'lucide-react'
import { GradientButton } from '../ui/gradient-button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { Card } from '../ui/card'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'

export function SignupScreen() {
  const { locale, setCurrentView } = useAppContext()
  const { t } = useTranslation(locale)
  const [currentStep, setCurrentStep] = useState(1)
  const [formData, setFormData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    password: ''
  })

  const totalSteps = 3
  const progress = (currentStep / totalSteps) * 100

  const handleNext = () => {
    if (currentStep < totalSteps) {
      setCurrentStep(currentStep + 1)
    } else {
      // Complete signup
      setCurrentView('kyc')
    }
  }

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1)
    } else {
      setCurrentView('splash')
    }
  }

  const updateFormData = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }))
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="flex items-center justify-between p-4 border-b border-border">
        <button
          onClick={handleBack}
          className="p-2 rounded-lg hover:bg-muted touch-target"
        >
          <ArrowLeft className="h-6 w-6" />
        </button>
        <h1 className="font-semibold">{t('createAccount')}</h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4 border-b border-border">
        <div className="flex items-center justify-between mb-3">
          <span className="text-sm text-muted-foreground">
            {locale === 'en' ? `Step ${currentStep} of ${totalSteps}` : `Étape ${currentStep} sur ${totalSteps}`}
          </span>
          <span className="text-sm font-medium">{Math.round(progress)}%</span>
        </div>
        <div className="w-full bg-muted rounded-full h-2">
          <div 
            className="bg-gradient-primary h-2 rounded-full transition-all duration-300"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>

      {/* Content */}
      <div className="px-4 py-8">
        <Card className="p-6 rounded-2xl shadow-sm">
          {currentStep === 1 && (
            <div className="space-y-6">
              <div className="text-center space-y-2">
                <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">👤</span>
                </div>
                <h2 className="text-xl font-semibold">
                  {locale === 'en' ? 'Personal Information' : 'Informations personnelles'}
                </h2>
                <p className="text-muted-foreground">
                  {locale === 'en' 
                    ? 'Tell us about yourself'
                    : 'Parlez-nous de vous'
                  }
                </p>
              </div>

              <div className="space-y-4">
                <div>
                  <Label htmlFor="firstName">{t('firstName')}</Label>
                  <Input
                    id="firstName"
                    value={formData.firstName}
                    onChange={(e) => updateFormData('firstName', e.target.value)}
                    placeholder={t('firstName')}
                  />
                </div>
                <div>
                  <Label htmlFor="lastName">{t('lastName')}</Label>
                  <Input
                    id="lastName"
                    value={formData.lastName}
                    onChange={(e) => updateFormData('lastName', e.target.value)}
                    placeholder={t('lastName')}
                  />
                </div>
              </div>
            </div>
          )}

          {currentStep === 2 && (
            <div className="space-y-6">
              <div className="text-center space-y-2">
                <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">📧</span>
                </div>
                <h2 className="text-xl font-semibold">
                  {locale === 'en' ? 'Contact Information' : 'Informations de contact'}
                </h2>
                <p className="text-muted-foreground">
                  {locale === 'en' 
                    ? 'How can we reach you?'
                    : 'Comment pouvons-nous vous joindre ?'
                  }
                </p>
              </div>

              <div className="space-y-4">
                <div>
                  <Label htmlFor="email">{t('email')}</Label>
                  <Input
                    id="email"
                    type="email"
                    value={formData.email}
                    onChange={(e) => updateFormData('email', e.target.value)}
                    placeholder="you@example.com"
                  />
                </div>
                <div>
                  <Label htmlFor="phone">{t('phoneNumber')}</Label>
                  <Input
                    id="phone"
                    type="tel"
                    value={formData.phone}
                    onChange={(e) => updateFormData('phone', e.target.value)}
                    placeholder="+1 (555) 123-4567"
                  />
                </div>
              </div>
            </div>
          )}

          {currentStep === 3 && (
            <div className="space-y-6">
              <div className="text-center space-y-2">
                <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
                  <span className="text-2xl text-white">🔒</span>
                </div>
                <h2 className="text-xl font-semibold">
                  {locale === 'en' ? 'Secure Your Account' : 'Sécurisez votre compte'}
                </h2>
                <p className="text-muted-foreground">
                  {locale === 'en' 
                    ? 'Create a strong password'
                    : 'Créez un mot de passe fort'
                  }
                </p>
              </div>

              <div className="space-y-4">
                <div>
                  <Label htmlFor="password">{t('password')}</Label>
                  <Input
                    id="password"
                    type="password"
                    value={formData.password}
                    onChange={(e) => updateFormData('password', e.target.value)}
                    placeholder={locale === 'en' ? 'Enter your password' : 'Entrez votre mot de passe'}
                  />
                </div>

                {/* Password requirements */}
                <div className="space-y-3">
                  <p className="text-sm text-muted-foreground">
                    {locale === 'en' ? 'Password must contain:' : 'Le mot de passe doit contenir :'}
                  </p>
                  <div className="space-y-2">
                    {[
                      { text: locale === 'en' ? 'At least 8 characters' : 'Au moins 8 caractères', met: formData.password.length >= 8 },
                      { text: locale === 'en' ? 'One uppercase letter' : 'Une lettre majuscule', met: /[A-Z]/.test(formData.password) },
                      { text: locale === 'en' ? 'One number' : 'Un chiffre', met: /\d/.test(formData.password) }
                    ].map((req, index) => (
                      <div key={index} className="flex items-center space-x-3">
                        <Check className={`h-4 w-4 ${req.met ? 'text-success' : 'text-muted-foreground'}`} />
                        <span className={`text-sm ${req.met ? 'text-success' : 'text-muted-foreground'}`}>
                          {req.text}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          )}
        </Card>

        {/* Continue Button */}
        <GradientButton 
          className="w-full mt-6 touch-target"
          onClick={handleNext}
        >
          {currentStep === totalSteps ? t('createAccount') : t('continue')}
        </GradientButton>

        {/* Sign In Link */}
        <div className="text-center mt-6">
          <span className="text-muted-foreground text-sm">
            {locale === 'en' ? 'Already have an account? ' : 'Vous avez déjà un compte ? '}
          </span>
          <button
            onClick={() => setCurrentView('login')}
            className="text-primary hover:underline text-sm font-medium"
          >
            {t('logIn')}
          </button>
        </div>
      </div>
    </div>
  )
}