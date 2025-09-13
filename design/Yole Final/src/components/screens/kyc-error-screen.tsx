import { AlertTriangle, RefreshCw } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Button } from '../ui/button'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'

interface KYCErrorScreenProps {
  errorType?: 'document' | 'selfie' | 'general'
  onRetry?: () => void
}

export function KYCErrorScreen({ errorType = 'general', onRetry }: KYCErrorScreenProps) {
  const { locale, setCurrentView, theme } = useAppContext()
  const isDark = theme === 'dark'

  const handleRetry = () => {
    if (onRetry) {
      onRetry()
    } else {
      // Default retry behavior - go back to appropriate step
      switch (errorType) {
        case 'document':
          setCurrentView('kyc-id-capture')
          break
        case 'selfie':
          setCurrentView('kyc-selfie')
          break
        default:
          setCurrentView('kyc-phone')
          break
      }
    }
  }

  const handleContactSupport = () => {
    // In a real app, this would open support chat or email
    console.log('Contact support')
  }

  const getErrorContent = () => {
    switch (errorType) {
      case 'document':
        return {
          title: locale === 'en' ? 'Document verification failed' : 'Échec de la vérification du document',
          subtitle: locale === 'en' 
            ? 'We couldn\'t verify your ID document. Please try again with a clearer photo.' 
            : 'Nous n\'avons pas pu vérifier votre document d\'identité. Veuillez réessayer avec une photo plus claire.',
          suggestions: [
            locale === 'en' ? 'Ensure all corners of the document are visible' : 'Assurez-vous que tous les coins du document sont visibles',
            locale === 'en' ? 'Take the photo in good lighting' : 'Prenez la photo avec un bon éclairage',
            locale === 'en' ? 'Make sure the document is not blurry' : 'Assurez-vous que le document n\'est pas flou',
            locale === 'en' ? 'Check that the document is not expired' : 'Vérifiez que le document n\'est pas expiré'
          ]
        }
      case 'selfie':
        return {
          title: locale === 'en' ? 'Selfie verification failed' : 'Échec de la vérification du selfie',
          subtitle: locale === 'en' 
            ? 'We couldn\'t match your selfie with your ID. Please try again.' 
            : 'Nous n\'avons pas pu faire correspondre votre selfie avec votre pièce d\'identité. Veuillez réessayer.',
          suggestions: [
            locale === 'en' ? 'Look directly at the camera' : 'Regardez directement la caméra',
            locale === 'en' ? 'Remove glasses, hats, or face coverings' : 'Retirez les lunettes, chapeaux ou masques',
            locale === 'en' ? 'Ensure your face is well-lit and centered' : 'Assurez-vous que votre visage est bien éclairé et centré',
            locale === 'en' ? 'Make sure you match the person in your ID' : 'Assurez-vous de correspondre à la personne sur votre pièce d\'identité'
          ]
        }
      default:
        return {
          title: locale === 'en' ? 'Verification failed' : 'Échec de la vérification',
          subtitle: locale === 'en' 
            ? 'We couldn\'t verify your details. Please try again.' 
            : 'Nous n\'avons pas pu vérifier vos informations. Veuillez réessayer.',
          suggestions: [
            locale === 'en' ? 'Check your internet connection' : 'Vérifiez votre connexion internet',
            locale === 'en' ? 'Ensure all information is accurate' : 'Assurez-vous que toutes les informations sont exactes',
            locale === 'en' ? 'Try again in a few minutes' : 'Réessayez dans quelques minutes'
          ]
        }
    }
  }

  const errorContent = getErrorContent()

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d]' 
        : 'bg-gradient-to-b from-red-50 to-orange-50'
    }`}>
      {/* Content */}
      <div className="min-h-full flex flex-col px-6 py-8">
        
        {/* Top Section - Logo */}
        <motion.div 
          className="text-center pt-8"
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          <YoleLogo 
            variant={isDark ? 'dark' : 'light'}
            className="h-16 w-auto mx-auto"
          />
        </motion.div>

        {/* Middle Section - Error Content */}
        <motion.div 
          className="flex-1 flex flex-col justify-center text-center"
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.3, duration: 0.8, ease: "easeOut" }}
        >
          {/* Error Icon */}
          <motion.div 
            className={`w-24 h-24 rounded-full flex items-center justify-center mx-auto mb-8 ${
              isDark 
                ? 'bg-destructive/20 border border-destructive/30' 
                : 'bg-destructive/10 border border-destructive/20'
            }`}
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.6, duration: 0.6, type: "spring", bounce: 0.4 }}
          >
            <AlertTriangle className="h-12 w-12 text-destructive" />
          </motion.div>
          
          {/* Error Content */}
          <motion.div 
            className="space-y-6 max-w-sm mx-auto"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8, duration: 0.6 }}
          >
            <div className="space-y-4">
              <h1 className={`text-2xl font-bold ${
                isDark ? 'text-white' : 'text-foreground'
              }`}>
                {errorContent.title}
              </h1>
              
              <p className={`leading-relaxed ${
                isDark ? 'text-white/70' : 'text-muted-foreground'
              }`}>
                {errorContent.subtitle}
              </p>
            </div>

            {/* Suggestions */}
            <motion.div 
              className={`text-sm space-y-3 ${
                isDark ? 'text-white/60' : 'text-muted-foreground'
              }`}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.0, duration: 0.6 }}
            >
              <p className="font-medium">
                {locale === 'en' ? 'Tips for success:' : 'Conseils pour réussir :'}
              </p>
              <ul className="space-y-2 text-left">
                {errorContent.suggestions.map((suggestion, index) => (
                  <li key={index} className="flex items-start gap-2">
                    <span className="text-destructive mt-0.5">•</span>
                    <span>{suggestion}</span>
                  </li>
                ))}
              </ul>
            </motion.div>
          </motion.div>
        </motion.div>

        {/* Bottom Section - Actions */}
        <motion.div 
          className="space-y-4 pt-8 pb-12"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.2, duration: 0.6 }}
        >
          {/* Retry Button */}
          <GradientButton 
            className="w-full h-12"
            onClick={handleRetry}
          >
            <RefreshCw className="h-5 w-5 mr-2" />
            {locale === 'en' ? 'Retry' : 'Réessayer'}
          </GradientButton>
          
          {/* Contact Support */}
          <Button 
            variant="outline"
            className={`w-full h-12 ${
              isDark 
                ? 'border-white/20 text-white hover:bg-white/5' 
                : ''
            }`}
            onClick={handleContactSupport}
          >
            {locale === 'en' ? 'Contact Support' : 'Contacter le support'}
          </Button>

          {/* Back to Login */}
          <div className="text-center pt-2">
            <button
              onClick={() => setCurrentView('login')}
              className={`text-sm transition-colors ${
                isDark 
                  ? 'text-white/60 hover:text-white/80' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              {locale === 'en' ? 'Back to login' : 'Retour à la connexion'}
            </button>
          </div>
        </motion.div>
      </div>
    </div>
  )
}