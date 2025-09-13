import * as React from "react"
import { cn } from "./utils"

interface AmountDisplayProps extends React.HTMLAttributes<HTMLDivElement> {
  amount: number
  currency: string
  locale?: 'en' | 'fr'
  size?: 'sm' | 'md' | 'lg'
}

const AmountDisplay = React.forwardRef<HTMLDivElement, AmountDisplayProps>(
  ({ className, amount, currency, locale = 'en', size = 'md', ...props }, ref) => {
    const formatAmount = (amount: number, currency: string, locale: string) => {
      if (locale === 'fr') {
        // French formatting: space for thousands, comma for decimals
        const formatted = new Intl.NumberFormat('fr-FR', {
          style: 'currency',
          currency: currency,
          minimumFractionDigits: currency === 'CDF' ? 0 : 2,
          maximumFractionDigits: currency === 'CDF' ? 0 : 2,
        }).format(amount)
        return formatted
      } else {
        // English formatting: comma for thousands, period for decimals
        const formatted = new Intl.NumberFormat('en-US', {
          style: 'currency',
          currency: currency,
          minimumFractionDigits: currency === 'CDF' ? 0 : 2,
          maximumFractionDigits: currency === 'CDF' ? 0 : 2,
        }).format(amount)
        return formatted
      }
    }

    const sizeClasses = {
      sm: 'text-sm',
      md: 'text-base',
      lg: 'text-2xl'
    }

    return (
      <div
        className={cn("tabular-nums font-semibold", sizeClasses[size], className)}
        ref={ref}
        {...props}
      >
        {formatAmount(amount, currency, locale)}
      </div>
    )
  }
)
AmountDisplay.displayName = "AmountDisplay"

export { AmountDisplay }