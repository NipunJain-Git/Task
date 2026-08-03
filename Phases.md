# KaamSetu — Development Phases

> The project is broken into **6 incremental phases**. Each phase results in a **working, testable deliverable**. Phases must be completed in order — each one builds on the previous.

---

## Phase Overview

| Phase | Name | Focus | Est. Duration |
|---|---|---|---|
| 1 | Foundation & Auth | Project setup, OTP login, role selection | 1–2 weeks |
| 2 | User Profiles | Worker & household profiles, availability, photo upload | 1–2 weeks |
| 3 | Job Posting & Discovery | Job CRUD, geospatial feed, filters | 2 weeks |
| 4 | Interest & Matching | Express interest, view applicants, select worker | 1–2 weeks |
| 5 | Job Lifecycle & Ratings | Job status flow, completion, 👍/👎 rating system | 1–2 weeks |
| 6 | Notifications & Polish | Push notifications, i18n, UX polish, error handling | 1–2 weeks |

**Total Estimated Duration: 7–12 weeks**

---

## Phase 1: Foundation & Authentication

### Goal
Set up the full project skeleton (Flutter app + Node.js backend) and implement phone-based OTP authentication with role selection.

### Deliverables

#### Backend
- [ ] Initialize Node.js + Express + TypeScript project
- [ ] Set up Prisma with PostgreSQL + initial schema (`User` table)
- [ ] Configure Redis for OTP storage
- [ ] Implement `/api/auth/send-otp` endpoint
- [ ] Implement `/api/auth/verify-otp` endpoint (returns JWT)
- [ ] Implement `/api/auth/refresh` endpoint
- [ ] Add JWT auth middleware
- [ ] Add role-based middleware (worker vs household)
- [ ] Set up global error handler
- [ ] Set up structured logger
- [ ] Create `.env.example` with all required variables

#### Flutter App
- [ ] Initialize Flutter project (`flutter create kaamsetu_app`)
- [ ] Configure `analysis_options.yaml` with strict linting
- [ ] Add all core dependencies to `pubspec.yaml` (Riverpod, GoRouter, Dio, Freezed, etc.)
- [ ] Set up GoRouter with auth redirect guard (AuthStack ↔ MainStack)
- [ ] Set up Riverpod (`ProviderScope` in `main.dart`)
- [ ] Set up Dio client with JWT interceptor (auto-attach token, handle 401 refresh)
- [ ] Create `AuthProvider` (Riverpod) — manages auth state, token storage
- [ ] Create `User` Freezed model with `fromJson`/`toJson`
- [ ] Build **Login Screen** — phone number input with country code
- [ ] Build **OTP Verification Screen** — 6-digit input with auto-focus, countdown timer
- [ ] Build **Role Selection Screen** — Worker / Household cards with illustrations
- [ ] Implement secure token storage via `flutter_secure_storage`
- [ ] Set up app theme (`AppTheme`) — colors, typography, spacing tokens
- [ ] Set up i18n with ARB files (`app_en.arb`, `app_hi.arb`) + `l10n.yaml`
- [ ] Create core widgets: `AppButton`, `AppTextField`, `LoadingOverlay`

