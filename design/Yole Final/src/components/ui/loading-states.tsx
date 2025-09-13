import { Skeleton } from './skeleton'

// Dashboard transaction list skeleton
export function TransactionListSkeleton({ count = 3 }: { count?: number }) {
  return (
    <div className="space-y-4">
      {Array.from({ length: count }).map((_, index) => (
        <div key={index} className="p-6 rounded-2xl border border-border bg-card">
          <div className="flex items-center space-x-4">
            {/* Avatar skeleton */}
            <Skeleton className="h-12 w-12 rounded-full bg-muted flex-shrink-0" />
            
            {/* Content skeleton */}
            <div className="flex-1 space-y-2">
              <Skeleton className="h-4 w-3/4 bg-muted" />
              <Skeleton className="h-3 w-1/2 bg-muted" />
            </div>
            
            {/* Amount and status skeleton */}
            <div className="text-right space-y-2 flex-shrink-0">
              <Skeleton className="h-4 w-16 bg-muted ml-auto" />
              <Skeleton className="h-5 w-12 rounded-full bg-muted ml-auto" />
            </div>
          </div>
        </div>
      ))}
    </div>
  )
}

// Send flow recipient cards skeleton
export function SendFlowCardsSkeleton({ count = 2 }: { count?: number }) {
  return (
    <div className="space-y-4">
      {Array.from({ length: count }).map((_, index) => (
        <div key={index} className="p-6 rounded-2xl border border-border bg-card">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4 flex-1 min-w-0">
              {/* Avatar circle skeleton */}
              <Skeleton className="h-12 w-12 rounded-full bg-muted flex-shrink-0" />
              
              {/* Text content skeleton */}
              <div className="flex-1 space-y-2 min-w-0">
                <Skeleton className="h-4 w-2/3 bg-muted" />
                <Skeleton className="h-3 w-1/2 bg-muted" />
              </div>
            </div>
            
            {/* Button placeholder skeleton */}
            <Skeleton className="h-10 w-10 rounded-xl bg-muted flex-shrink-0 touch-target" />
          </div>
        </div>
      ))}
    </div>
  )
}

// Quote result area skeleton
export function QuoteResultSkeleton() {
  return (
    <div className="p-6 rounded-2xl border border-border bg-card space-y-6">
      {/* Header skeleton */}
      <div className="text-center space-y-2">
        <Skeleton className="h-5 w-1/3 bg-muted mx-auto" />
        <Skeleton className="h-8 w-2/3 bg-muted mx-auto" />
      </div>
      
      {/* Key values skeleton */}
      <div className="space-y-4">
        {/* Exchange rate */}
        <div className="flex justify-between items-center">
          <Skeleton className="h-4 w-1/3 bg-muted" />
          <Skeleton className="h-4 w-1/4 bg-muted" />
        </div>
        
        {/* Fee */}
        <div className="flex justify-between items-center">
          <Skeleton className="h-4 w-1/4 bg-muted" />
          <Skeleton className="h-4 w-1/6 bg-muted" />
        </div>
        
        {/* Total */}
        <div className="pt-2 border-t border-border">
          <div className="flex justify-between items-center">
            <Skeleton className="h-5 w-1/3 bg-muted" />
            <Skeleton className="h-5 w-1/3 bg-muted" />
          </div>
        </div>
      </div>
      
      {/* Action button skeleton */}
      <Skeleton className="h-12 w-full rounded-2xl bg-muted" />
    </div>
  )
}

// Activity cards skeleton (for home screen)
export function ActivityCardsSkeleton() {
  return (
    <div className="grid grid-cols-2 gap-4">
      {Array.from({ length: 2 }).map((_, index) => (
        <div key={index} className="p-5 rounded-2xl border border-border bg-card">
          <div className="space-y-3">
            {/* Icon skeleton */}
            <Skeleton className="h-10 w-10 rounded-2xl bg-muted" />
            
            {/* Number skeleton */}
            <Skeleton className="h-8 w-2/3 bg-muted" />
            
            {/* Label skeleton */}
            <Skeleton className="h-3 w-full bg-muted" />
          </div>
        </div>
      ))}
    </div>
  )
}

// Profile header skeleton
export function ProfileHeaderSkeleton() {
  return (
    <div className="p-6 rounded-2xl border border-border bg-card">
      <div className="flex items-center space-x-4">
        {/* Avatar skeleton */}
        <Skeleton className="h-16 w-16 rounded-full bg-muted flex-shrink-0" />
        
        {/* User info skeleton */}
        <div className="flex-1 space-y-2">
          <Skeleton className="h-5 w-2/3 bg-muted" />
          <Skeleton className="h-4 w-3/4 bg-muted" />
          <Skeleton className="h-4 w-1/2 bg-muted" />
        </div>
      </div>
    </div>
  )
}

// Generic loading overlay for full screen states
export function LoadingOverlay({ message = "Loading..." }: { message?: string }) {
  return (
    <div className="flex flex-col items-center justify-center min-h-[400px] space-y-4">
      {/* Animated spinner */}
      <div className="relative">
        <div className="w-12 h-12 border-4 border-muted rounded-full animate-spin">
          <div className="absolute top-0 left-0 w-12 h-12 border-4 border-transparent border-t-primary rounded-full animate-spin"></div>
        </div>
      </div>
      
      {/* Loading message */}
      <p className="text-muted-foreground text-sm font-medium">{message}</p>
    </div>
  )
}

// Page level skeleton for full screen loading
export function PageSkeleton() {
  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header skeleton */}
      <div className="p-4 pt-12 pb-6 space-y-4">
        <div className="flex items-center justify-between">
          <Skeleton className="h-8 w-2/3 bg-muted" />
          <Skeleton className="h-12 w-12 rounded-full bg-muted" />
        </div>
        
        {/* Activity cards skeleton */}
        <ActivityCardsSkeleton />
        
        {/* CTA button skeleton */}
        <Skeleton className="h-14 w-full rounded-2xl bg-muted" />
      </div>
      
      {/* Content skeleton */}
      <div className="px-4 space-y-4">
        <Skeleton className="h-6 w-1/2 bg-muted" />
        <TransactionListSkeleton />
      </div>
    </div>
  )
}