import React, { createContext, useContext, useState, ReactNode } from 'react'
import { mockUser, type User } from './mock-data'
import type { Locale } from './i18n'

interface AppContextType {
  user: User | null
  locale: Locale
  theme: 'light' | 'dark'
  isAuthenticated: boolean
  currentView: string
  setUser: (user: User | null) => void
  setLocale: (locale: Locale) => void
  setTheme: (theme: 'light' | 'dark') => void
  setIsAuthenticated: (authenticated: boolean) => void
  setCurrentView: (view: string) => void
  signOut: () => void
}

const AppContext = createContext<AppContextType | undefined>(undefined)

export function useAppContext() {
  const context = useContext(AppContext)
  if (context === undefined) {
    throw new Error('useAppContext must be used within an AppProvider')
  }
  return context
}

interface AppProviderProps {
  children: ReactNode
}

export function AppProvider({ children }: AppProviderProps) {
  const [user, setUser] = useState<User | null>(null) // Start unauthenticated
  const [locale, setLocale] = useState<Locale>('en')
  const [theme, setTheme] = useState<'light' | 'dark'>('light')
  const [isAuthenticated, setIsAuthenticated] = useState(false) // Start unauthenticated
  const [currentView, setCurrentView] = useState('splash')

  const signOut = () => {
    setUser(null)
    setIsAuthenticated(false)
    setCurrentView('splash')
  }

  const value: AppContextType = {
    user,
    locale,
    theme,
    isAuthenticated,
    currentView,
    setUser,
    setLocale,
    setTheme,
    setIsAuthenticated,
    setCurrentView,
    signOut
  }

  return (
    <AppContext.Provider value={value}>
      <div className={theme}>
        {children}
      </div>
    </AppContext.Provider>
  )
}