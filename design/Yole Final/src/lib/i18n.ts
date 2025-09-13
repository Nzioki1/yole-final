// Mock localization system for the remittance app
export type Locale = 'en' | 'fr'

const translations = {
  en: {
    // Navigation
    home: 'Home',
    send: 'Send',
    favorites: 'Favorites',
    profile: 'Profile',
    
    // Common
    continue: 'Continue',
    cancel: 'Cancel',
    confirm: 'Confirm',
    back: 'Back',
    next: 'Next',
    done: 'Done',
    edit: 'Edit',
    delete: 'Delete',
    retry: 'Retry',
    
    // Auth
    welcome: 'Welcome',
    signUp: 'Sign Up',
    logIn: 'Log In',
    createAccount: 'Create Account',
    email: 'Email',
    password: 'Password',
    firstName: 'First Name',
    lastName: 'Last Name',
    phoneNumber: 'Phone Number',
    
    // KYC
    kycVerification: 'KYC Verification',
    identityVerification: 'Identity Verification',
    documentUpload: 'Document Upload',
    selfieVerification: 'Selfie Verification',
    kycPending: 'Verification Pending',
    kycApproved: 'Verified',
    kycRejected: 'Verification Failed',
    
    // Home
    welcomeBack: 'Welcome back',
    balance: 'Balance',
    recentTransactions: 'Recent Transactions',
    exchangeRate: 'Exchange Rate',
    
    // Send Money
    sendMoney: 'Send Money',
    recipient: 'Recipient',
    amount: 'Amount',
    summary: 'Summary',
    success: 'Success',
    selectRecipient: 'Select Recipient',
    enterAmount: 'Enter Amount',
    youSend: 'You Send',
    recipientGets: 'Recipient Gets',
    exchangeRate_: 'Exchange Rate',
    fees: 'Fees',
    total: 'Total',
    estimatedArrival: 'Estimated Arrival',
    
    // Transaction Status
    delivered: 'Delivered',
    processing: 'Processing',
    failed: 'Failed',
    pending: 'Pending',
    
    // Errors & Validation
    fieldRequired: 'This field is required',
    invalidPhone: 'Invalid phone number',
    invalidEmail: 'Invalid email address',
    
    // Profile
    personalInfo: 'Personal Information',
    paymentMethods: 'Payment Methods',
    settings: 'Settings',
    help: 'Help & Support',
    legal: 'Legal',
    darkMode: 'Dark Mode',
    language: 'Language',
    notifications: 'Notifications',
    signOut: 'Sign Out',
  },
  fr: {
    // Navigation
    home: 'Accueil',
    send: 'Envoyer',
    favorites: 'Favoris',
    profile: 'Profil',
    
    // Common
    continue: 'Continuer',
    cancel: 'Annuler',
    confirm: 'Confirmer',
    back: 'Retour',
    next: 'Suivant',
    done: 'Terminé',
    edit: 'Modifier',
    delete: 'Supprimer',
    retry: 'Réessayer',
    
    // Auth
    welcome: 'Bienvenue',
    signUp: 'S\'inscrire',
    logIn: 'Se connecter',
    createAccount: 'Créer un compte',
    email: 'E-mail',
    password: 'Mot de passe',
    firstName: 'Prénom',
    lastName: 'Nom',
    phoneNumber: 'Numéro de téléphone',
    
    // KYC
    kycVerification: 'Vérification KYC',
    identityVerification: 'Vérification d\'identité',
    documentUpload: 'Téléchargement de documents',
    selfieVerification: 'Vérification selfie',
    kycPending: 'Vérification en attente',
    kycApproved: 'Vérifié',
    kycRejected: 'Vérification échouée',
    
    // Home
    welcomeBack: 'Bon retour',
    balance: 'Solde',
    recentTransactions: 'Transactions récentes',
    exchangeRate: 'Taux de change',
    
    // Send Money
    sendMoney: 'Envoyer de l\'argent',
    recipient: 'Destinataire',
    amount: 'Montant',
    summary: 'Résumé',
    success: 'Succès',
    selectRecipient: 'Sélectionner un destinataire',
    enterAmount: 'Entrer le montant',
    youSend: 'Vous envoyez',
    recipientGets: 'Le destinataire reçoit',
    exchangeRate_: 'Taux de change',
    fees: 'Frais',
    total: 'Total',
    estimatedArrival: 'Arrivée estimée',
    
    // Transaction Status
    delivered: 'Livré',
    processing: 'En traitement',
    failed: 'Échec',
    pending: 'En attente',
    
    // Errors & Validation
    fieldRequired: 'Ce champ est requis',
    invalidPhone: 'Numéro de téléphone invalide',
    invalidEmail: 'Adresse e-mail invalide',
    
    // Profile
    personalInfo: 'Informations personnelles',
    paymentMethods: 'Méthodes de paiement',
    settings: 'Paramètres',
    help: 'Aide et support',
    legal: 'Légal',
    darkMode: 'Mode sombre',
    language: 'Langue',
    notifications: 'Notifications',
    signOut: 'Se déconnecter',
  }
}

export function useTranslation(locale: Locale = 'en') {
  return {
    t: (key: keyof typeof translations.en): string => {
      return translations[locale][key] || translations.en[key] || key
    },
    locale
  }
}