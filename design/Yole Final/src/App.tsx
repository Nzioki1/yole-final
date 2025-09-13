import { AppProvider, useAppContext } from './lib/app-context'
import { BottomNavigation } from './components/layout/bottom-navigation'
import { SplashScreen } from './components/screens/splash-screen'
import { WelcomeScreen } from './components/screens/welcome-screen'
import { RegisterScreen } from './components/screens/register-screen'
import { EmailVerificationScreen } from './components/screens/email-verification-screen'
import { LoginScreen } from './components/screens/login-screen'
import { ForgotPasswordScreen } from './components/screens/forgot-password-screen'
import { SignupScreen } from './components/screens/signup-screen'
import { KYCScreen } from './components/screens/kyc-screen'
import { KYCPhoneScreen } from './components/screens/kyc-phone-screen'
import { KYCOTPScreen } from './components/screens/kyc-otp-screen'
import { KYCIdCaptureScreen } from './components/screens/kyc-id-capture-screen'
import { KYCSelfieScreen } from './components/screens/kyc-selfie-screen'
import { KYCSuccessScreen } from './components/screens/kyc-success-screen'
import { KYCErrorScreen } from './components/screens/kyc-error-screen'
import { HomeScreen } from './components/screens/home-screen'
import { SendScreen } from './components/screens/send-screen'
import { FavoritesScreen } from './components/screens/favorites-screen'
import { ProfileScreen } from './components/screens/profile-screen'
import { SystemStatesShowcase } from './components/examples/system-states-showcase'
import { SystemStatesDemoScreen } from './components/screens/system-states-demo'
import { ThemeToggle } from './components/ui/theme-toggle'

function AppContent() {
  const { currentView, setCurrentView, isAuthenticated, locale } = useAppContext()

  // Handle unauthenticated screens
  if (!isAuthenticated) {
    switch (currentView) {
      case 'welcome':
        return <WelcomeScreen />
      case 'register':
        return <RegisterScreen />
      case 'email-verification':
        return <EmailVerificationScreen />
      case 'login':
        return <LoginScreen />
      case 'forgot-password':
        return <ForgotPasswordScreen />
      case 'signup':
        return <SignupScreen />
      case 'kyc':
        return <KYCScreen />
      case 'kyc-phone':
        return <KYCPhoneScreen />
      case 'kyc-otp':
        return <KYCOTPScreen />
      case 'kyc-id-capture':
        return <KYCIdCaptureScreen />
      case 'kyc-selfie':
        return <KYCSelfieScreen />
      case 'kyc-success':
        return <KYCSuccessScreen />
      case 'kyc-error':
        return <KYCErrorScreen />
      default:
        return <SplashScreen />
    }
  }

  // Handle authenticated screens
  const renderScreen = () => {
    if (currentView.startsWith('transaction-')) {
      // Transaction detail view
      return <HomeScreen /> // Would show transaction detail
    }

    switch (currentView) {
      case 'home':
        return <HomeScreen />
      case 'send':
        return <SendScreen />
      case 'favorites':
        return <FavoritesScreen />
      case 'profile':
        return <ProfileScreen />
      case 'system-states':
        return <SystemStatesShowcase />
      case 'system-states-demo':
        return <SystemStatesDemoScreen />
      default:
        return <HomeScreen />
    }
  }

  const isMainView = ['home', 'send', 'favorites', 'profile'].includes(currentView)

  return (
    <div className={`min-h-screen ${isMainView ? 'bg-background' : ''}`}>
      {renderScreen()}
      
      {/* Bottom Navigation - only show on main views */}
      {isMainView && (
        <BottomNavigation
          activeTab={currentView as 'home' | 'send' | 'favorites' | 'profile'}
          onTabChange={setCurrentView}
          locale={locale}
        />
      )}
      

    </div>
  )
}

export default function App() {
  return (
    <AppProvider>
      <div className="min-h-screen max-w-md mx-auto bg-background">
        <AppContent />
      </div>
    </AppProvider>
  )
}