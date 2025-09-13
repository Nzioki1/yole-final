---
prd_version: 0.1.0
design_bundle: "Yole Final.zip"
design_sha256: "d6f50cb024cb2de49a7e41404e504a04d2b8b51189a8bc2e4b7d8bf33c8b49d9"
api_collection: "Yole.postman_collection.json"
api_sha256: "135420f8b630d51af6cd29b566099ab18c6926c1060d17f72425b20de8406fca"
owners: ["Product: You", "Engineering: You/Team"]
reviewers: ["Design Lead", "QA Lead", "Security"]
last_updated: "2025-09-11"
status: "MVP in build"
---

# YOLE — Money Transfer App (MVP)
## Product Requirements Document (PRD)

## 1) Summary & Vision
**Yole** lets users send **USD** from anywhere to recipients in **DR Congo (CD)**. Yole **does not hold a wallet**. Instead it:
1) shows what the sender must pay (amount + Yole fee),
2) takes payment via a partner checkout (**Card** or **M-Pesa**),
3) shows what the recipient will receive **in USD**.

**New users** must register, complete **KYC**, and **verify email (required)** before sending.  
**Returning users** land on a Dashboard with recent transactions and **Favorites** for fast repeat sends.

---

## 2) In-Scope / Out-of-Scope
**In-Scope (MVP)**
- 4-step send flow: **Send Money → Enter Amount → Review → Success**
- Fee/charges breakdown: **You send (USD)** / **Yole fee (USD)** / **They receive (USD)**
- Payments via **Pesapal v3** (Card & M-Pesa) using a redirect/WebView flow
- Auth (register/login/refresh/logout), **KYC**, **email verification (required)**
- **Dark & Light** UI parity using the pinned design bundle
- Server-synced **Favorites**; quick **Repeat** from history/detail

**Out-of-Scope (MVP)**
- In-app wallet balances
- Non-USD receive currencies
- Advanced recipient verification beyond name/phone

---

## 3) Personas
- **Sender Sam** — Sends small/medium USD amounts to DR Congo; prioritizes clarity and speed.
- **Returning Rhea** — Sends regularly; expects a ~30-second repeat flow.
- **Compliance Chloe** (internal) — Requires audit-ready KYC and transaction logs.

---

## 4) Platforms & Theme Modes
- **Flutter** (iOS & Android)
- **Theme Modes:** **Dark** and **Light** (both required)
- **Motion:** iOS-style press (scale ≈ 0.97, opacity ≈ 0.95, 120 ms, light haptic)

---

## 5) Design Source of Truth (Pinned)
**Artifact:** `Yole Final.zip` (see `design/`)  
**Hash:** `d6f50cb024cb2de49a7e41404e504a04d2b8b51189a8bc2e4b7d8bf33c8b49d9`  
**Contains:** tokens (`src/styles/globals.css`, `src/index.css`), UI atoms/molecules (`src/components/ui/*`), screen blueprints (`src/components/screens/*`)

### 5.1 Normative Token Mapping → Flutter
Implement once; **ban hardcoded styles** in screens.

**ColorScheme (Light)**  
- `primary` ← `--primary`  
- `background` ← `--background`  
- `surface` ← `--card`  
- `onSurface` ← `--foreground`  
- `surfaceVariant` ← input/chip background  
- `onSurfaceVariant` ← `--muted-foreground`  
- `outline` ← `--border` (use ~20–30% opacity for 1px hairlines)  
- `error` ← `--destructive`  
- **ThemeExtensions:**  
  - `success` ← `--success`  
  - `primaryGradient` ← `--primary-gradient-start` → `--primary-gradient-end`

**ColorScheme (Dark)**  
Same mapping from the bundle's `.dark` tokens.

**Spacing / Radius (ThemeExtensions)**  
- Spacing: `4, 8, 12, 16, 24, 32` (xs…2xl)  
- Radius: `8, 12, 16, 20`, plus `pill` for CTAs

**Typography (TextTheme)**  
- `headlineMedium` ~ 24/700; `titleLarge` ~ 20/700  
- `bodyLarge` ~ 16/500; `bodyMedium` ~ 14/500; `labelLarge` ~ 16/700

**UI Patterns (must-do)**  
- **Primary button:** gradient (token start→end), **56dp** height, **20dp** radius  
- **Cards/inputs:** `surface` bg, **1px** `outline` at ~25% opacity, **16dp** radius  
- **Press feedback:** reusable `Pressable` wrapper (scale 0.97, opacity 0.95, 120 ms + light haptic)

**Design Acceptance (both modes)**  
- No `Color(...)`, inline `TextStyle(...)`, or magic `EdgeInsets(...)` in screens  
- Primary CTA gradient, card borders, inputs, spacing and radii match bundle  
- AA contrast verified

