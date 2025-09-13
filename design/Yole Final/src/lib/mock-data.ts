// Mock data and services for the remittance app

export interface User {
  id: string
  firstName: string
  lastName: string
  email: string
  phone: string
  kycStatus: 'pending' | 'approved' | 'rejected'
  balance: {
    USD: number
    EUR: number
  }
}

export interface Recipient {
  id: string
  firstName: string
  lastName: string
  phone: string
  network: 'airtel' | 'vodacom' | 'orange'
  isFavorite: boolean
}

export interface Transaction {
  id: string
  recipientId: string
  recipient: Recipient
  amount: {
    sent: number
    sentCurrency: string
    received: number
    receivedCurrency: string
  }
  fees: number
  exchangeRate: number
  status: 'delivered' | 'processing' | 'failed' | 'pending'
  date: string
  timestamp: string
  estimatedArrival?: string
}

export interface ExchangeRate {
  from: string
  to: string
  rate: number
  lastUpdated: string
}

// Mock user
export const mockUser: User = {
  id: '1',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john.doe@example.com',
  phone: '+1234567890',
  kycStatus: 'approved',
  balance: {
    USD: 1250.75,
    EUR: 890.50
  }
}

// Mock recipients
export const mockRecipients: Recipient[] = [
  {
    id: '1',
    firstName: 'Marie',
    lastName: 'Kabila',
    phone: '+243812345678',
    network: 'airtel',
    isFavorite: true
  },
  {
    id: '2',
    firstName: 'Joseph',
    lastName: 'Mumba',
    phone: '+243998765432',
    network: 'vodacom',
    isFavorite: true
  },
  {
    id: '3',
    firstName: 'Grace',
    lastName: 'Tshisekedi',
    phone: '+243823456789',
    network: 'orange',
    isFavorite: false
  }
]

// Mock transactions
export const mockTransactions: Transaction[] = [
  {
    id: '1',
    recipientId: '1',
    recipient: mockRecipients[0],
    amount: {
      sent: 100,
      sentCurrency: 'USD',
      received: 259300,
      receivedCurrency: 'CDF'
    },
    fees: 2.5,
    exchangeRate: 2593.00,
    status: 'delivered',
    date: '2025-01-10T14:30:00Z',
    timestamp: '2025-01-10T14:30:00Z'
  },
  {
    id: '2',
    recipientId: '2',
    recipient: mockRecipients[1],
    amount: {
      sent: 50,
      sentCurrency: 'EUR',
      received: 129650,
      receivedCurrency: 'CDF'
    },
    fees: 1.5,
    exchangeRate: 2593.00,
    status: 'processing',
    date: '2025-01-10T10:15:00Z',
    timestamp: '2025-01-10T10:15:00Z',
    estimatedArrival: '2025-01-10T16:00:00Z'
  },
  {
    id: '3',
    recipientId: '3',
    recipient: mockRecipients[2],
    amount: {
      sent: 200,
      sentCurrency: 'USD',
      received: 518600,
      receivedCurrency: 'CDF'
    },
    fees: 4.0,
    exchangeRate: 2593.00,
    status: 'failed',
    date: '2025-01-09T16:45:00Z',
    timestamp: '2025-01-09T16:45:00Z'
  }
]

// Mock exchange rates
export const mockExchangeRates: ExchangeRate[] = [
  {
    from: 'USD',
    to: 'CDF',
    rate: 2593.00,
    lastUpdated: '2025-01-10T15:00:00Z'
  },
  {
    from: 'EUR',
    to: 'CDF',
    rate: 2593.00, // Simplified - same rate for demo
    lastUpdated: '2025-01-10T15:00:00Z'
  }
]

// Network logos/colors
export const networkInfo = {
  airtel: {
    name: 'Airtel',
    color: '#FF0000',
    logo: '📶' // Using emoji for demo
  },
  vodacom: {
    name: 'Vodacom',
    color: '#E60000',
    logo: '📱'
  },
  orange: {
    name: 'Orange',
    color: '#FF6600',
    logo: '📳'
  }
}

// Mock services
export const mockServices = {
  // Calculate fees (2% capped between $1-50)
  calculateFees: (amount: number, currency: string): number => {
    const feePercent = 0.02 // 2%
    const fee = amount * feePercent
    
    // Cap between $1-50 equivalent
    const minFee = currency === 'USD' ? 1 : currency === 'EUR' ? 0.85 : 2593
    const maxFee = currency === 'USD' ? 50 : currency === 'EUR' ? 42.5 : 129650
    
    return Math.min(Math.max(fee, minFee), maxFee)
  },

  // Get exchange rate
  getExchangeRate: (from: string, to: string): number => {
    const rate = mockExchangeRates.find(r => r.from === from && r.to === to)
    return rate?.rate || 1
  },

  // Convert amount
  convertAmount: (amount: number, from: string, to: string): number => {
    const rate = mockServices.getExchangeRate(from, to)
    return amount * rate
  },

  // Validate DRC phone number
  validateDRCPhone: (phone: string): { isValid: boolean; network?: string } => {
    // Remove country code and spaces
    const cleaned = phone.replace(/^\+243|^243/, '').replace(/\s/g, '')
    
    // Check Airtel: 81, 82, 83, 84, 85, 86, 87, 88, 89
    if (/^8[1-9]\d{7}$/.test(cleaned)) {
      return { isValid: true, network: 'airtel' }
    }
    
    // Check Vodacom: 99, 98, 97, 96, 95, 94, 93, 92, 91, 90
    if (/^9[0-9]\d{7}$/.test(cleaned)) {
      return { isValid: true, network: 'vodacom' }
    }
    
    // Check Orange: 80
    if (/^80\d{7}$/.test(cleaned)) {
      return { isValid: true, network: 'orange' }
    }
    
    return { isValid: false }
  }
}