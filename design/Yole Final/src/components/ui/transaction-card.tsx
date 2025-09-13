import { Card } from './card'
import { StatusChip } from './status-chip'
import { AmountDisplay } from './amount-display'
import { type Transaction } from '../../lib/mock-data'
import { networkInfo } from '../../lib/mock-data'
import { useTranslation } from '../../lib/i18n'

interface TransactionCardProps {
  transaction: Transaction
  locale: 'en' | 'fr'
  onClick?: () => void
}

export function TransactionCard({ transaction, locale, onClick }: TransactionCardProps) {
  const { t } = useTranslation(locale)

  const getStatusVariant = (status: string) => {
    switch (status) {
      case 'delivered':
        return 'success' as const
      case 'processing':
        return 'warning' as const
      case 'failed':
        return 'error' as const
      case 'pending':
        return 'pending' as const
      default:
        return 'neutral' as const
    }
  }

  const formatDate = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleDateString(locale === 'fr' ? 'fr-FR' : 'en-US', {
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    })
  }

  return (
    <Card 
      className={`p-4 transition-colors ${onClick ? 'cursor-pointer hover:bg-muted/50' : ''}`}
      onClick={onClick}
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <div className="w-10 h-10 bg-muted rounded-full flex items-center justify-center">
            <span className="text-lg">
              {networkInfo[transaction.recipient.network].logo}
            </span>
          </div>
          <div>
            <p className="font-medium">
              {transaction.recipient.firstName} {transaction.recipient.lastName}
            </p>
            <p className="text-sm text-muted-foreground">
              {transaction.recipient.phone}
            </p>
            <p className="text-xs text-muted-foreground">
              {formatDate(transaction.date)}
            </p>
          </div>
        </div>
        
        <div className="text-right">
          <AmountDisplay
            amount={transaction.amount.sent}
            currency={transaction.amount.sentCurrency}
            locale={locale}
            size="sm"
          />
          <StatusChip variant={getStatusVariant(transaction.status)} className="mt-1">
            {t(transaction.status)}
          </StatusChip>
        </div>
      </div>
    </Card>
  )
}