### 5.2 Token Catalog

#### Schema v1.1 (UI tokens for Home + Transaction Detail)
- **Status tokens** (new under `tokens.components.status`):
  - pending/completed/failed/reversed each define: fg, bg.light, bg.dark, radius, height, paddingX
- **Transaction item tokens** (new under `tokens.components.transactionItem`):
  - paddingX:16, paddingY:14, avatarSize:40, gap:12
- **Favorites rail**: uses `card` + global spacing (no dedicated tokens)
- **Search**: uses `components.input` with a leading icon (no dedicated tokens)
- **Greeting**: uses `headlineMedium` (24/700)
- **Router**: `/transaction/:id` is a full-screen route

---

## 6) Core User Journeys

### 6.1 New User → First Send
1. **Register** (email, name, surname, password, country)
2. **Send SMS OTP** for phone ownership (if applicable)
3. **KYC** (phone + OTP + ID number + ID/passport photo[s])
4. **Email verification — required** (gate sending; "Resend" available)
5. **Login** (access/refresh tokens) → Dashboard

### 6.2 Returning User
- **Dashboard** → recent transactions & Favorites
- **Repeat** a past transaction (prefill recipient & amount)
- **Send to Favorite** in two taps

### 6.3 Send Flow (4 Screens)
1) **Send Money** — pick recipient (Favorites/search/phone)  
2) **Enter Amount (USD)** — fetch **charges** + **Yole fee**, compute **They receive (USD)**  
3) **Review** — confirm recipient + full fee breakdown; select payment method  
4) **Confirm & Pay** — Pesapal WebView; on return, fetch status; show **Success** or **Failure** (retry/change method)

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
- Corridor: **USD → USD**; recipient country **CD**  
- **Email verification is required**; block "Confirm & Send" until verified  
- **KYC** must be complete  
- **Favorites are server-synced** (CRUD); hydrate on login  
- Quotes: refresh/invalidate after a short TTL (e.g., 5–10 min)  
- Currency display: 2 decimals, group separators, explicit currency labels ("USD", "KES" when referenced)

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
- `POST /api/charges` — base charges (amount, currency=USD, recipient_country=CD)
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

## 10) Screens & States (Dark **and** Light required)

### Auth & KYC
- **Welcome** (optional), **Register**, **Email verification required** (Resend), **Login**, **Forgot password** (request & success)
- **KYC**: phone → **OTP** → **ID capture** (front/back or passport) → selfie (if later needed)  
  States: success, error/retry

### Dashboard
- Greeting; **Recent transactions**; **Repeat** actions; **Favorites** rail/list; **Search**
- **Transaction detail**: status timeline, amounts, recipient, `order_tracking_id`, "Refresh status", "Repeat"

### Send Flow (4 screens + payment states)
1. **Send Money** (recipient picker / favorites / address book)  
2. **Enter Amount (USD)** (quote loading + error states; link to T&Cs/fees)  
3. **Review** (full breakdown; disabled CTA until KYC + email verified)  
4. **Confirm & Pay** → **Pesapal WebView** container (spinner, cancel/back)  
5. **Payment pending** (post-redirect while status resolves)  
6. **Success** / **Failure** (retry / change method)

### Profile & Settings
- Profile summary; **Theme** (Dark/Light/System); **Biometric** toggle; Change password; Terms; Privacy; Support; Logout

### Compliance & Limits
- **Per-txn limit reached** (KES 250k) banner/screen with guidance  
- **Daily cap reached** (KES 500k) banner/screen with reset countdown

### Global
- Offline & partner-down banners; empty states (no transactions, no favorites, no search results); skeleton loaders

**Missing mockups to add to design bundle**
- Pesapal **WebView container**, **Payment Pending**, **Payment Failed**  
- **Transaction detail** screen  
- Empty states (transactions, favorites, search)  
- Global banners (offline/partner down)  
- Cap-reached screens (per-txn & daily)

---

## 11) Client Data & Storage
**Secure local storage:** access/refresh tokens, theme preference (system/dark/light), biometric opt-in  
**Models:**
- `User { id, name, surname, email, country, emailVerified }`
- `RecipientFavorite { id, name, phone, countryCode }`
- `Transaction { id, createdAt, recipientName, recipientPhone, sendingAmountUSD, feeUSD, receiveAmountUSD, status, trackingId }`
- `Quote { amountUSD, feeUSD, totalUSD, receiveUSD, expiresAt }`

**Derived state:**  
- M-Pesa daily sum tracker (client-side UX; authoritative validation server-side)

---

