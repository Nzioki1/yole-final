import { Send, TrendingUp, ArrowUpRight, Clock } from 'lucide-react'
import { Card } from '../ui/card'
import { StatusChip } from '../ui/status-chip'
import { Avatar, AvatarFallback } from '../ui/avatar'
import { Button } from '../ui/button'
import { NoTransactionsEmpty } from '../ui/empty-state'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { mockTransactions, networkInfo } from '../../lib/mock-data'

export function HomeScreen() {
  const { user, locale, setCurrentView } = useAppContext()
  const { t } = useTranslation(locale)

  if (!user) return null

  // For demo purposes, we can simulate empty state by using an empty array
  // In real app, this would come from API/database
  const transactions = mockTransactions // Change to [] to test empty state
  const hasTransactions = transactions.length > 0

  const formatGreeting = () => {
    const hour = new Date().getHours()
    if (hour < 12) {
      return locale === 'en' ? 'Good morning' : 'Bonjour'
    } else if (hour < 18) {
      return locale === 'en' ? 'Good afternoon' : 'Bon après-midi'
    } else {
      return locale === 'en' ? 'Good evening' : 'Bonsoir'
    }
  }

  // Calculate weekly stats
  const getWeeklyStats = () => {
    const now = new Date()
    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000)
    
    const weeklyTransactions = transactions.filter(t => 
      new Date(t.timestamp) >= weekAgo && t.status !== 'failed'
    )
    
    const totalSent = weeklyTransactions.reduce((sum, t) => sum + t.amount.sent, 0)
    
    return {
      count: weeklyTransactions.length,
      totalSent,
      currency: weeklyTransactions[0]?.amount.sentCurrency || 'USD'
    }
  }

  const weeklyStats = getWeeklyStats()

  const formatLastSent = (dateString: string) => {
    const date = new Date(dateString)
    const now = new Date()
    const diffTime = Math.abs(now.getTime() - date.getTime())
    const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24))
    const diffHours = Math.floor(diffTime / (1000 * 60 * 60))
    
    if (diffHours < 1) {
      return locale === 'en' ? 'Just now' : 'À l\'instant'
    } else if (diffHours < 24) {
      return locale === 'en' ? `${diffHours}h ago` : `Il y a ${diffHours}h`
    } else if (diffDays === 1) {
      return locale === 'en' ? '1 day ago' : 'Il y a 1 jour'
    } else if (diffDays < 7) {
      return locale === 'en' ? `${diffDays} days ago` : `Il y a ${diffDays} jours`
    } else {
      return date.toLocaleDateString(locale === 'en' ? 'en-US' : 'fr-FR', {
        month: 'short',
        day: 'numeric'
      })
    }
  }

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header Section */}
      <div className="px-4 pt-12 pb-6">
        <div className="flex items-center justify-between mb-6">
          {/* Greeting and User Name */}
          <div className="flex-1">
            <h1 className="text-2xl font-semibold text-foreground">
              {formatGreeting()}, {user.firstName} 👋
            </h1>
          </div>
          
          {/* Avatar - Tap to Profile */}
          <button 
            onClick={() => setCurrentView('profile')}
            className="flex-shrink-0 touch-target"
          >
            <Avatar className="h-12 w-12 border-2 border-primary/20 shadow-md">
              <AvatarFallback className="bg-gradient-primary text-white font-semibold">
                {user.firstName[0]}{user.lastName[0]}
              </AvatarFallback>
            </Avatar>
          </button>
        </div>

        {/* Activity Cards - Side by Side */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          {/* Transactions This Week */}
          <Card className="p-5 rounded-2xl bg-card border border-border shadow-sm hover:shadow-md transition-all duration-200">
            <div className="flex items-center justify-between mb-2">
              <div className="w-10 h-10 bg-primary/10 rounded-2xl flex items-center justify-center">
                <TrendingUp className="h-5 w-5 text-primary" />
              </div>
              <ArrowUpRight className="h-4 w-4 text-success" />
            </div>
            <div className="space-y-1">
              <p className="text-2xl font-bold tabular-nums text-foreground">
                {weeklyStats.count}
              </p>
              <p className="text-sm text-muted-foreground">
                {locale === 'en' ? 'Transactions This Week' : 'Transactions cette semaine'}
              </p>
            </div>
          </Card>

          {/* Total Sent This Week */}
          <Card className="p-5 rounded-2xl bg-card border border-border shadow-sm hover:shadow-md transition-all duration-200">
            <div className="flex items-center justify-between mb-2">
              <div className="w-10 h-10 bg-success/10 rounded-2xl flex items-center justify-center">
                <Send className="h-5 w-5 text-success" />
              </div>
              <ArrowUpRight className="h-4 w-4 text-success" />
            </div>
            <div className="space-y-1">
              <p className="text-2xl font-bold tabular-nums text-foreground">
                {weeklyStats.totalSent.toLocaleString(locale === 'fr' ? 'fr-FR' : 'en-US', {
                  style: 'currency',
                  currency: weeklyStats.currency,
                  maximumFractionDigits: 0
                })}
              </p>
              <p className="text-sm text-muted-foreground">
                {locale === 'en' ? 'Total Sent This Week' : 'Total envoyé cette semaine'}
              </p>
            </div>
          </Card>
        </div>

        {/* Primary Send Money CTA */}
        <Button 
          onClick={() => setCurrentView('send')}
          className="w-full h-14 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-semibold shadow-lg hover:shadow-xl touch-target"
        >
          <Send className="h-5 w-5 mr-3" />
          <span className="text-lg">{locale === 'en' ? 'Send Money' : 'Envoyer de l\'argent'}</span>
        </Button>
      </div>

      {/* Recent Transactions Section */}
      <div className="px-4">
        {hasTransactions ? (
          <>
            {/* Section Header */}
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-semibold text-foreground">
                {locale === 'en' ? 'Recent Transactions' : 'Transactions récentes'}
              </h2>
              <button 
                className="text-primary hover:underline font-medium transition-colors"
                onClick={() => setCurrentView('transactions')}
              >
                {locale === 'en' ? 'View All' : 'Voir tout'}
              </button>
            </div>
            
            {/* Transaction List - Max 3 items */}
            <div className="space-y-3">
              {transactions.slice(0, 3).map((transaction) => (
                <Card 
                  key={transaction.id} 
                  className="p-4 cursor-pointer hover:shadow-lg hover:scale-[1.01] transition-all duration-200 rounded-2xl border border-border bg-card"
                  onClick={() => setCurrentView(`transaction-${transaction.id}`)}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-4 flex-1 min-w-0">
                      {/* Recipient Avatar */}
                      <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-sm flex-shrink-0">
                        <span className="text-white font-semibold">
                          {transaction.recipient.firstName[0]}{transaction.recipient.lastName[0]}
                        </span>
                      </div>
                      
                      {/* Transaction Info */}
                      <div className="flex-1 min-w-0">
                        <p className="font-semibold text-foreground truncate">
                          {transaction.recipient.firstName} {transaction.recipient.lastName}
                        </p>
                        <div className="flex items-center gap-2 mt-0.5">
                          <Clock className="h-3 w-3 text-muted-foreground" />
                          <p className="text-sm text-muted-foreground">
                            {formatLastSent(transaction.timestamp)}
                          </p>
                        </div>
                      </div>
                    </div>
                    
                    {/* Amount and Status */}
                    <div className="text-right flex-shrink-0 ml-4">
                      <p className="font-bold tabular-nums text-foreground">
                        -{transaction.amount.sent.toLocaleString(locale === 'fr' ? 'fr-FR' : 'en-US', {
                          style: 'currency',
                          currency: transaction.amount.sentCurrency
                        })}
                      </p>
                      <div className="mt-1">
                        <StatusChip variant={
                          transaction.status === 'delivered' ? 'success' :
                          transaction.status === 'processing' ? 'info' :
                          transaction.status === 'failed' ? 'error' : 'neutral'
                        }>
                          {transaction.status === 'delivered' ? (locale === 'en' ? 'Delivered' : 'Livré') :
                           transaction.status === 'processing' ? (locale === 'en' ? 'Processing' : 'En cours') :
                           transaction.status === 'failed' ? (locale === 'en' ? 'Failed' : 'Échoué') : 
                           (locale === 'en' ? 'Pending' : 'En attente')}
                        </StatusChip>
                      </div>
                    </div>
                  </div>
                </Card>
              ))}
            </div>
          </>
        ) : (
          <NoTransactionsEmpty onAction={() => setCurrentView('send')} />
        )}
      </div>
    </div>
  )
}