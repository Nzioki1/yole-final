---
prd_version: 0.3.0
design_bundle: "Yole Final.zip"
design_sha256: "d6f50cb024cb2de49a7e41404e504a04d2b8b51189a8bc2e4b7d8bf33c8b49d9"
api_collection: "Yole.postman_collection.json"
api_sha256: "135420f8b630d51af6cd29b566099ab18c6926c1060d17f72425b20de8406fca"
owners: ["Product: You", "Engineering: You/Team"]
reviewers: ["Design Lead", "QA Lead", "Security"]
last_updated: "2025-01-27"
status: "MVP in build"
---

# YOLE — Money Transfer App (MVP)
## Product Requirements Document (PRD)

## 1) Summary & Vision
**Yole** lets users send **USD/EUR** from anywhere to recipients in **DR Congo (CD)**. Yole **does not hold a wallet**. Instead it:
1) shows what the sender must pay (amount + Yole fee),
2) takes payment via a partner checkout (**Card** or **M-Pesa**),
3) shows what the recipient will receive **in USD**.

**New users** must register, complete **KYC**, and **verify email (required)** before sending.  
**Returning users** land on a Dashboard with recent transactions and **Favorites** for fast repeat sends.

---

## 2) In-Scope / Out-of-Scope
**In-Scope (MVP)**
- **Multi-step send flow:** **Welcome → Send Money → Select Recipient → Enter Amount → Review → Success**
- **Multi-currency support:** **USD/EUR** to **USD** transfers
- Fee/charges breakdown: **You send (USD/EUR)** / **Yole fee (USD)** / **They receive (USD)**
- Payments via **Pesapal v3** (Card & M-Pesa) using a redirect/WebView flow
- Auth (register/login/refresh/logout), **KYC**, **email verification (required)**
- **Dark & Light** UI parity using complete design token system
- Server-synced **Favorites**; quick **Repeat** from history/detail
- **M-Pesa limits enforcement** with dedicated screens
- **Transaction detail** with comprehensive status tracking
- **Profile management** with theme switching and biometrics
- **Welcome/Onboarding** with animations and sparkle effects
- **System States Demo** for comprehensive error handling
- **Advanced animations** and micro-interactions

**Out-of-Scope (MVP)**
- In-app wallet balances
- Non-USD receive currencies (beyond USD)
- Advanced recipient verification beyond name/phone

---

## 3) Personas
- **Sender Sam** — Sends small/medium USD/EUR amounts to DR Congo; prioritizes clarity and speed.
- **Returning Rhea** — Sends regularly; expects a ~30-second repeat flow.
- **Compliance Chloe** (internal) — Requires audit-ready KYC and transaction logs.

---

## 4) Platforms & Theme Modes
- **Flutter** (iOS & Android)
- **Theme Modes:** **Dark** and **Light** (both required)
- **Motion:** iOS-style press (scale ≈ 0.97, opacity ≈ 0.95, 120 ms, light haptic)
- **Animations:** Sparkle effects, success animations, loading states, micro-interactions

---

## 5) Design Source of Truth (Pinned)
**Artifact:** `Yole Final.zip` (see `design/`)  
**Hash:** `d6f50cb024cb2de49a7e41404e504a04d2b8b51189a8bc2e4b7d8bf33c8b49d9`  
**Contains:** Complete Figma design system with React/TypeScript components, CSS tokens, and screen mockups

**Design System Structure:**
- `src/styles/globals.css` - Complete CSS design tokens (Light/Dark themes)
- `src/components/ui/` - UI component library (50+ components)
- `src/components/screens/` - Screen mockups and layouts (31 screens)
- `src/components/layout/` - Navigation and layout components
- `tokens.json` - Flutter-compatible design tokens

### 5.1 Complete Design Token System

#### **Color System (Light & Dark)**
**Primary Colors:**
- `primary`: `#3B82F6`
- `primary-foreground`: `#ffffff`
- `primary-gradient-start`: `#3B82F6`
- `primary-gradient-end`: `#8B5CF6`

**Background Colors:**
- `background`: `#ffffff` (Light) / `#19173d` (Dark)
- `foreground`: `#1a1a1a` (Light) / `rgba(255, 255, 255, 0.87)` (Dark)
- `card`: `#ffffff` (Light) / `#19173d` (Dark)
- `card-foreground`: `#1a1a1a` (Light) / `rgba(255, 255, 255, 0.87)` (Dark)

