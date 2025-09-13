import { useState } from 'react'
import { ArrowLeft, Upload, Camera, Check, AlertTriangle } from 'lucide-react'
import { GradientButton } from '../ui/gradient-button'
import { Progress } from '../ui/progress'
import { Card } from '../ui/card'
import { StatusChip } from '../ui/status-chip'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'

export function KYCScreen() {
  const { locale, setCurrentView, setIsAuthenticated } = useAppContext()
  const { t } = useTranslation(locale)
  const [currentStep, setCurrentStep] = useState(1)
  const [uploadedDocs, setUploadedDocs] = useState({
    idDocument: false,
    selfie: false
  })

  const totalSteps = 3
  const progress = (currentStep / totalSteps) * 100

  const handleNext = () => {
    if (currentStep < totalSteps) {
      setCurrentStep(currentStep + 1)
    } else {
      // Complete KYC and go to home
      setIsAuthenticated(true)
      setCurrentView('home')
    }
  }

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1)
    } else {
      setCurrentView('signup')
    }
  }

  const handleDocumentUpload = (type: 'idDocument' | 'selfie') => {
    // Mock file upload
    setUploadedDocs(prev => ({ ...prev, [type]: true }))
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
        <h1 className="font-semibold">{t('kycVerification')}</h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className="text-sm text-muted-foreground">
            {locale === 'en' ? `Step ${currentStep} of ${totalSteps}` : `Étape ${currentStep} sur ${totalSteps}`}
          </span>
          <span className="text-sm font-medium">{Math.round(progress)}%</span>
        </div>
        <Progress value={progress} className="h-2" />
      </div>

      {/* Content */}
      <div className="px-4 pb-20">
        {currentStep === 1 && (
          <div className="space-y-6">
            <div className="text-center space-y-2 mb-8">
              <div className="w-16 h-16 bg-gradient-primary rounded-full flex items-center justify-center mx-auto mb-4">
                <AlertTriangle className="h-8 w-8 text-white" />
              </div>
              <h2 className="text-xl font-semibold">{t('identityVerification')}</h2>
              <p className="text-muted-foreground">
                {locale === 'en' 
                  ? 'We need to verify your identity to comply with regulations and keep your money safe.'
                  : 'Nous devons vérifier votre identité pour nous conformer à la réglementation et protéger votre argent.'
                }
              </p>
            </div>

            <Card className="p-4">
              <h3 className="font-semibold mb-3">
                {locale === 'en' ? 'What you\'ll need:' : 'Ce dont vous aurez besoin :'}
              </h3>
              <div className="space-y-3">
                {[
                  locale === 'en' ? 'Government-issued ID (passport, driver\'s license)' : 'Pièce d\'identité officielle (passeport, permis de conduire)',
                  locale === 'en' ? 'Clear photo of your face' : 'Photo claire de votre visage',
                  locale === 'en' ? '2-3 minutes of your time' : '2-3 minutes de votre temps'
                ].map((item, index) => (
                  <div key={index} className="flex items-center space-x-3">
                    <Check className="h-5 w-5 text-success" />
                    <span className="text-sm">{item}</span>
                  </div>
                ))}
              </div>
            </Card>
          </div>
        )}

        {currentStep === 2 && (
          <div className="space-y-6">
            <div className="text-center space-y-2 mb-8">
              <h2 className="text-xl font-semibold">{t('documentUpload')}</h2>
              <p className="text-muted-foreground">
                {locale === 'en' 
                  ? 'Upload a clear photo of your government ID'
                  : 'Téléchargez une photo claire de votre pièce d\'identité'
                }
              </p>
            </div>

            <Card className="p-6">
              <div className="text-center space-y-4">
                {uploadedDocs.idDocument ? (
                  <div className="space-y-4">
                    <div className="w-16 h-16 bg-success/10 rounded-full flex items-center justify-center mx-auto">
                      <Check className="h-8 w-8 text-success" />
                    </div>
                    <p className="text-success font-medium">
                      {locale === 'en' ? 'Document uploaded successfully!' : 'Document téléchargé avec succès !'}
                    </p>
                    <StatusChip variant="success">
                      {locale === 'en' ? 'Verified' : 'Vérifié'}
                    </StatusChip>
                  </div>
                ) : (
                  <div className="space-y-4">
                    <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto">
                      <Upload className="h-8 w-8 text-muted-foreground" />
                    </div>
                    <div className="space-y-2">
                      <GradientButton 
                        className="w-full"
                        onClick={() => handleDocumentUpload('idDocument')}
                      >
                        <Camera className="h-5 w-5 mr-2" />
                        {locale === 'en' ? 'Take Photo' : 'Prendre une photo'}
                      </GradientButton>
                      <GradientButton 
                        variant="outline"
                        className="w-full"
                        onClick={() => handleDocumentUpload('idDocument')}
                      >
                        <Upload className="h-5 w-5 mr-2" />
                        {locale === 'en' ? 'Upload from Gallery' : 'Télécharger depuis la galerie'}
                      </GradientButton>
                    </div>
                  </div>
                )}
              </div>
            </Card>

            {/* Requirements */}
            <div className="text-xs text-muted-foreground space-y-1">
              <p className="font-medium">
                {locale === 'en' ? 'Make sure your document:' : 'Assurez-vous que votre document :'}
              </p>
              <ul className="space-y-1 ml-4">
                <li>• {locale === 'en' ? 'Is clearly visible and not blurry' : 'Est clairement visible et pas flou'}</li>
                <li>• {locale === 'en' ? 'Shows all four corners' : 'Montre les quatre coins'}</li>
                <li>• {locale === 'en' ? 'Is not expired' : 'N\'est pas expiré'}</li>
              </ul>
            </div>
          </div>
        )}

        {currentStep === 3 && (
          <div className="space-y-6">
            <div className="text-center space-y-2 mb-8">
              <h2 className="text-xl font-semibold">{t('selfieVerification')}</h2>
              <p className="text-muted-foreground">
                {locale === 'en' 
                  ? 'Take a selfie to complete verification'
                  : 'Prenez un selfie pour terminer la vérification'
                }
              </p>
            </div>

            <Card className="p-6">
              <div className="text-center space-y-4">
                {uploadedDocs.selfie ? (
                  <div className="space-y-4">
                    <div className="w-16 h-16 bg-success/10 rounded-full flex items-center justify-center mx-auto">
                      <Check className="h-8 w-8 text-success" />
                    </div>
                    <p className="text-success font-medium">
                      {locale === 'en' ? 'Selfie captured successfully!' : 'Selfie capturé avec succès !'}
                    </p>
                    <StatusChip variant="success">
                      {locale === 'en' ? 'Verified' : 'Vérifié'}
                    </StatusChip>
                  </div>
                ) : (
                  <div className="space-y-4">
                    <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto">
                      <Camera className="h-12 w-12 text-muted-foreground" />
                    </div>
                    <GradientButton 
                      className="w-full"
                      onClick={() => handleDocumentUpload('selfie')}
                    >
                      <Camera className="h-5 w-5 mr-2" />
                      {locale === 'en' ? 'Take Selfie' : 'Prendre un selfie'}
                    </GradientButton>
                  </div>
                )}
              </div>
            </Card>

            {/* Instructions */}
            <div className="text-xs text-muted-foreground space-y-1">
              <p className="font-medium">
                {locale === 'en' ? 'For best results:' : 'Pour de meilleurs résultats :'}
              </p>
              <ul className="space-y-1 ml-4">
                <li>• {locale === 'en' ? 'Look directly at the camera' : 'Regardez directement la caméra'}</li>
                <li>• {locale === 'en' ? 'Remove glasses and hats' : 'Retirez les lunettes et chapeaux'}</li>
                <li>• {locale === 'en' ? 'Ensure good lighting' : 'Assurez-vous d\'un bon éclairage'}</li>
              </ul>
            </div>
          </div>
        )}

        {/* Continue Button */}
        <div className="fixed bottom-6 left-4 right-4">
          <GradientButton 
            className="w-full"
            onClick={handleNext}
            disabled={currentStep === 2 && !uploadedDocs.idDocument || currentStep === 3 && !uploadedDocs.selfie}
          >
            {currentStep === totalSteps ? t('done') : t('continue')}
          </GradientButton>
        </div>
      </div>
    </div>
  )
}