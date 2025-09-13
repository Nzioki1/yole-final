import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "./utils"

const statusChipVariants = cva(
  "inline-flex items-center rounded-full px-3 py-1 text-xs font-medium",
  {
    variants: {
      variant: {
        success: "bg-green-500/15 text-green-700 border border-green-500/30 dark:text-green-400",
        error: "bg-red-500/15 text-red-700 border border-red-500/30 dark:text-red-400",
        warning: "bg-orange-500/15 text-orange-700 border border-orange-500/30 dark:text-orange-400",
        info: "bg-blue-500/15 text-blue-700 border border-blue-500/30 dark:text-blue-400",
        pending: "bg-orange-500/15 text-orange-700 border border-orange-500/30 dark:text-orange-400",
        neutral: "bg-muted text-muted-foreground border border-border",
      },
    },
    defaultVariants: {
      variant: "neutral",
    },
  }
)

export interface StatusChipProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof statusChipVariants> {}

const StatusChip = React.forwardRef<HTMLDivElement, StatusChipProps>(
  ({ className, variant, ...props }, ref) => {
    return (
      <div
        className={cn(statusChipVariants({ variant, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
StatusChip.displayName = "StatusChip"

export { StatusChip, statusChipVariants }