**Secondary Colors:**
- `secondary`: `#f8fafc` (Light) / `#374151` (Dark)
- `secondary-foreground`: `#334155` (Light) / `#f9fafb` (Dark)
- `muted`: `#f1f5f9` (Light) / `#374151` (Dark)
- `muted-foreground`: `#64748b` (Light) / `#9ca3af` (Dark)

**Accent Colors:**
- `accent`: `#f1f5f9` (Light) / `#374151` (Dark)
- `accent-foreground`: `#334155` (Light) / `#f9fafb` (Dark)

**Status Colors:**
- `success`: `#10B981`
- `success-foreground`: `#ffffff`
- `destructive`: `#EF4444`
- `destructive-foreground`: `#ffffff`

**Border & Input Colors:**
- `border`: `rgba(148, 163, 184, 0.3)` (Light) / `rgba(255, 255, 255, 0.5)` (Dark)
- `input`: `transparent`
- `input-background`: `#f8fafc` (Light) / `rgba(255, 255, 255, 0.1)` (Dark)
- `switch-background`: `#e2e8f0` (Light) / `rgba(255, 255, 255, 0.2)` (Dark)

**Chart Colors (5-color palette):**
- `chart-1`: `oklch(0.646 0.222 41.116)` (Light) / `oklch(0.488 0.243 264.376)` (Dark)
- `chart-2`: `oklch(0.6 0.118 184.704)` (Light) / `oklch(0.696 0.17 162.48)` (Dark)
- `chart-3`: `oklch(0.398 0.07 227.392)` (Light) / `oklch(0.769 0.188 70.08)` (Dark)
- `chart-4`: `oklch(0.828 0.189 84.429)` (Light) / `oklch(0.627 0.265 303.9)` (Dark)
- `chart-5`: `oklch(0.769 0.188 70.08)` (Light) / `oklch(0.645 0.246 16.439)` (Dark)

**Sidebar Colors:**
- `sidebar`: `oklch(0.985 0 0)` (Light) / `oklch(0.205 0 0)` (Dark)
- `sidebar-foreground`: `oklch(0.145 0 0)` (Light) / `oklch(0.985 0 0)` (Dark)
- `sidebar-primary`: `#3B82F6` (Light) / `oklch(0.488 0.243 264.376)` (Dark)
- `sidebar-accent`: `oklch(0.97 0 0)` (Light) / `oklch(0.269 0 0)` (Dark)

**Ring & Focus Colors:**
- `ring`: `oklch(0.708 0 0)` (Light) / `oklch(0.439 0 0)` (Dark)

#### **Typography System**
**Font Family:** `Inter`

**Text Styles:**
- `headline-large`: 32px/700/40px
- `headline-medium`: 24px/700/32px
- `headline-small`: 20px/700/28px
- `body-large`: 16px/500/24px
- `body-medium`: 14px/500/20px
- `body-small`: 12px/500/16px
- `label-large`: 16px/700/24px
- `label-medium`: 14px/700/20px
- `label-small`: 12px/700/16px

#### **Spacing System**
- `xs`: 4px
- `sm`: 8px
- `md`: 12px
- `lg`: 16px
- `xl`: 24px
- `xxl`: 32px

#### **Radius System**
- `sm`: 8px
- `md`: 12px
- `lg`: 16px
- `xl`: 20px
- `pill`: 999px

#### **Animation & Interaction System**
- **Press Feedback:** scale 0.97, opacity 0.95, 120ms duration, light haptic
- **Sparkle Effects:** Animated background sparkles for dark theme
- **Success Animations:** Comprehensive success state animations
- **Loading States:** Skeleton loaders, progress indicators, loading overlays
- **Micro-interactions:** Smooth transitions, hover effects, focus states

### 5.2 Component Library (50+ Components)

#### **Basic UI Components**
- `Button` - Standard button with variants (primary, secondary, outline, ghost)
- `GradientButton` - Gradient button with multiple variants and sizes
- `Input` - Text input with focus states and validation
- `Label` - Form labels with proper typography
- `Card` - Container component with elevation and borders
- `Avatar` - User avatar with fallback support
- `Badge` - Status badges and labels
- `Separator` - Visual separators and dividers

