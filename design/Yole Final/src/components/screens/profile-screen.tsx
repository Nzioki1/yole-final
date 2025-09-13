import { ChevronRight, User, Settings, HelpCircle, FileText, LogOut, Moon, Sun, Globe, Bell, Shield, Edit, Lock } from 'lucide-react'
import { Card } from '../ui/card'
import { Button } from '../ui/button'
import { Switch } from '../ui/switch'
import { StatusChip } from '../ui/status-chip'
import { Badge } from '../ui/badge'
import { Avatar, AvatarFallback } from '../ui/avatar'
import { Separator } from '../ui/separator'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'

interface ProfileItem {
  icon: any
  label: string
  value?: string
  action: string
  rightComponent?: React.ReactNode
  isSwitch?: boolean
  switchProps?: {
    checked: boolean
    onCheckedChange: (checked: boolean) => void
  }
}

export function ProfileScreen() {
  const { user, locale, theme, setLocale, setTheme, signOut, setCurrentView } = useAppContext()
  const { t } = useTranslation(locale)

  if (!user) return null

  const getKYCStatus = () => {
    switch (user.kycStatus) {
      case 'approved':
        return { variant: 'success' as const, text: t('kycApproved') }
      case 'pending':
        return { variant: 'warning' as const, text: t('kycPending') }
      case 'rejected':
        return { variant: 'error' as const, text: t('kycRejected') }
      default:
        return { variant: 'neutral' as const, text: 'Unknown' }
    }
  }

  const kycStatus = getKYCStatus()

  const profileSections: { title: string; items: ProfileItem[] }[] = [
    {
      title: locale === 'en' ? 'Personal Information' : 'Informations personnelles',
      items: [
        {
          icon: Shield,
          label: t('identityVerification'),
          value: kycStatus.variant === 'success' ? 
            (locale === 'en' ? 'Verified' : 'Vérifié') :
            kycStatus.variant === 'pending' ?
            (locale === 'en' ? 'Pending' : 'En attente') :
            (locale === 'en' ? 'Failed' : 'Échoué'),
          action: 'kyc-status',
          rightComponent: <StatusChip variant={kycStatus.variant}>{
            kycStatus.variant === 'success' ? 
              (locale === 'en' ? 'Verified' : 'Vérifié') :
              kycStatus.variant === 'pending' ?
              (locale === 'en' ? 'Pending' : 'En attente') :
              (locale === 'en' ? 'Failed' : 'Échoué')
          }</StatusChip>
        }
      ]
    },
    {
      title: t('settings'),
      items: [
        {
          icon: theme === 'dark' ? Sun : Moon,
          label: t('darkMode'),
          action: 'toggle-theme',
          isSwitch: true,
          switchProps: {
            checked: theme === 'dark',
            onCheckedChange: (checked: boolean) => setTheme(checked ? 'dark' : 'light')
          }
        },
        {
          icon: Edit,
          label: locale === 'en' ? 'Edit Profile' : 'Modifier le profil',
          action: 'edit-profile'
        }
      ]
    },
    {
      title: locale === 'en' ? 'Support' : 'Support',
      items: [
        {
          icon: HelpCircle,
          label: locale === 'en' ? 'Help Center' : 'Centre d\'aide',
          action: 'help'
        },
        {
          icon: FileText,
          label: locale === 'en' ? 'Terms & Privacy' : 'Conditions et confidentialité',
          action: 'legal'
        }
      ]
    },
    {
      title: locale === 'en' ? 'Preferences' : 'Préférences',
      items: [
        {
          icon: Bell,
          label: t('notifications'),
          action: 'notifications',
          isSwitch: true,
          switchProps: {
            checked: true,
            onCheckedChange: () => {}
          }
        },
        {
          icon: Globe,
          label: t('language'),
          value: locale === 'en' ? '🇺🇸 English' : '🇫🇷 Français',
          action: 'language'
        }
      ]
    }
  ]

  return (
    <div className="min-h-screen bg-background pb-24">
      {/* Header Card */}
      <div className="p-4 pt-12 pb-6">
        <Card className="p-6 rounded-2xl border border-border bg-card shadow-sm">
          <div className="flex items-center space-x-4">
            <div className="relative flex-shrink-0">
              <Avatar className="h-16 w-16 border-2 border-primary/20 shadow-md">
                <AvatarFallback className="bg-gradient-primary text-white text-xl font-semibold">
                  {user.firstName[0]}{user.lastName[0]}
                </AvatarFallback>
              </Avatar>
              {kycStatus.variant === 'success' && (
                <div className="absolute -bottom-1 -right-1 w-5 h-5 bg-success rounded-full border-2 border-card flex items-center justify-center">
                  <div className="w-2 h-2 bg-white rounded-full"></div>
                </div>
              )}
            </div>
            
            <div className="flex-1 min-w-0">
              <h1 className="text-xl font-semibold text-foreground">
                {user.firstName} {user.lastName}
              </h1>
              <p className="text-muted-foreground text-sm mt-1 truncate">{user.email}</p>
              <p className="text-muted-foreground text-sm truncate">{user.phone}</p>
              
              {kycStatus.variant === 'success' && (
                <div className="flex items-center gap-2 mt-2">
                  <Badge variant="secondary" className="bg-success/10 text-success border-success/20 text-xs">
                    <Shield className="h-3 w-3 mr-1" />
                    {locale === 'en' ? 'Verified' : 'Vérifié'}
                  </Badge>
                </div>
              )}
            </div>
          </div>
        </Card>
      </div>

      {/* Content */}
      <div className="px-4 space-y-6">
        {/* Profile Sections */}
        {profileSections.map((section, sectionIndex) => (
          <div key={sectionIndex}>
            <h2 className="font-semibold text-foreground mb-4">{section.title}</h2>
            <Card className="rounded-2xl border border-border bg-card overflow-hidden shadow-sm">
              {section.items.map((item, itemIndex) => (
                <div key={itemIndex}>
                  <div className="p-5 flex items-center justify-between hover:bg-muted/30 transition-colors duration-200">
                    <div className="flex items-center space-x-4 flex-1 min-w-0">
                      <div className="w-10 h-10 bg-primary/10 rounded-2xl flex items-center justify-center flex-shrink-0">
                        <item.icon className="h-5 w-5 text-primary" />
                      </div>
                      <div className="text-left flex-1 min-w-0">
                        <p className="font-semibold text-foreground">{item.label}</p>
                        {item.value && (
                          <p className="text-sm text-muted-foreground mt-0.5 truncate">{item.value}</p>
                        )}
                      </div>
                    </div>
                    
                    <div className="flex items-center space-x-3 flex-shrink-0">
                      {item.isSwitch && item.switchProps ? (
                        <Switch 
                          checked={item.switchProps.checked}
                          onCheckedChange={item.switchProps.onCheckedChange}
                          className="data-[state=checked]:bg-primary"
                        />
                      ) : item.rightComponent ? (
                        item.rightComponent
                      ) : (
                        <Button
                          variant="ghost" 
                          size="sm"
                          className="h-8 w-8 rounded-2xl p-0 hover:bg-muted/50 touch-target"
                          onClick={() => {
                            console.log('Navigate to:', item.action);
                          }}
                        >
                          <ChevronRight className="h-4 w-4 text-muted-foreground" />
                        </Button>
                      )}
                    </div>
                  </div>
                  
                  {itemIndex < section.items.length - 1 && (
                    <Separator className="bg-border/50" />
                  )}
                </div>
              ))}
            </Card>
          </div>
        ))}

        {/* Dev: System States Demo Button */}
        <div className="mb-4">
          <Button 
            onClick={() => setCurrentView('system-states')}
            variant="outline"
            className="w-full h-12 rounded-2xl border-2 border-dashed border-primary/30 text-primary hover:bg-primary/5"
          >
            🛠️ {locale === 'en' ? 'System States Demo' : 'Démo états système'}
          </Button>
        </div>

        {/* Sign Out Button */}
        <div className="pt-4 pb-6">
          <Button 
            onClick={signOut}
            className="w-full h-14 bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white rounded-2xl font-semibold transition-all duration-200 shadow-lg hover:shadow-xl touch-target"
          >
            <LogOut className="h-5 w-5 mr-3" />
            <span className="text-lg">{locale === 'en' ? 'Sign Out' : 'Se déconnecter'}</span>
          </Button>
        </div>
      </div>
    </div>
  )
}