### Exit Criteria
✅ A user can enter their phone number, receive an OTP, verify it, select their role, and land on a role-specific home screen (even if it's a placeholder).

---

## Phase 2: User Profiles

### Goal
Enable workers and households to complete their profiles with relevant information.

### Deliverables

#### Backend
- [ ] Add `WorkerProfile` and `HouseholdProfile` tables to Prisma schema
- [ ] Implement `GET /api/users/me` — return full profile with role-specific data
- [ ] Implement `PUT /api/users/me` — update basic info (name, language, location)
- [ ] Implement `PUT /api/users/me/worker-profile` — update skills, wage, availability
- [ ] Implement `PUT /api/users/me/household-profile` — update address
- [ ] Implement `PATCH /api/users/me/availability` — toggle worker availability
- [ ] Implement `POST /api/users/me/photo` — upload profile photo (Cloudinary/S3)
- [ ] Add Zod validators for all profile endpoints

#### Flutter App
- [ ] Create Freezed models: `WorkerProfile`, `HouseholdProfile`
- [ ] Create `ProfileApi` (Dio calls) + `ProfileRepository`
- [ ] Create `ProfileProvider` (Riverpod AsyncNotifier)
- [ ] Build **Onboarding Wizard** — PageView with step indicator
  - Step 1: Name + profile photo (using `image_picker`)
  - Step 2 (Worker): Skill multi-select chips + expected wage input
  - Step 2 (Household): Address text input
  - Step 3: Location permission request (using `geolocator`) + radius slider
- [ ] Build **Worker Profile Screen** (view & edit)
  - Skill tags display (Wrap + Chip widgets)
  - Wage display
  - Availability toggle (prominent `Switch` widget with label)
  - Rating badge (placeholder — connected in Phase 5)
- [ ] Build **Household Profile Screen** (view & edit)
- [ ] Implement **Location Permission** flow using `geolocator`
  - Handle permission denied / permanently denied states
  - Show explanatory dialog before requesting
- [ ] Build reusable widgets: `SkillTag`, `AvatarUploader`, `AvailabilityToggle`, `RatingBadge`

### Exit Criteria
✅ A worker can complete their profile with skills, wage, photo, and availability toggle. A household can set up their profile with name and address. All data persists to the database.

---

## Phase 3: Job Posting & Discovery

### Goal
Allow households to post jobs and workers to browse nearby jobs filtered by skill and location.

### Deliverables

#### Backend
- [ ] Add `Job` table to Prisma schema (with PostGIS `geography` column for location)
- [ ] Implement `POST /api/jobs` — create a job (household only)
- [ ] Implement `GET /api/jobs` — list jobs with filters:
  - `latitude`, `longitude`, `radius` (geo-filter using PostGIS `ST_DWithin`)
  - `category` (skill filter)
  - `date` (job date filter)
  - `status` (default: OPEN)
  - Pagination (`page`, `limit`)
- [ ] Implement `GET /api/jobs/:id` — get job details
- [ ] Implement `DELETE /api/jobs/:id` — cancel a job (household only, if still OPEN)
- [ ] Implement `GET /api/jobs/my-posts` — household's own jobs
- [ ] Add PostGIS spatial index on job location column
- [ ] Add Zod validators for all job endpoints

#### Flutter App
- [ ] Create Freezed models: `Job`, `JobFilter`
- [ ] Create `JobsApi` (Dio calls) + `JobsRepository`
- [ ] Create `JobsProvider` (Riverpod) — paginated job feed with filters
- [ ] Build **Post Job Screen** (household)
  - TextFormField for title & description
  - CategoryPicker (bottom sheet with skill chips)
  - Date picker (`showDatePicker`) & time picker
  - Location input (Google Maps picker via `google_maps_flutter` or address autocomplete)
  - Budget input (fixed or negotiable toggle + amount)
  - Zod-style client validation before submit
- [ ] Build **Job Feed Screen** (worker)
  - `ListView.builder` with `JobCard` widgets
  - Each card: title, category icon, distance, budget, date
  - `RefreshIndicator` for pull-to-refresh
  - Pagination (infinite scroll via `ScrollController`)
  - Empty state: illustration + "No jobs nearby" message
- [ ] Build **Job Detail Screen** (shared)
  - Full job info + map preview (static `GoogleMap` widget)
  - Household name + rating badge
  - "I'm Interested" button (worker view)
  - "View Interested Workers" button (household view — connected in Phase 4)
- [ ] Build **My Posted Jobs Screen** (household)
  - List of own jobs with `StatusBadge` widgets
- [ ] Implement **location-based fetching** — get current location via `geolocator` and pass to API
- [ ] Build reusable widgets: `JobCard`, `CategoryPicker`, `BudgetInput`, `StatusBadge`

### Exit Criteria
✅ A household can post a job with location and budget. A worker can see a feed of nearby jobs matching their skills, view details, and see the "I'm Interested" button (functionality wired in Phase 4).

---

## Phase 4: Interest & Worker Selection

### Goal
Enable workers to express interest in jobs and households to view, compare, and select a worker.

### Deliverables

#### Backend
- [ ] Add `JobInterest` table to Prisma schema
- [ ] Implement `POST /api/jobs/:id/interest` — worker expresses interest
  - Prevent duplicate interest
  - Prevent interest on non-OPEN jobs
- [ ] Implement `GET /api/jobs/:id/interests` — list interested workers (household only)
  - Include worker profile: name, photo, skills, rating, wage
- [ ] Implement `PATCH /api/jobs/:id/interests/:interestId` — accept or reject
  - Accepting one worker auto-rejects all others
  - Job status changes to `ASSIGNED`
- [ ] Implement `GET /api/jobs/my-interests` — worker's applied jobs with status
- [ ] Add business rule: worker can express interest in max 10 open jobs at a time

#### Flutter App
- [ ] Create Freezed model: `JobInterest`
- [ ] Create `JobInterestProvider` (Riverpod)
- [ ] Wire **"I'm Interested" button** on Job Detail Screen
  - Show confirmation dialog (`showDialog`)
  - Optimistic UI update via Riverpod state mutation + error rollback
  - Show "Interest Sent ✓" state with disabled button after expressing interest
- [ ] Build **Interested Workers Screen** (household)
  - `ListView` of `WorkerCard` widgets showing:
    - `CircleAvatar` photo, name, skill chips, rating badge, expected wage
    - "Select" ElevatedButton + "Reject" OutlinedButton
  - Empty state: "No applicants yet" illustration
- [ ] Build **My Applications Screen** (worker)
  - List of jobs the worker applied to
  - `InterestStatusBadge`: Pending ⏳ / Accepted ✅ / Rejected ❌
- [ ] Build reusable widgets: `WorkerCard`, `InterestStatusBadge`
- [ ] Handle edge cases: job already filled, duplicate interest, network errors with `SnackBar` feedback

### Exit Criteria
✅ A worker can express interest in a job. A household can view interested workers with their profiles and ratings, select one worker (auto-rejecting others), and the job moves to `ASSIGNED` status.

---

## Phase 5: Job Lifecycle & Ratings

### Goal
Implement the full job lifecycle (assigned → in progress → completed) and the mutual 👍/👎 rating system.

### Deliverables

#### Backend
- [ ] Add `Rating` table to Prisma schema
- [ ] Implement `PATCH /api/jobs/:id/status` — update job status
  - `ASSIGNED → IN_PROGRESS` (either party)
  - `IN_PROGRESS → COMPLETED` (either party)
  - `OPEN/ASSIGNED → CANCELLED` (household only)
  - Validate state transitions (e.g., can't go from OPEN to COMPLETED)
- [ ] Implement `POST /api/jobs/:id/rate` — submit a rating
  - Only after job is COMPLETED
  - Each party can rate once per job
  - Value: `THUMBS_UP` or `THUMBS_DOWN`
  - Optional comment (max 150 chars)
- [ ] Implement `GET /api/users/:id/ratings` — rating summary
  - Total 👍, total 👎, percentage positive
  - Recent comments
- [ ] Update `WorkerProfile` and `HouseholdProfile` — increment `thumbsUp` / `thumbsDown` counters on rating submission
- [ ] Add business rule: prompt for rating 2 hours after job completion (via notification in Phase 6)

#### Flutter App
- [ ] Create Freezed model: `Rating`, `RatingSummary`
- [ ] Create `RatingsApi` + `RatingsRepository` + `RatingsProvider`
- [ ] Build **Active Job Screen** (shared)
  - Shows current job details
  - Progress stepper widget: `Assigned → In Progress → Completed`
  - "Mark as In Progress" ElevatedButton
  - "Mark as Complete" ElevatedButton
  - Confirmation dialogs for each action
- [ ] Build **Rating Screen** (post-completion)
  - Large animated 👍 / 👎 buttons (with `AnimatedScale` or `HapticFeedback`)
  - `TextFormField` for optional comment (150 char max, character counter)
  - "Submit Rating" button
  - "Skip" TextButton
  - Success animation on submit (e.g., confetti or checkmark)
- [ ] Update **Profile Screens** — show rating summary
  - Trust score widget: "92% positive (45 ratings)"
  - Recent comments list
- [ ] Update **Job Detail Screen** — show household/worker rating
- [ ] Update **WorkerCard** — show trust score badge
- [ ] Handle edge cases: rating already submitted, job cancelled before completion

### Exit Criteria
✅ A job can transition through its full lifecycle: Open → Assigned → In Progress → Completed. Both parties can rate each other with 👍/👎 and an optional comment. Ratings are reflected on user profiles.

---

## Phase 6: Notifications & Polish

### Goal
Add push notifications for all key events, finalize i18n, polish UI/UX, and prepare for production deployment.

### Deliverables

#### Backend
- [ ] Add `Notification` table to Prisma schema
- [ ] Implement `POST /api/notifications/register-token` — store FCM device token
- [ ] Implement `GET /api/notifications` — list user's notifications
- [ ] Implement `PATCH /api/notifications/:id/read` — mark as read
- [ ] Integrate FCM (Firebase Admin SDK) for push notifications
- [ ] Trigger notifications for:
  - New matching job posted near worker (based on skills + location)
  - Worker expressed interest in your job (→ household)
  - You've been selected for a job (→ worker)
  - Job marked as complete (→ both)
  - Rating reminder (2 hours post-completion)
- [ ] Add rate limiting on all public endpoints
- [ ] Final security audit: CORS, helmet.js, input sanitization
- [ ] Create seed script with realistic test data

#### Flutter App
- [ ] Set up `firebase_messaging` for push notification handling
  - Request notification permission
  - Register device token with backend on login
  - Handle **foreground** notifications (show in-app banner via overlay)
  - Handle **background / terminated** notifications (navigate on tap)
- [ ] Build **Notifications Screen**
  - `ListView` of `NotificationTile` widgets with icons, titles, timestamps
  - Unread indicator (bold text + colored dot)
  - `GestureDetector` to navigate to relevant screen (job detail, rating, etc.)
  - `Dismissible` for swipe-to-dismiss
- [ ] Add **notification badge** to `BottomNavigationBar` (using `Badge` widget)
- [ ] Finalize **Hindi translations** — all ARB keys in `app_hi.arb` must have Hindi values
- [ ] UX Polish:
  - `Shimmer` loading placeholders on all data-fetching screens (not `CircularProgressIndicator`)
  - `RefreshIndicator` (pull-to-refresh) on all list screens
  - Empty states with illustrations (`SvgPicture`) for every screen
  - Smooth page transitions via GoRouter `CustomTransitionPage`
  - `HapticFeedback` on key actions (express interest, rate, toggle availability)
  - `Hero` animations on job cards → job detail transitions
- [ ] Error Handling Polish:
  - Network error → persistent `MaterialBanner` "No internet connection"
  - Session expired (401) → Dio interceptor auto-redirects to login
  - Server error → user-friendly `SnackBar` with retry action
- [ ] Build **Settings Screen**
  - Language switcher (Hindi / English) — updates `Locale` and restarts app
  - Notification preferences toggle
  - Logout button with confirmation dialog
  - App version display (from `package_info_plus`)
- [ ] Final accessibility audit:
  - All interactive elements have `Semantics` labels
  - Touch targets ≥ 48dp (`SizedBox` / `ConstrainedBox` on tap areas)
  - Color contrast meets WCAG AA (checked via Flutter DevTools)
  - Test with TalkBack (Android) screen reader

### Exit Criteria
✅ Users receive push notifications for all key events. The app is fully bilingual (Hindi + English). UI is polished with shimmer loaders, empty states, hero animations, and error handling. The app is production-ready for a pilot launch.

---

## Post-Launch Roadmap (Future Phases)

These are **not part of the v1 build** but are planned for future iterations:

| Phase | Feature | Description |
|---|---|---|
| 7 | In-App Chat | Real-time messaging between worker and household after job confirmation |
| 8 | Payments | In-app payment via UPI / wallet integration (Razorpay / PhonePe SDK) |
| 9 | Verification | Aadhaar-based KYC for workers, verified badges |
| 10 | Admin Dashboard | Web-based admin panel for moderation, analytics, and dispute resolution |
| 11 | Multi-City Expansion | City selector, region-based deployment |
| 12 | iOS Launch | iOS App Store submission with platform-specific polish |
| 13 | Worker Portfolio | Photo/video portfolio for workers to showcase past work |
| 14 | Subscription Tier | Premium features for households (priority listing, instant hire) |
