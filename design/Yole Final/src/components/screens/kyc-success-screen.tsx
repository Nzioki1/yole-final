import { CheckCircle, Sparkles } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { useAppContext } from '../../lib/app-context'
import { YoleLogo } from '../ui/yole-logo'
import { mockUser } from '../../lib/mock-data'

export function KYCSuccessScreen() {
  const { locale, setCurrentView, setUser, setIsAuthenticated, theme } = useAppContext()
  const isDark = theme === 'dark'

  const handleContinue = () => {
    // Set user as authenticated and navigate to home
    setUser(mockUser)
    setIsAuthenticated(true)
    setCurrentView('home')
  }

  return (
    <div className={`min-h-screen ${
      isDark 
        ? 'bg-gradient-to-b from-[#0B0F19] to-[#19173d] relative overflow-hidden' 
        : 'bg-gradient-to-b from-green-50 to-blue-50'
    }`}>
      {/* Animated background elements */}
      {isDark && (
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          {Array.from({ length: 8 }).map((_, i) => (
            <motion.div
              key={i}
              className="absolute w-2 h-2 bg-white rounded-full"
              style={{
                left: `${Math.random() * 100}%`,
                top: `${Math.random() * 100}%`,
              }}
              animate={{
                opacity: [0.2, 0.8, 0.2],
                scale: [1, 1.5, 1],
                y: [0, -20, 0],
              }}
              transition={{
                duration: 3,
                delay: i * 0.5,
                repeat: Infinity,
                ease: "easeInOut"
              }}
            />
          ))}
        </div>
      )}

      {/* Content */}
      <div className="relative z-10 min-h-full flex flex-col px-6 py-8">
        
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

        {/* Middle Section - Success Content */}
        <motion.div 
          className="flex-1 flex flex-col justify-center text-center"
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.3, duration: 0.8, ease: "easeOut" }}
        >
          {/* Success Icon with Animation */}
          <motion.div 
            className="relative mb-8"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.6, duration: 0.6, type: "spring", bounce: 0.4 }}
          >
            {/* Outer glow ring */}
            <motion.div 
              className={`w-32 h-32 rounded-full absolute inset-0 mx-auto ${
                isDark 
                  ? 'bg-success/20 border border-success/30' 
                  : 'bg-success/10 border border-success/20'
              }`}
              animate={{
                scale: [1, 1.1, 1],
                opacity: [0.7, 1, 0.7]
              }}
              transition={{
                duration: 2,
                repeat: Infinity,
                ease: "easeInOut"
              }}
            />
            
            {/* Main success icon */}
            <div className={`w-32 h-32 rounded-full flex items-center justify-center mx-auto relative ${
              isDark 
                ? 'bg-success/30 border-2 border-success/50' 
                : 'bg-success text-white'
            }`}>
              <CheckCircle className="h-16 w-16 text-white drop-shadow-lg" />
              
              {/* Sparkle effects */}
              <motion.div
                className="absolute -top-2 -right-2"
                animate={{ rotate: 360 }}
                transition={{ duration: 4, repeat: Infinity, ease: "linear" }}
              >
                <Sparkles className={`h-8 w-8 ${
                  isDark ? 'text-white/60' : 'text-yellow-400'
                }`} />
              </motion.div>
              <motion.div
                className="absolute -bottom-2 -left-2"
                animate={{ rotate: -360 }}
                transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
              >
                <Sparkles className={`h-6 w-6 ${
                  isDark ? 'text-white/40' : 'text-yellow-300'
                }`} />
              </motion.div>
            </div>
          </motion.div>
          
          {/* Success Content */}
          <motion.div 
            className="space-y-6 max-w-sm mx-auto"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.8, duration: 0.6 }}
          >
            <div className="space-y-4">
              <h1 className={`text-3xl font-bold ${
                isDark ? 'text-white' : 'text-foreground'
              }`}>
                {locale === 'en' ? 'Verification successful' : 'Vérification réussie'}
              </h1>
              
              <p className={`text-lg leading-relaxed ${
                isDark ? 'text-white/70' : 'text-muted-foreground'
              }`}>
                {locale === 'en' 
                  ? 'You\'re all set to start using your account.'
                  : 'Vous êtes prêt à commencer à utiliser votre compte.'
                }
              </p>
            </div>

            {/* Benefits/Features */}
            <motion.div 
              className={`text-sm space-y-2 ${
                isDark ? 'text-white/60' : 'text-muted-foreground'
              }`}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 1.2, duration: 0.6 }}
            >
              <p className="font-medium">
                {locale === 'en' ? 'You can now:' : 'Vous pouvez maintenant :'}
              </p>
              <ul className="space-y-1">
                <li>✓ {locale === 'en' ? 'Send money to DRC' : 'Envoyer de l\'argent en RDC'}</li>
                <li>✓ {locale === 'en' ? 'Track your transactions' : 'Suivre vos transactions'}</li>
                <li>✓ {locale === 'en' ? 'Manage your favorites' : 'Gérer vos favoris'}</li>
                <li>✓ {locale === 'en' ? 'Access your account securely' : 'Accéder à votre compte en toute sécurité'}</li>
              </ul>
            </motion.div>
          </motion.div>
        </motion.div>

        {/* Bottom Section - CTA */}
        <motion.div 
          className="pt-8 pb-12"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.0, duration: 0.6 }}
        >
          <GradientButton 
            className="w-full h-14 text-lg font-semibold shadow-lg hover:shadow-xl"
            onClick={handleContinue}
          >
            {locale === 'en' ? 'Continue' : 'Continuer'}
          </GradientButton>
          
          {/* Welcome message */}
          <motion.p 
            className={`text-center mt-4 text-sm ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.4, duration: 0.6 }}
          >
            {locale === 'en' 
              ? 'Welcome to Yole! 🎉' 
              : 'Bienvenue chez Yole ! 🎉'
            }
          </motion.p>
        </motion.div>
      </div>
    </div>
  )
}