#### **Form Components**
- `Checkbox` - Checkbox input with proper styling
- `RadioGroup` - Radio button groups
- `Select` - Dropdown select component
- `Textarea` - Multi-line text input
- `InputOTP` - One-time password input
- `Form` - Form wrapper with validation
- `Slider` - Range slider component
- `Switch` - Toggle switch component

#### **Navigation Components**
- `BottomNavigation` - Main app navigation with glow effects
- `NavigationMenu` - Horizontal navigation menu
- `Tabs` - Tab navigation component
- `Breadcrumb` - Breadcrumb navigation
- `Menubar` - Menu bar component
- `Sidebar` - Sidebar navigation component

#### **Layout Components**
- `GlowMenu` - Animated navigation with glow effects
- `GlowMenuVariants` - Multiple glow menu variants
- `AspectRatio` - Aspect ratio container
- `Resizable` - Resizable panels
- `ScrollArea` - Custom scrollable areas
- `Sheet` - Slide-out panels
- `Drawer` - Drawer component

#### **Feedback Components**
- `Alert` - Alert messages
- `AlertDialog` - Modal alert dialogs
- `StatusChip` - Status indicators with 6 variants (success, error, warning, info, pending, neutral)
- `Progress` - Progress indicators
- `Skeleton` - Loading skeleton components
- `LoadingStates` - Comprehensive loading state components
- `SuccessAnimation` - Success state animations
- `EmptyState` - Empty state components

#### **Data Display Components**
- `Table` - Data tables
- `Calendar` - Calendar component
- `Chart` - Chart components
- `Carousel` - Image/content carousel
- `Pagination` - Pagination controls
- `TransactionCard` - Transaction display cards
- `AmountDisplay` - Currency amount display

#### **Overlay Components**
- `Dialog` - Modal dialogs
- `Popover` - Popover components
- `Tooltip` - Tooltip components
- `HoverCard` - Hover card components
- `ContextMenu` - Context menu
- `DropdownMenu` - Dropdown menus
- `Command` - Command palette
- `Collapsible` - Collapsible content

#### **Specialized Components**
- `NetworkBanner` - Network status banners
- `ErrorBanner` - Error state banners
- `ThemeToggle` - Theme switching component
- `YoleLogo` - Brand logo component
- `Toggle` - Toggle components
- `ToggleGroup` - Toggle button groups
- `Sonner` - Toast notifications

#### **Utility Components**
- `Utils` - Utility functions and helpers
- `UseMobile` - Mobile detection hook
- `ImageWithFallback` - Image with fallback support

---

## 6) Core User Journeys

### 6.1 New User → First Send
1. **Welcome/Onboarding** (with sparkle animations)
2. **Register** (email, name, surname, password, country)
3. **Send SMS OTP** for phone ownership (if applicable)
4. **KYC** (phone + OTP + ID number + ID/passport photo[s])
5. **Email verification — required** (gate sending; "Resend" available)
6. **Login** (access/refresh tokens) → Dashboard

### 6.2 Returning User
- **Dashboard** → recent transactions & Favorites
- **Repeat** a past transaction (prefill recipient & amount)
- **Send to Favorite** in two taps

### 6.3 Comprehensive Send Flow (6+ Steps)
1) **Welcome/Onboarding** — animated introduction with sparkle effects
2) **Send Money** — main send entry point with quick actions
3) **Select Recipient** — pick from Favorites/search/phone with network selection
4) **Enter Amount** — multi-currency support (USD/EUR), fetch charges + Yole fee, compute They receive (USD)
5) **Review & Confirm** — full breakdown with payment method selection
6) **Success** — animated success state with transaction details

---

## 7) Payments — Partner Integration (Pesapal v3, Sandbox)
**Model:** short-lived bearer token (~5 min), partner-hosted **redirect_url** checkout (Card & M-Pesa), app/server **must fetch final status**.  
**Sandbox base:** `https://cybqa.pesapal.com/pesapalv3`

