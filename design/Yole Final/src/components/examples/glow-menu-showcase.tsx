import { useState } from 'react'
import { GlowMenu } from '../layout/glow-menu'
import { GlowMenuVariants } from '../layout/glow-menu-variants'
import { HomeScreen } from '../screens/home-screen'
import { SendScreen } from '../screens/send-screen'
import { FavoritesScreen } from '../screens/favorites-screen'
import { ProfileScreen } from '../screens/profile-screen'
import { Card } from '../ui/card'
import { Button } from '../ui/button'
import { Badge } from '../ui/badge'

export function GlowMenuShowcase() {
  const [activeTab, setActiveTab] = useState<'home' | 'send' | 'favorites' | 'profile'>('home')
  const [currentVariant, setCurrentVariant] = useState<'default' | 'variants'>('default')

  const renderScreen = () => {
    switch (activeTab) {
      case 'home':
        return <HomeScreen />
      case 'send':
        return <SendScreen />
      case 'favorites':
        return <FavoritesScreen />
      case 'profile':
        return <ProfileScreen />
    }
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="p-4 pt-12 border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-40">
        <div className="max-w-md mx-auto">
          <h1 className="text-2xl font-bold mb-2">Glow Menu Showcase</h1>
          <p className="text-muted-foreground text-sm mb-4">
            Interactive demonstration of the new bottom navigation with glow effects
          </p>
          
          {/* Variant Toggle */}
          <div className="flex gap-2">
            <Button
              variant={currentVariant === 'default' ? 'default' : 'outline'}
              size="sm"
              onClick={() => setCurrentVariant('default')}
            >
              Default Menu
            </Button>
            <Button
              variant={currentVariant === 'variants' ? 'default' : 'outline'}
              size="sm"
              onClick={() => setCurrentVariant('variants')}
            >
              Variant Examples
            </Button>
          </div>
        </div>
      </div>

      {/* Screen Content */}
      <div className="pb-20">
        {currentVariant === 'default' ? (
          renderScreen()
        ) : (
          <VariantExamples activeTab={activeTab} onTabChange={setActiveTab} />
        )}
      </div>

      {/* Bottom Navigation */}
      {currentVariant === 'default' ? (
        <GlowMenu
          activeTab={activeTab}
          onTabChange={setActiveTab}
          locale="en"
        />
      ) : (
        <GlowMenuVariants
          activeTab={activeTab}
          onTabChange={setActiveTab}
          locale="en"
          variant="default"
        />
      )}
    </div>
  )
}

function VariantExamples({ 
  activeTab, 
  onTabChange 
}: { 
  activeTab: 'home' | 'send' | 'favorites' | 'profile'
  onTabChange: (tab: 'home' | 'send' | 'favorites' | 'profile') => void 
}) {
  return (
    <div className="p-4 space-y-6">
      <div className="max-w-md mx-auto space-y-6">
        {/* Design Specifications */}
        <Card className="p-6">
          <h2 className="text-lg font-semibold mb-4">Design Specifications</h2>
          <div className="space-y-3 text-sm">
            <div className="flex justify-between">
              <span className="text-muted-foreground">Touch Target:</span>
              <Badge variant="secondary">≥44px</Badge>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Corner Radius:</span>
              <Badge variant="secondary">16-20px</Badge>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Icon Size:</span>
              <Badge variant="secondary">20-24px</Badge>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Label Size:</span>
              <Badge variant="secondary">12-14px</Badge>
            </div>
            <div className="flex justify-between">
              <span className="text-muted-foreground">Gradient:</span>
              <Badge variant="secondary">#3B82F6 → #8B5CF6</Badge>
            </div>
          </div>
        </Card>

        {/* Interactive States */}
        <Card className="p-6">
          <h2 className="text-lg font-semibold mb-4">Interactive States</h2>
          <div className="space-y-3">
            <div className="flex items-center justify-between p-3 rounded-lg bg-muted/50">
              <span className="text-sm">Default State</span>
              <div className="w-3 h-3 rounded-full bg-muted-foreground"></div>
            </div>
            <div className="flex items-center justify-between p-3 rounded-lg bg-blue-50 dark:bg-blue-950/20 border border-blue-200 dark:border-blue-800">
              <span className="text-sm">Active State</span>
              <div className="w-3 h-3 rounded-full bg-gradient-to-r from-blue-500 to-purple-600"></div>
            </div>
            <div className="flex items-center justify-between p-3 rounded-lg bg-accent/50">
              <span className="text-sm">Hover/Press</span>
              <div className="w-3 h-3 rounded-full bg-accent-foreground/60"></div>
            </div>
          </div>
        </Card>

        {/* Accessibility */}
        <Card className="p-6">
          <h2 className="text-lg font-semibold mb-4">Accessibility Features</h2>
          <div className="space-y-2 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-green-500"></div>
              <span>Contrast ratio ≥4.5:1 in all themes</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-green-500"></div>
              <span>Touch targets meet 44px minimum</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-green-500"></div>
              <span>Screen reader compatible labels</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-green-500"></div>
              <span>Reduced motion support</span>
            </div>
          </div>
        </Card>

        {/* Current Selection */}
        <Card className="p-6 bg-gradient-to-br from-blue-50 to-purple-50 dark:from-blue-950/20 dark:to-purple-950/20 border-blue-200 dark:border-blue-800">
          <h2 className="text-lg font-semibold mb-2">Currently Selected</h2>
          <p className="text-2xl font-bold capitalize">{activeTab}</p>
          <p className="text-sm text-muted-foreground mt-1">
            Tap any tab below to see the glow effect in action
          </p>
        </Card>
      </div>
    </div>
  )
}