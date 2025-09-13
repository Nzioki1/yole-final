interface YoleLogoProps {
  variant?: 'light' | 'dark'
  className?: string
}

// Light mode logo - original blue + dark text colors
export function YoleLogoLight({ className = "" }: { className?: string }) {
  return (
    <svg 
      width="120" 
      height="48" 
      viewBox="0 0 120 48" 
      fill="none" 
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      {/* Y */}
      <path 
        d="M8 8L16 20L24 8H28L18 24V36H14V24L4 8H8Z" 
        fill="#1a1a1a"
      />
      
      {/* O */}
      <circle 
        cx="40" 
        cy="22" 
        r="14" 
        fill="none" 
        stroke="#3B82F6" 
        strokeWidth="4"
      />
      
      {/* L */}
      <path 
        d="M60 8V32H76V36H56V8H60Z" 
        fill="#1a1a1a"
      />
      
      {/* E */}
      <path 
        d="M84 8V36H80V8H84ZM80 8H96V12H80V8ZM80 20H92V24H80V20ZM80 32H96V36H80V32Z" 
        fill="#1a1a1a"
      />
    </svg>
  )
}

// Dark mode logo - white version
export function YoleLogoDark({ className = "" }: { className?: string }) {
  return (
    <svg 
      width="120" 
      height="48" 
      viewBox="0 0 120 48" 
      fill="none" 
      xmlns="http://www.w3.org/2000/svg"
      className={className}
    >
      {/* Y */}
      <path 
        d="M8 8L16 20L24 8H28L18 24V36H14V24L4 8H8Z" 
        fill="white"
      />
      
      {/* O */}
      <circle 
        cx="40" 
        cy="22" 
        r="14" 
        fill="none" 
        stroke="white" 
        strokeWidth="4"
      />
      
      {/* L */}
      <path 
        d="M60 8V32H76V36H56V8H60Z" 
        fill="white"
      />
      
      {/* E */}
      <path 
        d="M84 8V36H80V8H84ZM80 8H96V12H80V8ZM80 20H92V24H80V20ZM80 32H96V36H80V32Z" 
        fill="white"
      />
    </svg>
  )
}

// Main adaptive logo component
export function YoleLogo({ variant, className = "" }: YoleLogoProps) {
  if (variant === 'dark') {
    return <YoleLogoDark className={className} />
  }
  
  return <YoleLogoLight className={className} />
}