**Flow**
1. **Auth:** `POST /api/Auth/RequestToken` (body: `consumer_key`, `consumer_secret`) → bearer token (~5 min TTL)  
2. **Register IPN:** `POST /api/URLSetup/RegisterIPN` (one-time per URL) → `ipn_id` (`notification_id`)  
3. **Create Order:** `POST /api/Transactions/SubmitOrderRequest`  
   - Payload:  
     `id` (merchant ref, unique), `currency` (ISO), `amount`, `description`,  
     `callback_url` (HTTPS), `notification_id` (from step 2),  
     `billing_address` (at least `phone` or `email`, plus name fields)  
   - Response: `order_tracking_id`, **`redirect_url`** → open in **in-app WebView**  
4. **After payment:** Pesapal calls **Callback URL** & **IPN URL** (IDs only; not final status)  
5. **Get Status:** `GET /api/Transactions/GetTransactionStatus?orderTrackingId=<id>`  
   - Result: `status_code` (1 COMPLETED, 2 FAILED, 3 REVERSED, 0 INVALID), `payment_method`, `amount`, `confirmation_code`, etc.

**WebView UX**
- Show spinner while loading `redirect_url`; top bar "Back to Yole"  
- On navigation to `callback_url`, immediately call **Get Status** → route to success/failure

**M-Pesa Limits (enforce)**
- **KES 250,000 per transaction**  
- **KES 500,000 per day** (aggregate across all sends)  
If user selects M-Pesa, ensure the payable **KES** respects caps before creating the order; block CTA and show a localized inline error if breached.

**Security**
- Do **not** store card data; keep only references (tracking id, confirmation code).  
- Partner credentials must be in secure server/remote config; never hardcoded in app.

---

## 8) Business Rules
- Corridor: **USD/EUR → USD**; recipient country **CD**  
- **Email verification is required**; block "Confirm & Send" until verified  
- **KYC** must be complete  
- **Favorites are server-synced** (CRUD); hydrate on login  
- Quotes: refresh/invalidate after a short TTL (e.g., 5–10 min)  
- Currency display: 2 decimals, group separators, explicit currency labels ("USD", "EUR", "KES" when referenced)
- **Multi-currency support:** USD and EUR as sending currencies
- **Network selection:** Support for multiple network providers in DR Congo

---

## 9) API Contract (Client ↔ Yole) — MVP Surface
**Source:** `Yole.postman_collection.json` (hash: `135420f8b630d51af6cd29b566099ab18c6926c1060d17f72425b20de8406fca`)  
**Headers (protected calls):**  
`Accept: application/x.yole.v1+json`, `X-API-Key: <key>`, `Authorization: Bearer <token>`

**System**
- `GET /api/status` — service health
- `GET /api/countries` — list supported corridors (future expansion)

**Auth & Session**
- `POST /api/register` — create user
- `POST /api/login` — obtain tokens
- `POST /api/refresh-token` — rotate tokens
- `POST /api/logout` — revoke session
- `POST /api/password/forgot?email=` — password reset request

**Verification**
- `POST /api/sms/send-otp` — phone OTP
- `POST /api/validate-kyc` — phone + OTP + ID number + images
- `POST /api/email/verification-notification` — resend verification email

**Fees & Quotes**
- `POST /api/charges` — base charges (amount, currency=USD/EUR, recipient_country=CD)
- `POST /api/yole-charges` — Yole service fee

**Send & Transactions**
- `POST /api/send-money` — create send (sending_amount, recipient_country, phone_number) → returns order/tracking id
- `POST /api/transaction/status` — check by `order_tracking_id`
- `GET /api/transactions` — list user transactions

**Idempotency**
- For `send-money`, pass a unique idempotency key (merchant reference) to safely retry on network errors.

**Error Model**
- JSON response with `code`, `message`, optional `fieldErrors[]` (no stack traces).

---

## 10) Complete Screen Inventory (31 Screens)

### **Onboarding & Welcome**
- **Welcome Screen** - Animated onboarding with sparkle effects and hero image
- **Splash Screen** - Initial loading and authentication check

### **Authentication Flow**
- **Login Screen** - Email/password login with biometric option
- **Register Screen** - User registration with form validation
- **Signup Screen** - Alternative signup flow
- **Email Verification Screen** - Required email verification with resend option
- **Forgot Password Screen** - Password reset request
- **Forgot Password Success Screen** - Password reset confirmation

