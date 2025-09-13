import { useState } from 'react'
import { ArrowLeft, Camera, Check } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Card } from '../ui/card'
import { StatusChip } from '../ui/status-chip'
import { useAppContext } from '../../lib/app-context'

export function KYCSelfieScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [selfieCaptured, setSelfieCaptured] = useState(false)
  const [isCapturing, setIsCapturing] = useState(false)
  
  const isDark = theme === 'dark'

  const handleCaptureSelfie = () => {
    setIsCapturing(true)
    
    // Simulate selfie capture
    setTimeout(() => {
      setIsCapturing(false)
      setSelfieCaptured(true)
    }, 2000)
  }

  const handleContinue = () => {
    setCurrentView('kyc-success')
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
          onClick={() => setCurrentView('kyc-id-capture')}
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
          {locale === 'en' ? 'Selfie Verification' : 'Vérification par selfie'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className={`text-sm ${
            isDark ? 'text-white/70' : 'text-muted-foreground'
          }`}>
            {locale === 'en' ? 'Step 4 of 4' : 'Étape 4 sur 4'}
          </span>
          <span className={`text-sm font-medium ${
            isDark ? 'text-white' : 'text-foreground'
          }`}>100%</span>
        </div>
        <div className={`w-full rounded-full h-2 ${
          isDark ? 'bg-white/10' : 'bg-muted'
        }`}>
          <div 
            className="bg-gradient-primary h-2 rounded-full transition-all duration-300"
            style={{ width: '100%' }}
          />
        </div>
      </div>

      {/* Content */}
      <div className="px-6 py-8 min-h-full flex flex-col">
        
        {/* Top Section - Content */}
        <motion.div 
          className="text-center flex-1 flex flex-col justify-center"
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8, ease: "easeOut" }}
        >
          {/* Header */}
          <div className="space-y-4 max-w-sm mx-auto mb-8">
            <h2 className={`text-2xl font-bold ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Take a selfie' : 'Prenez un selfie'}
            </h2>
            
            <p className={`leading-relaxed ${
              isDark ? 'text-white/70' : 'text-muted-foreground'
            }`}>
              {locale === 'en' 
                ? 'Take a selfie so we can verify it\'s you.'
                : 'Prenez un selfie pour que nous puissions vérifier que c\'est vous.'
              }
            </p>
          </div>

          {/* Selfie Capture Interface */}
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3, duration: 0.6 }}
          >
            <Card className={`p-8 max-w-sm mx-auto ${
              isDark 
                ? 'bg-white/5 border-white/10' 
                : ''
            }`}>
              <div className="text-center space-y-6">
                {selfieCaptured ? (
                  /* Success State */
                  <div className="space-y-4">
                    <div className={`w-24 h-24 rounded-full flex items-center justify-center mx-auto ${
                      isDark 
                        ? 'bg-success/20 border border-success/30' 
                        : 'bg-success/10'
                    }`}>
                      <Check className="h-12 w-12 text-success" />
                    </div>
                    <p className="text-success font-medium">
                      {locale === 'en' ? 'Selfie captured successfully!' : 'Selfie capturé avec succès !'}
                    </p>
                    <StatusChip variant="success">
                      {locale === 'en' ? 'Verified' : 'Vérifié'}
                    </StatusChip>
                  </div>
                ) : (
                  /* Capture Interface */
                  <div className="space-y-6">
                    {/* Camera Preview Area */}
                    <div className={`w-48 h-48 rounded-3xl border-4 border-dashed flex items-center justify-center mx-auto ${
                      isDark 
                        ? 'border-white/20 bg-white/5' 
                        : 'border-border bg-muted/30'
                    }`}>
                      {isCapturing ? (
                        <div className="text-center space-y-2">
                          <div className={`w-16 h-16 rounded-full border-4 border-t-primary animate-spin mx-auto ${
                            isDark ? 'border-white/20' : 'border-muted'
                          }`} />
                          <p className={`text-sm ${
                            isDark ? 'text-white/70' : 'text-muted-foreground'
                          }`}>
                            {locale === 'en' ? 'Capturing...' : 'Capture...'}
                          </p>
                        </div>
                      ) : (
                        <div className="text-center space-y-3">
                          <Camera className={`h-16 w-16 mx-auto ${
                            isDark ? 'text-white/40' : 'text-muted-foreground'
                          }`} />
                          <p className={`text-sm ${
                            isDark ? 'text-white/60' : 'text-muted-foreground'
                          }`}>
                            {locale === 'en' ? 'Position your face in the frame' : 'Positionnez votre visage dans le cadre'}
                          </p>
                        </div>
                      )}
                    </div>

                    {/* Capture Button */}
                    {!isCapturing && (
                      <GradientButton 
                        className="w-full"
                        onClick={handleCaptureSelfie}
                      >
                        <Camera className="h-5 w-5 mr-2" />
                        {locale === 'en' ? 'Take Selfie' : 'Prendre un selfie'}
                      </GradientButton>
                    )}
                  </div>
                )}
              </div>
            </Card>
          </motion.div>

          {/* Instructions */}
          {!selfieCaptured && (
            <motion.div 
              className={`text-xs space-y-2 mt-6 max-w-sm mx-auto ${
                isDark ? 'text-white/60' : 'text-muted-foreground'
              }`}
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.5, duration: 0.6 }}
            >
              <p className="font-medium">
                {locale === 'en' ? 'For best results:' : 'Pour de meilleurs résultats :'}
              </p>
              <ul className="space-y-1 ml-4 text-left">
                <li>• {locale === 'en' ? 'Look directly at the camera' : 'Regardez directement la caméra'}</li>
                <li>• {locale === 'en' ? 'Remove glasses and hats' : 'Retirez les lunettes et chapeaux'}</li>
                <li>• {locale === 'en' ? 'Ensure good lighting' : 'Assurez-vous d\'un bon éclairage'}</li>
                <li>• {locale === 'en' ? 'Keep your face centered' : 'Gardez votre visage centré'}</li>
              </ul>
            </motion.div>
          )}
        </motion.div>

        {/* Bottom Section - Continue Button */}
        {selfieCaptured && (
          <motion.div 
            className="pt-8"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.6, duration: 0.6 }}
          >
            <GradientButton 
              className="w-full h-12"
              onClick={handleContinue}
            >
              {locale === 'en' ? 'Complete Verification' : 'Terminer la vérification'}
            </GradientButton>
          </motion.div>
        )}
      </div>
    </div>
  )
}