import { Moon, Sun } from 'lucide-react'
import { useAppContext } from '../../lib/app-context'

export function ThemeToggle() {
  const { theme, setTheme } = useAppContext()

  return (
    <button
      onClick={() => setTheme(theme === 'light' ? 'dark' : 'light')}
      className="fixed top-4 right-4 z-50 p-3 rounded-full bg-background border shadow-lg hover:shadow-xl transition-all duration-200 touch-target"
      aria-label={`Switch to ${theme === 'light' ? 'dark' : 'light'} mode`}
    >
      {theme === 'light' ? (
        <Moon className="h-5 w-5 text-foreground" />
      ) : (
        <Sun className="h-5 w-5 text-foreground" />
      )}
    </button>
  )
}