## 12) Business Logic & Validation
- **Email must be verified** and **KYC complete** before enabling **Confirm & Send**
- **M-Pesa caps:** block if payable KES would exceed **250,000/txn** or **500,000/day**
- Quotes expire after TTL → show "Quote expired, refresh"
- Phone numbers normalized to **E.164**
- Final transaction state is from **Pesapal GetTransactionStatus** (not callback text)

---

## 13) Non-Functional Requirements
- **Performance:** quote response < **1.5 s** p95; order submit < **2.5 s** p95 (excluding external checkout)
- **Reliability:** retries with backoff for quote & status; graceful WebView cancellation
- **Security:** TLS; secure token storage; no PII in logs; jailbreak/root checks; **no card data** stored
- **Accessibility:** AA contrast in **both** modes; 44×44 tap targets; dynamic type support
- **Localization:** explicit currency labels; locale-aware date/time
- **Observability:** Crashlytics/Sentry; client event logs for quotes, sends, status transitions

---

## 14) Analytics (Client Events)
`auth_register_success`, `auth_login_success`, `kyc_submitted`, `email_verification_sent`, `email_verified`,  
`quote_requested`, `quote_received`, `quote_failed`,  
`send_initiated`, `payment_method_selected(card|mpesa)`, `send_confirmed`, `send_success`, `send_failed`,  
`status_refresh_clicked`, `repeat_send_clicked`, `favorite_send_clicked`,  
`toggle_dark_mode`, `toggle_light_mode`, `toggle_biometrics`.

---

## 15) Acceptance Criteria
- Users can **register → KYC → verify email → login** and complete a send to DR Congo
- **Card & M-Pesa** sandbox flow works end-to-end: Auth → SubmitOrder → Redirect → Callback/IPN → **GetTransactionStatus**
- M-Pesa **KES 250k/txn** and **KES 500k/day** enforced with clear errors
- **Favorites server-synced**; repeat send works from Dashboard & Detail
- **Dark & Light** themes match the design bundle; iOS-style press animations present
- All protected Yole API calls use **Bearer + X-API-Key**; no secrets in app bundle

---

## 16) Release Plan
- **Phase 1 (MVP):** Auth + KYC + **Email verification (required)** + Dashboard + Send flow + Pesapal integration + Profile (dark/light/biometrics)
- **Phase 2:** Full Favorites CRUD (if partial in P1), notifications, richer receipt view, multi-corridor prep
- **Phase 3:** Referrals, promotions, advanced compliance flows

---

## 17) Open Items (to confirm)
- Final copy for limit-reached & error banners
- Quote TTL and refresh policy
- Exact Favorites CRUD (server endpoints if not present)
- Support/Contact details for Profile screen

---

### Appendix A — Flutter Theming & Components
- Implement `AppTheme.light()` / `AppTheme.dark()` from tokens; add `ThemeExtension`s for Spacing/Radius/Success/Gradient
- Reusable UI atoms:
  - `Pressable` (scale/opacity/haptic)
  - `GradientButton` (56dp, pill 20dp)
  - Cards/list tiles with border (outline @ ~25% opacity), radius 16dp
- **No hardcoded** colors, text styles, or paddings in screens

### Appendix B — Route Map (example)/splash
/welcome
/register
/login
/verify-email
/kyc/phone
/kyc/otp
/kyc/id
/kyc/selfie (optional placeholder)
/home
/transaction/:id
/send
/send/recipient
/send/amount
/send/review
/send/pay (Pesapal WebView)
/send/success
/send/failure
/profile
/profile/settings
/profile/security


### Appendix C — Pesapal Sandbox Checklist
- ENV: `PESAPAL_CONSUMER_KEY`, `PESAPAL_CONSUMER_SECRET`, `PESAPAL_CALLBACK_URL`, `PESAPAL_IPN_URL`  
- Boot: request token; refresh every ~3–4 min while needed  
- One-time: Register **IPN** → persist `ipn_id`  
- Send: Submit Order → open **redirect_url** in WebView  
- Return: On **callback** or **IPN**, call **GetTransactionStatus**  
- Update: Mark transaction **COMPLETED/FAILED/REVERSED**; store `confirmation_code`

### Appendix D — Test Plan (high-value)
- Register → KYC → Email verification gating  
- Quote success; quote error; quote TTL expiry refresh  
- M-Pesa caps: 250k breach (per-txn) & 500k daily breach  
- Pesapal happy path (Card, M-Pesa); user cancels in WebView  
- Callback fires but status still PENDING → polling → COMPLETED  
- Network loss mid-checkout → resume & reconcile  
- Favorites sync on login; repeat send from history

---

## Change Control
- Any change to design bundle ⇒ **update `design_sha256`** and **design-lock tokens**, regenerate Flutter tokens, re-verify Light & Dark parity.
- Any API/payload changes ⇒ update PRD/API hash, adjust repos/clients, add migration notes to **CHANGELOG**.
