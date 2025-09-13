import { useState } from 'react'
import { ArrowLeft, Search, Plus, User, Check, Send, ArrowRight, ChevronDown, Contact } from 'lucide-react'
import { Card } from '../ui/card'
import { Button } from '../ui/button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { Avatar, AvatarFallback } from '../ui/avatar'
import { Separator } from '../ui/separator'
import { SuccessAnimation } from '../ui/success-animation'
import { ImageWithFallback } from '../figma/ImageWithFallback'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { mockRecipients, mockExchangeRates, networkInfo } from '../../lib/mock-data'

interface SendFlowProps {
  onBack: () => void
}

type SendStep = 'select-recipient' | 'enter-amount' | 'review-confirm' | 'success'

interface Recipient {
  id: string
  firstName: string
  lastName: string
  phone: string
  network: string
  isFavorite?: boolean
}

interface TransactionData {
  recipient?: Recipient
  sendAmount?: number
  sendCurrency?: 'USD' | 'EUR'
  receiveAmount?: number
  receiveCurrency?: 'CDF'
  fees?: number
  exchangeRate?: number
}

export function SendMoneyFlow({ onBack }: SendFlowProps) {
  const { locale } = useAppContext()
  const { t } = useTranslation(locale)
  const [currentStep, setCurrentStep] = useState<SendStep>('select-recipient')
  const [transactionData, setTransactionData] = useState<TransactionData>({})
  const [searchQuery, setSearchQuery] = useState('')
  const [sendAmount, setSendAmount] = useState('')
  const [sendCurrency, setSendCurrency] = useState<'USD' | 'EUR'>('USD')
  
  const exchangeRate = mockExchangeRates.find(r => r.from === 'USD' && r.to === 'CDF')?.rate || 2593

  // Filter favorites based on search
  const favorites = mockRecipients.filter(recipient => recipient.isFavorite)
  const filteredFavorites = favorites.filter(fav => 
    searchQuery === '' || 
    `${fav.firstName} ${fav.lastName}`.toLowerCase().includes(searchQuery.toLowerCase()) ||
    fav.phone.includes(searchQuery)
  )

  const handleRecipientSelect = (recipient: Recipient) => {
    setTransactionData(prev => ({ ...prev, recipient }))
    setCurrentStep('enter-amount')
  }

  const handleAmountSubmit = (sendAmount: number, sendCurrency: 'USD' | 'EUR') => {
    const receiveAmount = sendCurrency === 'USD' ? sendAmount : sendAmount * 1.1 // Simplified conversion
    const fees = Math.min(Math.max(sendAmount * 0.02, 1), 50)
    
    setTransactionData(prev => ({
      ...prev,
      sendAmount,
      sendCurrency,
      receiveAmount,
      receiveCurrency: 'USD' as 'CDF', // For simplicity, using USD as receive currency
      fees,
      exchangeRate: 1.0
    }))
    setCurrentStep('review-confirm')
  }

  const handleConfirmSend = () => {
    // Here you would typically make an API call to process the transaction
    setCurrentStep('success')
  }

  const renderStepIndicator = () => {
    const steps = ['select-recipient', 'enter-amount', 'review-confirm', 'success']
    const currentStepIndex = steps.indexOf(currentStep)
    const stepLabels = [
      locale === 'en' ? 'Step 1 of 4' : 'Étape 1 sur 4',
      locale === 'en' ? 'Step 2 of 4' : 'Étape 2 sur 4', 
      locale === 'en' ? 'Step 3 of 4' : 'Étape 3 sur 4',
      locale === 'en' ? 'Step 4 of 4' : 'Étape 4 sur 4'
    ]

    return (
      <div className="text-center space-y-3">
        <div className="flex items-center justify-center space-x-2">
          {steps.slice(0, 4).map((step, index) => (
            <div 
              key={step} 
              className={`w-2 h-2 rounded-full transition-colors duration-200 ${
                index <= currentStepIndex 
                  ? 'bg-gradient-to-r from-blue-500 to-purple-600' 
                  : 'bg-neutral-300 dark:bg-neutral-600'
              }`} 
            />
          ))}
        </div>
        <p className="text-xs text-muted-foreground font-medium">
          {stepLabels[currentStepIndex]}
        </p>
      </div>
    )
  }

  // Step 1: Select Recipient
  const renderSelectRecipient = () => {
    const hasSearchResults = searchQuery !== '' && filteredFavorites.length > 0
    const hasNoResults = searchQuery !== '' && filteredFavorites.length === 0
    const isEmpty = favorites.length === 0

    return (
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <h1 className="text-2xl font-semibold text-foreground">
            {locale === 'en' ? 'Send Money' : 'Envoyer de l\'argent'}
          </h1>
        </div>

        {/* Search Bar */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 h-5 w-5 text-muted-foreground" />
          <Input
            placeholder={locale === 'en' ? 'Search favorites or phone number…' : 'Rechercher favoris ou numéro…'}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-12 h-14 rounded-2xl bg-neutral-100 dark:bg-neutral-800 border-0 placeholder:text-gray-500 dark:placeholder:text-gray-300 text-foreground focus:ring-2 focus:ring-primary/20"
          />
        </div>

        {/* Favorites Section */}
        {!isEmpty && (
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-semibold text-foreground">
                {locale === 'en' ? 'Favorites' : 'Favoris'}
              </h3>
              <Button 
                variant="ghost" 
                size="sm" 
                className="text-primary hover:bg-primary/10 rounded-full p-2 touch-target"
              >
                <Plus className="h-5 w-5" />
              </Button>
            </div>

            {/* Favorites List */}
            <div className="space-y-3">
              {(hasSearchResults ? filteredFavorites : favorites).slice(0, 5).map((favorite) => (
                <Card 
                  key={favorite.id}
                  className="p-4 cursor-pointer hover:shadow-lg hover:scale-[1.02] transition-all duration-200 rounded-2xl border border-border bg-card"
                  onClick={() => handleRecipientSelect(favorite)}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-4">
                      {/* Gradient Avatar */}
                      <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-sm">
                        <span className="text-white font-semibold">
                          {favorite.firstName[0]}{favorite.lastName[0]}
                        </span>
                      </div>
                      <div className="text-left">
                        <p className="font-semibold text-foreground">
                          {favorite.firstName} {favorite.lastName}
                        </p>
                        <p className="text-sm text-muted-foreground">
                          {favorite.phone}
                        </p>
                      </div>
                    </div>
                    <ArrowRight className="h-5 w-5 text-muted-foreground" />
                  </div>
                </Card>
              ))}
            </div>

            {hasNoResults && (
              <div className="text-center py-8 space-y-2">
                <p className="text-muted-foreground">
                  {locale === 'en' ? 'No matching recipients found' : 'Aucun destinataire trouvé'}
                </p>
              </div>
            )}
          </div>
        )}

        {/* Pick from Address Book */}
        <Card className="p-4 cursor-pointer hover:shadow-md hover:scale-[1.01] transition-all duration-200 rounded-2xl border-2 border-dashed border-muted-foreground/30 bg-card">
          <div className="flex items-center justify-center space-x-3 text-muted-foreground hover:text-foreground transition-colors">
            <Contact className="h-6 w-6" />
            <span className="font-medium">
              {locale === 'en' ? 'Pick from Address Book' : 'Choisir dans le carnet'}
            </span>
          </div>
        </Card>

        {/* Empty State */}
        {isEmpty && (
          <div className="text-center py-12 space-y-6">
            <div className="flex justify-center">
              <div className="relative w-24 h-24">
                <ImageWithFallback 
                  src="https://images.unsplash.com/photo-1688649721280-bf00b7ba6997?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxlbXB0eSUyMHN0YXRlJTIwbm8lMjBjb250YWN0cyUyMGlsbHVzdHJhdGlvbnxlbnwxfHx8fDE3NTcwOTg0MjJ8MA&ixlib=rb-4.1.0&q=80&w=1080"
                  alt="No recipients"
                  className="w-24 h-24 rounded-2xl object-cover opacity-60"
                />
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="w-12 h-12 bg-gradient-primary rounded-full flex items-center justify-center shadow-lg">
                    <User className="h-6 w-6 text-white" />
                  </div>
                </div>
              </div>
            </div>
            
            <div className="space-y-2">
              <h3 className="font-semibold text-foreground">
                {locale === 'en' ? 'No saved recipients yet' : 'Aucun destinataire sauvegardé'}
              </h3>
              <p className="text-muted-foreground text-sm max-w-xs mx-auto leading-relaxed">
                {locale === 'en' 
                  ? 'Add recipients to send money faster next time'
                  : 'Ajoutez des destinataires pour envoyer de l\'argent plus rapidement'
                }
              </p>
            </div>

            <Button 
              variant="outline"
              className="rounded-2xl h-12 px-6 border-primary text-primary hover:bg-primary hover:text-white transition-all duration-200"
            >
              <Plus className="h-5 w-5 mr-2" />
              {locale === 'en' ? 'Add Recipient' : 'Ajouter destinataire'}
            </Button>
          </div>
        )}
      </div>
    )
  }

  // Step 2: Enter Amount
  const renderEnterAmount = () => {
    const receiveAmount = sendAmount ? 
      (sendCurrency === 'USD' ? 
        parseFloat(sendAmount) : 
        parseFloat(sendAmount) * 1.1 // EUR to USD conversion approximation
      ) : 0
    
    const fees = sendAmount ? Math.min(Math.max(parseFloat(sendAmount) * 0.02, 1), 50) : 0

    return (
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <h1 className="text-2xl font-semibold text-foreground">
            {locale === 'en' ? 'Enter Amount' : 'Entrer le montant'}
          </h1>
        </div>

        {/* Recipient Summary Card */}
        <Card className="p-4 rounded-2xl bg-muted/30 border-border">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-sm">
              <span className="text-white font-semibold text-sm">
                {transactionData.recipient?.firstName?.[0]}{transactionData.recipient?.lastName?.[0]}
              </span>
            </div>
            <div className="text-left">
              <p className="font-semibold text-foreground">
                {transactionData.recipient?.firstName} {transactionData.recipient?.lastName}
              </p>
              <p className="text-sm text-muted-foreground">{transactionData.recipient?.phone}</p>
            </div>
          </div>
        </Card>

        {/* Amount Input Section */}
        <div className="space-y-6">
          {/* You Send */}
          <div className="space-y-3">
            <Label className="text-foreground font-medium">
              {locale === 'en' ? 'You Send' : 'Vous envoyez'}
            </Label>
            <div className="relative">
              <Input
                type="number"
                placeholder="0.00"
                value={sendAmount}
                onChange={(e) => setSendAmount(e.target.value)}
                className="h-16 text-2xl font-bold rounded-2xl pr-24 bg-card border-border text-center tabular-nums text-foreground"
              />
              <div className="absolute right-4 top-1/2 transform -translate-y-1/2">
                <div className="flex items-center space-x-1 bg-muted rounded-full px-3 py-1">
                  <select 
                    value={sendCurrency}
                    onChange={(e) => setSendCurrency(e.target.value as 'USD' | 'EUR')}
                    className="bg-transparent border-none font-semibold text-foreground focus:outline-none cursor-pointer"
                  >
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                  </select>
                  <ChevronDown className="h-4 w-4 text-muted-foreground" />
                </div>
              </div>
            </div>
          </div>

          {/* They Receive */}
          <div className="space-y-3">
            <Label className="text-foreground font-medium">
              {locale === 'en' ? 'They Receive (USD)' : 'Ils reçoivent (USD)'}
            </Label>
            <div className="relative">
              <Input
                type="text"
                value={receiveAmount ? `${receiveAmount.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '$0.00'}
                readOnly
                className="h-16 text-2xl font-bold rounded-2xl bg-muted/50 border-border text-center tabular-nums text-foreground cursor-not-allowed"
              />
            </div>
          </div>
        </div>

        {/* Charges Info Card */}
        {sendAmount && parseFloat(sendAmount) > 0 && (
          <Card className="py-6 px-5 rounded-2xl bg-neutral-100 dark:bg-neutral-800 border border-neutral-200 dark:border-neutral-700">
            <div className="space-y-6">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {locale === 'en' ? 'Exchange Rate' : 'Taux de change'}
                </span>
                <span className="font-bold tabular-nums text-foreground">
                  1 {sendCurrency} = 1.00 USD
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {locale === 'en' ? 'Transfer Fee' : 'Frais de transfert'}
                </span>
                <span className="font-bold tabular-nums text-foreground">
                  {fees.toLocaleString('en-US', { style: 'currency', currency: sendCurrency })}
                </span>
              </div>
            </div>
          </Card>
        )}

        {/* Continue Button */}
        <div className="pt-4">
          <Button
            onClick={() => handleAmountSubmit(parseFloat(sendAmount), sendCurrency)}
            disabled={!sendAmount || parseFloat(sendAmount) <= 0}
            className="w-full h-14 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-semibold shadow-lg hover:shadow-xl touch-target"
          >
            {locale === 'en' ? 'Continue' : 'Continuer'}
          </Button>
        </div>
      </div>
    )
  }

  // Step 3: Review & Confirm
  const renderReviewConfirm = () => {
    const totalDeducted = (transactionData.sendAmount || 0) + (transactionData.fees || 0)
    
    return (
      <div className="space-y-6">
        {/* Header */}
        <div className="text-center space-y-2">
          <h1 className="text-2xl font-semibold text-foreground">
            {locale === 'en' ? 'Review' : 'Vérification'}
          </h1>
        </div>

        {/* Summary Card */}
        <Card className="py-6 px-6 rounded-2xl border border-neutral-200 dark:border-neutral-700 bg-card shadow-sm">
          <div className="space-y-6">
            {/* Recipient Info */}
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-sm">
                <span className="text-white font-semibold">
                  {transactionData.recipient?.firstName?.[0]}{transactionData.recipient?.lastName?.[0]}
                </span>
              </div>
              <div className="text-left">
                <p className="font-semibold text-foreground">
                  {transactionData.recipient?.firstName} {transactionData.recipient?.lastName}
                </p>
                <p className="text-sm text-muted-foreground">{transactionData.recipient?.phone}</p>
              </div>
            </div>

            <Separator className="bg-border" />

            {/* Transaction Details - Stacked Info */}
            <div className="space-y-6">
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {locale === 'en' ? 'Amount Sent' : 'Montant envoyé'}
                </span>
                <span className="font-bold tabular-nums text-foreground">
                  {transactionData.sendAmount?.toLocaleString('en-US', { 
                    style: 'currency', 
                    currency: transactionData.sendCurrency 
                  })}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {locale === 'en' ? 'Transfer Fee' : 'Frais de transfert'}
                </span>
                <span className="font-bold tabular-nums text-foreground">
                  {transactionData.fees?.toLocaleString('en-US', { 
                    style: 'currency', 
                    currency: transactionData.sendCurrency 
                  })}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-sm text-gray-500 dark:text-gray-400">
                  {locale === 'en' ? 'Total Deducted' : 'Total déduit'}
                </span>
                <span className="font-bold text-lg tabular-nums text-foreground">
                  {totalDeducted.toLocaleString('en-US', { 
                    style: 'currency', 
                    currency: transactionData.sendCurrency 
                  })}
                </span>
              </div>

              <Separator className="bg-border" />
              
              <div className="flex justify-between items-center">
                <span className="font-semibold text-foreground">
                  {locale === 'en' ? 'They Receive' : 'Ils reçoivent'}
                </span>
                <span className="font-bold text-xl tabular-nums text-primary">
                  {transactionData.receiveAmount?.toLocaleString('en-US', { 
                    style: 'currency', 
                    currency: 'USD'
                  })}
                </span>
              </div>
            </div>
          </div>
        </Card>

        {/* Action Buttons */}
        <div className="pt-4 space-y-3">
          <Button
            onClick={handleConfirmSend}
            className="w-full h-14 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-semibold shadow-lg hover:shadow-xl touch-target"
          >
            <Check className="h-5 w-5 mr-2" />
            {locale === 'en' ? 'Confirm & Send' : 'Confirmer et envoyer'}
          </Button>
          
          <button 
            onClick={() => setCurrentStep('enter-amount')}
            className="w-full text-center text-muted-foreground hover:text-foreground transition-colors py-3 font-medium"
          >
            {locale === 'en' ? 'Cancel' : 'Annuler'}
          </button>
        </div>
      </div>
    )
  }

  // Step 4: Success Screen  
  const renderSuccess = () => (
    <div className="text-center space-y-8 py-8">
      {/* Success Animation */}
      <div className="flex justify-center mb-8">
        <SuccessAnimation />
      </div>

      {/* Success Message */}
      <div className="space-y-3">
        <h1 className="text-2xl font-bold text-foreground">
          {locale === 'en' ? 'Transfer Successful' : 'Transfert réussi'}
        </h1>
        <p className="text-muted-foreground leading-relaxed max-w-sm mx-auto">
          {locale === 'en' ? 'You sent' : 'Vous avez envoyé'}{' '}
          <span className="font-semibold tabular-nums text-foreground">
            {transactionData.sendAmount?.toLocaleString('en-US', { 
              style: 'currency', 
              currency: transactionData.sendCurrency 
            })}
          </span>{' '}
          {locale === 'en' ? 'to' : 'à'}{' '}
          <span className="font-semibold text-foreground">
            {transactionData.recipient?.firstName} {transactionData.recipient?.lastName}
          </span>
        </p>
      </div>

      {/* Transaction Summary Card */}
      <Card className="py-6 px-5 rounded-2xl bg-gradient-to-br from-green-50 to-blue-50 dark:from-green-950/20 dark:to-blue-950/20 border border-green-200/50 dark:border-green-800/30 max-w-sm mx-auto">
        <div className="space-y-6">
          <div className="flex justify-between items-center">
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {locale === 'en' ? 'Transaction ID' : 'ID de transaction'}
            </span>
            <span className="font-mono font-bold text-foreground">#{Date.now().toString().slice(-6)}</span>
          </div>
          
          <div className="flex justify-between items-center">
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {locale === 'en' ? 'Amount Sent' : 'Montant envoyé'}
            </span>
            <span className="font-bold tabular-nums text-foreground">
              {transactionData.sendAmount?.toLocaleString('en-US', { 
                style: 'currency', 
                currency: transactionData.sendCurrency 
              })}
            </span>
          </div>
          
          <div className="flex justify-between items-center">
            <span className="text-sm text-gray-500 dark:text-gray-400">
              {locale === 'en' ? 'Status' : 'Statut'}
            </span>
            <span className="text-success font-bold">
              {locale === 'en' ? 'Completed' : 'Terminé'}
            </span>
          </div>
        </div>
      </Card>

      {/* Done Button */}
      <div className="pt-4">
        <Button
          onClick={onBack}
          className="w-full max-w-xs h-14 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-semibold shadow-lg hover:shadow-xl touch-target"
        >
          {locale === 'en' ? 'Done' : 'Terminé'}
        </Button>
      </div>
    </div>
  )

  const renderCurrentStep = () => {
    switch (currentStep) {
      case 'select-recipient':
        return renderSelectRecipient()
      case 'enter-amount':
        return renderEnterAmount()
      case 'review-confirm':
        return renderReviewConfirm()
      case 'success':
        return renderSuccess()
      default:
        return renderSelectRecipient()
    }
  }

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header */}
      <div className="p-4 pt-12 pb-6">
        <div className="flex items-center mb-6">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => {
              if (currentStep === 'select-recipient') {
                onBack()
              } else if (currentStep === 'enter-amount') {
                setCurrentStep('select-recipient')
              } else if (currentStep === 'review-confirm') {
                setCurrentStep('enter-amount')
              }
            }}
            className="mr-4 rounded-full touch-target hover:bg-muted/50 p-2"
          >
            <ArrowLeft className="h-6 w-6 text-foreground" />
          </Button>
          
          {/* Page Title */}
          <h1 className="text-xl font-semibold text-foreground">
            {currentStep === 'select-recipient' && (locale === 'en' ? 'Send Money' : 'Envoyer de l\'argent')}
            {currentStep === 'enter-amount' && (locale === 'en' ? 'Enter Amount' : 'Entrer le montant')}
            {currentStep === 'review-confirm' && (locale === 'en' ? 'Review' : 'Vérification')}
            {currentStep === 'success' && (locale === 'en' ? 'Success' : 'Succès')}
          </h1>
        </div>
        
        {/* Progress Indicator - Only show for non-success steps */}
        {currentStep !== 'success' && renderStepIndicator()}
      </div>

      {/* Content */}
      <div className="px-4">
        {renderCurrentStep()}
      </div>
    </div>
  )
}