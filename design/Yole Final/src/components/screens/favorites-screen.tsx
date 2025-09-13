import { useState } from 'react'
import { Heart, Search, MoreVertical, Edit, Trash2, Send, BarChart3, Clock } from 'lucide-react'
import { Card } from '../ui/card'
import { Input } from '../ui/input'
import { Button } from '../ui/button'
import { StatusChip } from '../ui/status-chip'
import { Badge } from '../ui/badge'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger, DropdownMenuSeparator } from '../ui/dropdown-menu'
import { NoFavoritesEmpty, NoSearchResultsEmpty } from '../ui/empty-state'
import { useTranslation } from '../../lib/i18n'
import { useAppContext } from '../../lib/app-context'
import { mockRecipients, mockTransactions, networkInfo } from '../../lib/mock-data'

export function FavoritesScreen() {
  const { locale, setCurrentView } = useAppContext()
  const { t } = useTranslation(locale)
  const [searchQuery, setSearchQuery] = useState('')

  const favoriteRecipients = mockRecipients.filter(recipient => recipient.isFavorite)
  const recentTransactions = mockTransactions.slice(0, 3) // Get last 3 transactions
  
  // Combine favorites and recent transactions into unified list
  const unifiedList = [
    ...favoriteRecipients.map(recipient => ({
      type: 'favorite' as const,
      id: recipient.id,
      recipient,
      lastSent: mockTransactions.find(t => t.recipientId === recipient.id)?.date,
      lastAmount: mockTransactions.find(t => t.recipientId === recipient.id)?.amount
    })),
    ...recentTransactions.filter(transaction => 
      !favoriteRecipients.some(fav => fav.id === transaction.recipientId)
    ).map(transaction => ({
      type: 'recent' as const,
      id: transaction.id,
      recipient: transaction.recipient,
      lastSent: transaction.date,
      lastAmount: transaction.amount
    }))
  ]
  
  const filteredList = unifiedList.filter(item =>
    searchQuery === '' || 
    `${item.recipient.firstName} ${item.recipient.lastName}`.toLowerCase().includes(searchQuery.toLowerCase()) ||
    item.recipient.phone.includes(searchQuery)
  )

  const handleSendMoney = (recipientId: string) => {
    // Navigate to send screen with pre-selected recipient
    setCurrentView('send')
  }

  const handleEditRecipient = (recipientId: string) => {
    // Future functionality to edit recipient details
    console.log('Edit recipient:', recipientId)
  }

  const handleRemoveFromFavorites = (recipientId: string) => {
    // Future functionality to remove from favorites
    console.log('Remove from favorites:', recipientId)
  }

  const handleViewHistory = (recipientId: string) => {
    // Future functionality to view transaction history
    console.log('View history for:', recipientId)
  }

  const formatLastSent = (dateString?: string) => {
    if (!dateString) return null
    
    const date = new Date(dateString)
    const now = new Date()
    const diffTime = Math.abs(now.getTime() - date.getTime())
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
    
    if (diffDays === 1) {
      return locale === 'en' ? '1 day ago' : 'il y a 1 jour'
    } else if (diffDays < 7) {
      return locale === 'en' ? `${diffDays} days ago` : `il y a ${diffDays} jours`
    } else {
      return date.toLocaleDateString(locale === 'en' ? 'en-US' : 'fr-FR')
    }
  }

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header */}
      <div className="bg-gradient-primary text-white p-4 pt-12">
        <div className="flex items-center space-x-3 mb-4">
          <Heart className="h-6 w-6" />
          <h1 className="text-xl font-semibold">
            {locale === 'en' ? 'Favorites & Recent' : 'Favoris et récents'}
          </h1>
        </div>
        
        <p className="text-white/80 text-sm">
          {locale === 'en' 
            ? 'Quick access to your favorite recipients and recent activity'
            : 'Accès rapide à vos destinataires favoris et activité récente'
          }
        </p>
      </div>

      {/* Content */}
      <div className="p-4 space-y-6">
        {/* Statistics Pills */}
        <div className="flex items-center gap-3 overflow-x-auto pb-2">
          <Badge variant="secondary" className="px-4 py-2 rounded-full bg-primary/10 text-primary border-0 whitespace-nowrap">
            <Heart className="h-3 w-3 mr-1 fill-current" />
            {favoriteRecipients.length} {locale === 'en' ? 'Favorites' : 'Favoris'}
          </Badge>
          
          <Badge variant="secondary" className="px-4 py-2 rounded-full bg-success/10 text-success border-0 whitespace-nowrap">
            <Send className="h-3 w-3 mr-1" />
            {mockTransactions.length} {locale === 'en' ? 'Sent this month' : 'Envoyés ce mois'}
          </Badge>
        </div>

        {/* Search */}
        <div className="relative">
          <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 h-5 w-5 text-muted-foreground" />
          <Input
            placeholder={locale === 'en' ? 'Search favorites and recent...' : 'Rechercher favoris et récents...'}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="pl-12 h-14 rounded-2xl bg-neutral-100 dark:bg-neutral-800 border-0 placeholder:text-gray-500 dark:placeholder:text-gray-300 text-foreground focus:ring-2 focus:ring-primary/20"
          />
        </div>

        {/* Unified Recipients List */}
        {filteredList.length > 0 ? (
          <div className="space-y-3">
            <h3 className="font-semibold text-foreground">
              {locale === 'en' ? 'Recipients' : 'Destinataires'}
            </h3>
            
            {filteredList.map((item) => (
              <Card key={item.id} className="p-4 rounded-2xl border border-border bg-card hover:shadow-lg transition-all duration-200">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-4 flex-1 min-w-0">
                    {/* Avatar with gradient background */}
                    <div className="relative flex-shrink-0">
                      <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-purple-600 rounded-full flex items-center justify-center shadow-sm">
                        <span className="text-white font-semibold">
                          {item.recipient.firstName[0]}{item.recipient.lastName[0]}
                        </span>
                      </div>
                      {item.type === 'favorite' && (
                        <div className="absolute -top-1 -right-1 w-5 h-5 bg-yellow-500 rounded-full flex items-center justify-center border-2 border-white dark:border-gray-800">
                          <Heart className="h-2.5 w-2.5 text-white fill-current" />
                        </div>
                      )}
                    </div>
                    
                    <div className="flex-1 min-w-0">
                      <div className="flex items-start justify-between">
                        <div className="min-w-0 flex-1">
                          <p className="font-semibold text-foreground truncate">
                            {item.recipient.firstName} {item.recipient.lastName}
                          </p>
                          <p className="text-sm text-muted-foreground truncate">
                            {item.recipient.phone}
                          </p>
                          <div className="flex items-center gap-2 mt-1">
                            <StatusChip variant="info" className="text-xs">
                              {networkInfo[item.recipient.network].name}
                            </StatusChip>
                            {item.lastSent && (
                              <div className="flex items-center text-xs text-muted-foreground">
                                <Clock className="h-3 w-3 mr-1" />
                                {formatLastSent(item.lastSent)}
                              </div>
                            )}
                          </div>
                        </div>
                        
                        {item.lastAmount && (
                          <div className="text-right flex-shrink-0 ml-2">
                            <p className="text-sm font-semibold text-success tabular-nums">
                              {item.lastAmount.sent.toLocaleString('en-US', { 
                                style: 'currency', 
                                currency: item.lastAmount.sentCurrency 
                              })}
                            </p>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>

                  {/* Action buttons */}
                  <div className="flex items-center space-x-2 flex-shrink-0 ml-4">
                    <Button
                      size="sm"
                      onClick={() => handleSendMoney(item.recipient.id)}
                      className="h-10 px-4 rounded-2xl bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 transition-all duration-200 text-white font-medium shadow-sm hover:shadow-md"
                    >
                      <Send className="h-4 w-4 mr-1" />
                      {locale === 'en' ? 'Send' : 'Envoyer'}
                    </Button>
                    
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <Button
                          variant="ghost" 
                          size="sm"
                          className="h-10 w-10 rounded-2xl p-0 hover:bg-muted/50 touch-target"
                        >
                          <MoreVertical className="h-4 w-4 text-muted-foreground" />
                        </Button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end" className="w-48">
                        <DropdownMenuItem onClick={() => handleEditRecipient(item.recipient.id)}>
                          <Edit className="h-4 w-4 mr-2" />
                          {locale === 'en' ? 'Edit Recipient' : 'Modifier destinataire'}
                        </DropdownMenuItem>
                        
                        {item.type === 'favorite' && (
                          <DropdownMenuItem 
                            onClick={() => handleRemoveFromFavorites(item.recipient.id)}
                            className="text-orange-600 dark:text-orange-400"
                          >
                            <Heart className="h-4 w-4 mr-2" />
                            {locale === 'en' ? 'Remove from Favorites' : 'Retirer des favoris'}
                          </DropdownMenuItem>
                        )}
                        
                        <DropdownMenuSeparator />
                        
                        <DropdownMenuItem onClick={() => handleViewHistory(item.recipient.id)}>
                          <BarChart3 className="h-4 w-4 mr-2" />
                          {locale === 'en' ? 'View History' : 'Voir l\'historique'}
                        </DropdownMenuItem>
                        
                        <DropdownMenuItem 
                          className="text-destructive"
                          onClick={() => console.log('Delete recipient:', item.recipient.id)}
                        >
                          <Trash2 className="h-4 w-4 mr-2" />
                          {locale === 'en' ? 'Delete' : 'Supprimer'}
                        </DropdownMenuItem>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>
                </div>
              </Card>
            ))}
          </div>
        ) : searchQuery ? (
          <NoSearchResultsEmpty onAction={() => setSearchQuery('')} />
        ) : (
          <NoFavoritesEmpty onAction={() => setCurrentView('send')} />
        )}
      </div>
    </div>
  )
}