### **KYC Flow**
- **KYC Screen** - Main KYC entry point
- **KYC Phone Screen** - Phone number verification
- **KYC OTP Screen** - SMS OTP verification
- **KYC ID Capture Screen** - ID document capture (front/back or passport)
- **KYC Selfie Screen** - Selfie capture for verification
- **KYC Success Screen** - KYC completion confirmation
- **KYC Error Screen** - KYC failure and retry options

### **Main Application**
- **Home Dashboard** - Recent transactions, favorites, quick actions
- **Send Screen** - Main send entry point
- **Send Money Flow** - Comprehensive 6-step send flow
- **Favorites Screen** - Saved recipients management with search
- **Profile Screen** - User settings, theme switching, biometrics
- **Transaction Detail Screen** - Comprehensive transaction tracking with status timeline

### **System States & Error Handling**
- **System States Demo Screen** - Comprehensive demo of loading, error, empty, and network states
- **Notifications Screen** - User notifications management

### **Specialized Screens**
- **Code Components** - Various UI component examples and showcases
- **Limits Management** - M-Pesa cap details and enforcement (Not in Design – Pending Decision)

### **Screen States & Variations**
Each screen includes comprehensive state handling:
- **Loading States** - Skeleton loaders, progress indicators
- **Error States** - Error banners, retry mechanisms
- **Empty States** - No data illustrations and actions
- **Success States** - Success animations and confirmations
- **Network States** - Offline/online indicators and recovery

---

## 11) Client Data & Storage
**Secure local storage:** access/refresh tokens, theme preference (system/dark/light), biometric opt-in  
**Models:**
- `User { id, name, surname, email, country, emailVerified }`
- `RecipientFavorite { id, name, phone, countryCode, network }`
- `Transaction { id, createdAt, recipientName, recipientPhone, sendingAmountUSD, feeUSD, receiveAmountUSD, status, trackingId, network }`
- `Quote { amountUSD, feeUSD, totalUSD, receiveUSD, expiresAt, exchangeRate }`

**Derived state:**  
- M-Pesa daily sum tracker (client-side UX; authoritative validation server-side)
- Multi-currency exchange rate tracking
- Network provider preferences

---

## 12) Business Logic & Validation
- **Email must be verified** and **KYC complete** before enabling **Confirm & Send**
- **M-Pesa caps:** block if payable KES would exceed **250,000/txn** or **500,000/day**
- Quotes expire after TTL → show "Quote expired, refresh"
- Phone numbers normalized to **E.164**
- Final transaction state is from **Pesapal GetTransactionStatus** (not callback text)
- **Multi-currency validation:** Support USD and EUR as sending currencies
- **Network selection:** Validate network provider compatibility

---

## 13) Non-Functional Requirements
- **Performance:** quote response < **1.5 s** p95; order submit < **2.5 s** p95 (excluding external checkout)
- **Reliability:** retries with backoff for quote & status; graceful WebView cancellation
- **Security:** TLS; secure token storage; no PII in logs; jailbreak/root checks; **no card data** stored
- **Accessibility:** AA contrast in **both** modes; 44×44 tap targets; dynamic type support
- **Localization:** explicit currency labels; locale-aware date/time
- **Observability:** Crashlytics/Sentry; client event logs for quotes, sends, status transitions
- **Animation Performance:** 60fps animations, smooth transitions, optimized sparkle effects

---

## 14) Analytics (Client Events)
`auth_register_success`, `auth_login_success`, `kyc_submitted`, `email_verification_sent`, `email_verified`,  
`quote_requested`, `quote_received`, `quote_failed`,  
`send_initiated`, `payment_method_selected(card|mpesa)`, `send_confirmed`, `send_success`, `send_failed`,  
`status_refresh_clicked`, `repeat_send_clicked`, `favorite_send_clicked`,  
`toggle_dark_mode`, `toggle_light_mode`, `toggle_biometrics`,
`welcome_screen_viewed`, `sparkle_animation_played`, `system_states_demo_viewed`,
`multi_currency_selected(usd|eur)`, `network_provider_selected`.

---

