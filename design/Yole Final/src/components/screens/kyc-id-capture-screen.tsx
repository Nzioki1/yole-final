import { useState } from 'react'
import { ArrowLeft, CreditCard, Camera, Upload, Check, FileText } from 'lucide-react'
import { motion } from 'motion/react'
import { GradientButton } from '../ui/gradient-button'
import { Card } from '../ui/card'
import { StatusChip } from '../ui/status-chip'
import { useAppContext } from '../../lib/app-context'

type DocumentType = 'national-id' | 'passport' | null

export function KYCIdCaptureScreen() {
  const { locale, setCurrentView, theme } = useAppContext()
  const [selectedDocType, setSelectedDocType] = useState<DocumentType>(null)
  const [uploadedSides, setUploadedSides] = useState({
    front: false,
    back: false
  })
  
  const isDark = theme === 'dark'

  const handleDocumentTypeSelect = (type: DocumentType) => {
    setSelectedDocType(type)
    setUploadedSides({ front: false, back: false })
  }

  const handleDocumentUpload = (side: 'front' | 'back') => {
    // Mock file upload
    setUploadedSides(prev => ({ ...prev, [side]: true }))
  }

  const handleContinue = () => {
    setCurrentView('kyc-selfie')
  }

  const isComplete = selectedDocType && uploadedSides.front && (selectedDocType === 'passport' || uploadedSides.back)

  const documentTypes = [
    {
      id: 'national-id' as const,
      icon: CreditCard,
      title: locale === 'en' ? 'National ID' : 'Carte d\'identité nationale',
      subtitle: locale === 'en' ? 'Government-issued ID card' : 'Carte d\'identité officielle',
      requiresBothSides: true
    },
    {
      id: 'passport' as const,
      icon: FileText,
      title: locale === 'en' ? 'Passport' : 'Passeport',
      subtitle: locale === 'en' ? 'International passport' : 'Passeport international',
      requiresBothSides: false
    }
  ]

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
          onClick={() => setCurrentView('kyc-otp')}
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
          {locale === 'en' ? 'ID Verification' : 'Vérification d\'identité'}
        </h1>
        <div className="w-10" />
      </div>

      {/* Progress */}
      <div className="p-4">
        <div className="flex items-center justify-between mb-2">
          <span className={`text-sm ${
            isDark ? 'text-white/70' : 'text-muted-foreground'
          }`}>
            {locale === 'en' ? 'Step 3 of 4' : 'Étape 3 sur 4'}
          </span>
          <span className={`text-sm font-medium ${
            isDark ? 'text-white' : 'text-foreground'
          }`}>75%</span>
        </div>
        <div className={`w-full rounded-full h-2 ${
          isDark ? 'bg-white/10' : 'bg-muted'
        }`}>
          <div 
            className="bg-gradient-primary h-2 rounded-full transition-all duration-300"
            style={{ width: '75%' }}
          />
        </div>
      </div>

      {/* Content */}
      <div className="px-6 py-4 pb-24">
        
        {/* Header Content */}
        <motion.div 
          className="text-center mb-8"
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
        >
          <h2 className={`text-2xl font-bold mb-2 ${
            isDark ? 'text-white' : 'text-foreground'
          }`}>
            {locale === 'en' ? 'Upload your ID document' : 'Téléchargez votre document d\'identité'}
          </h2>
          <p className={`${
            isDark ? 'text-white/70' : 'text-muted-foreground'
          }`}>
            {locale === 'en' 
              ? 'Take a clear photo of your ID.'
              : 'Prenez une photo claire de votre pièce d\'identité.'
            }
          </p>
        </motion.div>

        {!selectedDocType ? (
          /* Document Type Selection */
          <motion.div 
            className="space-y-4"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2, duration: 0.6 }}
          >
            <h3 className={`font-semibold mb-4 ${
              isDark ? 'text-white' : 'text-foreground'
            }`}>
              {locale === 'en' ? 'Select document type:' : 'Sélectionnez le type de document :'}
            </h3>
            
            {documentTypes.map((docType) => (
              <Card 
                key={docType.id}
                className={`p-5 cursor-pointer transition-all duration-200 hover:shadow-lg ${
                  isDark 
                    ? 'bg-white/5 border-white/10 hover:bg-white/10' 
                    : 'hover:border-primary/50'
                }`}
                onClick={() => handleDocumentTypeSelect(docType.id)}
              >
                <div className="flex items-center space-x-4">
                  <div className={`w-12 h-12 rounded-2xl flex items-center justify-center ${
                    isDark 
                      ? 'bg-white/10' 
                      : 'bg-primary/10'
                  }`}>
                    <docType.icon className={`h-6 w-6 ${
                      isDark ? 'text-white' : 'text-primary'
                    }`} />
                  </div>
                  <div className="flex-1">
                    <h4 className={`font-semibold ${
                      isDark ? 'text-white' : 'text-foreground'
                    }`}>
                      {docType.title}
                    </h4>
                    <p className={`text-sm ${
                      isDark ? 'text-white/60' : 'text-muted-foreground'
                    }`}>
                      {docType.subtitle}
                    </p>
                  </div>
                  <div className={`w-6 h-6 rounded-full border-2 ${
                    isDark 
                      ? 'border-white/30' 
                      : 'border-border'
                  }`} />
                </div>
              </Card>
            ))}
          </motion.div>
        ) : (
          /* Document Upload Interface */
          <motion.div 
            className="space-y-6"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
          >
            {/* Selected Document Type */}
            <div className="flex items-center space-x-3 mb-6">
              <button
                onClick={() => setSelectedDocType(null)}
                className={`p-2 rounded-lg ${
                  isDark 
                    ? 'text-white/70 hover:text-white hover:bg-white/5' 
                    : 'text-muted-foreground hover:text-foreground hover:bg-muted'
                }`}
              >
                <ArrowLeft className="h-5 w-5" />
              </button>
              <h3 className={`font-semibold ${
                isDark ? 'text-white' : 'text-foreground'
              }`}>
                {documentTypes.find(d => d.id === selectedDocType)?.title}
              </h3>
            </div>

            {/* Front Side Upload */}
            <Card className={`p-6 ${
              isDark 
                ? 'bg-white/5 border-white/10' 
                : ''
            }`}>
              <div className="text-center space-y-4">
                <h4 className={`font-semibold ${
                  isDark ? 'text-white' : 'text-foreground'
                }`}>
                  {locale === 'en' ? 'Front side' : 'Recto'}
                </h4>
                
                {uploadedSides.front ? (
                  <div className="space-y-4">
                    <div className={`w-16 h-16 rounded-full flex items-center justify-center mx-auto ${
                      isDark 
                        ? 'bg-success/20 border border-success/30' 
                        : 'bg-success/10'
                    }`}>
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
                    <div className={`w-16 h-16 rounded-full flex items-center justify-center mx-auto ${
                      isDark 
                        ? 'bg-white/10' 
                        : 'bg-muted'
                    }`}>
                      <Upload className={`h-8 w-8 ${
                        isDark ? 'text-white/70' : 'text-muted-foreground'
                      }`} />
                    </div>
                    <div className="space-y-2">
                      <GradientButton 
                        className="w-full"
                        onClick={() => handleDocumentUpload('front')}
                      >
                        <Camera className="h-5 w-5 mr-2" />
                        {locale === 'en' ? 'Take Photo' : 'Prendre une photo'}
                      </GradientButton>
                      <GradientButton 
                        variant="outline"
                        className="w-full"
                        onClick={() => handleDocumentUpload('front')}
                      >
                        <Upload className="h-5 w-5 mr-2" />
                        {locale === 'en' ? 'Upload from Gallery' : 'Télécharger depuis la galerie'}
                      </GradientButton>
                    </div>
                  </div>
                )}
              </div>
            </Card>

            {/* Back Side Upload (only for National ID) */}
            {selectedDocType === 'national-id' && (
              <Card className={`p-6 ${
                isDark 
                  ? 'bg-white/5 border-white/10' 
                  : ''
              }`}>
                <div className="text-center space-y-4">
                  <h4 className={`font-semibold ${
                    isDark ? 'text-white' : 'text-foreground'
                  }`}>
                    {locale === 'en' ? 'Back side' : 'Verso'}
                  </h4>
                  
                  {uploadedSides.back ? (
                    <div className="space-y-4">
                      <div className={`w-16 h-16 rounded-full flex items-center justify-center mx-auto ${
                        isDark 
                          ? 'bg-success/20 border border-success/30' 
                          : 'bg-success/10'
                      }`}>
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
                      <div className={`w-16 h-16 rounded-full flex items-center justify-center mx-auto ${
                        isDark 
                          ? 'bg-white/10' 
                          : 'bg-muted'
                      }`}>
                        <Upload className={`h-8 w-8 ${
                          isDark ? 'text-white/70' : 'text-muted-foreground'
                        }`} />
                      </div>
                      <div className="space-y-2">
                        <GradientButton 
                          className="w-full"
                          onClick={() => handleDocumentUpload('back')}
                        >
                          <Camera className="h-5 w-5 mr-2" />
                          {locale === 'en' ? 'Take Photo' : 'Prendre une photo'}
                        </GradientButton>
                        <GradientButton 
                          variant="outline"
                          className="w-full"
                          onClick={() => handleDocumentUpload('back')}
                        >
                          <Upload className="h-5 w-5 mr-2" />
                          {locale === 'en' ? 'Upload from Gallery' : 'Télécharger depuis la galerie'}
                        </GradientButton>
                      </div>
                    </div>
                  )}
                </div>
              </Card>
            )}

            {/* Requirements */}
            <div className={`text-xs space-y-2 ${
              isDark ? 'text-white/60' : 'text-muted-foreground'
            }`}>
              <p className="font-medium">
                {locale === 'en' ? 'Make sure your document:' : 'Assurez-vous que votre document :'}
              </p>
              <ul className="space-y-1 ml-4">
                <li>• {locale === 'en' ? 'Is clearly visible and not blurry' : 'Est clairement visible et pas flou'}</li>
                <li>• {locale === 'en' ? 'Shows all four corners' : 'Montre les quatre coins'}</li>
                <li>• {locale === 'en' ? 'Is not expired' : 'N\'est pas expiré'}</li>
                <li>• {locale === 'en' ? 'Has good lighting' : 'A un bon éclairage'}</li>
              </ul>
            </div>
          </motion.div>
        )}

        {/* Continue Button */}
        {selectedDocType && (
          <div className="fixed bottom-6 left-4 right-4 max-w-md mx-auto">
            <GradientButton 
              className="w-full h-12"
              onClick={handleContinue}
              disabled={!isComplete}
            >
              {locale === 'en' ? 'Continue' : 'Continuer'}
            </GradientButton>
          </div>
        )}
      </div>
    </div>
  )
}