## 15) Acceptance Criteria
- Users can **welcome → register → KYC → verify email → login** and complete a send to DR Congo
- **Card & M-Pesa** sandbox flow works end-to-end: Auth → SubmitOrder → Redirect → Callback/IPN → **GetTransactionStatus**
- M-Pesa **KES 250k/txn** and **KES 500k/day** enforced with clear errors
- **Favorites server-synced**; repeat send works from Dashboard & Detail
- **Dark & Light** themes match the complete design system; iOS-style press animations present
- All protected Yole API calls use **Bearer + X-API-Key**; no secrets in app bundle
- **Welcome screen** displays with sparkle animations in dark mode
- **System states demo** showcases all loading, error, and empty states
- **Multi-currency support** works for USD and EUR sending currencies
- **50+ UI components** render correctly with proper theming

---

## 16) Release Plan
- **Phase 1 (MVP):** Welcome + Auth + KYC + **Email verification (required)** + Dashboard + Comprehensive Send flow + Pesapal integration + Profile (dark/light/biometrics) + System States
- **Phase 2:** Full Favorites CRUD, notifications, richer receipt view, multi-corridor prep
- **Phase 3:** Referrals, promotions, advanced compliance flows

---

## 17) Open Items (to confirm)
- Final copy for limit-reached & error banners
- Quote TTL and refresh policy
- Exact Favorites CRUD (server endpoints if not present)
- Support/Contact details for Profile screen
- **M-Pesa Limits Screens** - Not in Design – Pending Decision
- **Advanced Notifications** - Not in Design – Pending Decision

---

### Appendix A — Flutter Theming & Components
- Implement `AppTheme.light()` / `AppTheme.dark()` from complete design token system; add `ThemeExtension`s for Spacing/Radius/Success/Gradient/Chart/Sidebar
- Reusable UI atoms:
  - `Pressable` (scale/opacity/haptic)
  - `GradientButton` (56dp, pill 20dp) with multiple variants
  - Cards/list tiles with border (outline @ ~25% opacity), radius 16dp
  - `StatusChip` with 6 variants (success, error, warning, info, pending, neutral)
  - `SparkleLayer` for animated background effects
  - `SuccessAnimation` for success states
  - `LoadingStates` for comprehensive loading experiences
- **No hardcoded** colors, text styles, or paddings in screens

### Appendix B — Complete Route Map
```
/welcome
/splash
/login
/register
/signup
/verify-email
/forgot-password
/forgot-password-success
/kyc
/kyc/phone
/kyc/otp
/kyc/id
/kyc/selfie
/kyc/success
/kyc/error
/home
/send
/send/recipient
/send/amount
/send/review
/send/pay
/send/success
/send/failure
/transaction/:id
/profile
/favorites
/notifications
/system-states-demo
/limits/mpesa (Not in Design – Pending Decision)
```

### Appendix C — Pesapal Sandbox Checklist
- ENV: `PESAPAL_CONSUMER_KEY`, `PESAPAL_CONSUMER_SECRET`, `PESAPAL_CALLBACK_URL`, `PESAPAL_IPN_URL`  
- Boot: request token; refresh every ~3–4 min while needed  
- One-time: Register **IPN** → persist `ipn_id`  
- Send: Submit Order → open **redirect_url** in WebView  
- Return: On **callback** or **IPN**, call **GetTransactionStatus**  
- Update: Mark transaction **COMPLETED/FAILED/REVERSED**; store `confirmation_code`

### Appendix D — Test Plan (high-value)
- Welcome screen with sparkle animations
- Register → KYC → Email verification gating  
- Quote success; quote error; quote TTL expiry refresh  
- M-Pesa caps: 250k breach (per-txn) & 500k daily breach  
- Pesapal happy path (Card, M-Pesa); user cancels in WebView  
- Callback fires but status still PENDING → polling → COMPLETED  
- Network loss mid-checkout → resume & reconcile  
- Favorites sync on login; repeat send from history
- Multi-currency support (USD/EUR)
- System states demo functionality
- All 50+ UI components rendering and theming

---

## Change Control
- Any change to design bundle ⇒ **update `design_sha256`** and **design-lock tokens**, regenerate Flutter tokens, re-verify Light & Dark parity.
- Any API/payload changes ⇒ update PRD/API hash, adjust repos/clients, add migration notes to **CHANGELOG**.