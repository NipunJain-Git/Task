# KaamSetu — Project Requirements Document (PRD)

## 1. Overview

**KaamSetu** (कामसेतु — "Bridge to Work") is a hyperlocal mobile application that connects **daily-wage workers** (painters, plumbers, cleaners, electricians, helpers, etc.) with **households** looking for short-term / one-day services. The app acts as a digital bridge — making it effortless for workers to find nearby gigs and for households to hire trusted, rated local workers.

---

## 2. Problem Statement

| Pain Point | Who Feels It |
|---|---|
| Workers stand at road junctions ("labour chowks") waiting for work with no guarantee of getting hired. | Workers |
| Households rely on word-of-mouth or middlemen, leading to delays and trust issues. | Households |
| No transparent rating or accountability system exists for either party. | Both |
| Workers have no digital presence — no profile, no reviews, no way to showcase skills. | Workers |

KaamSetu solves these problems by providing a simple, mobile-first platform that requires **minimal digital literacy** to operate.

---

## 3. Target Users

### 3.1 Workers (Job Seekers)
- Daily-wage labourers: painters, plumbers, electricians, cleaners, carpenters, gardeners, helpers, cooks, etc.
- Age range: 18–60 years.
- Primarily use **Android smartphones** with low-to-mid-range specs.
- May have **limited English proficiency** — Hindi / regional language support is critical.
- Comfortable with **WhatsApp-style UIs** (simple, icon-driven).

### 3.2 Households (Job Posters)
- Urban and semi-urban families needing short-term help.
- Age range: 25–55 years.
- Comfortable with smartphone apps.
- Value **trust, speed, and convenience**.

---

## 4. Core Features

### 4.1 Authentication & Onboarding
| Feature | Details |
|---|---|
| Phone-based OTP Login | Workers and households register/login using mobile number + OTP. No email required. |
| Role Selection | Users choose their role: **Worker** or **Household** during onboarding. |
| Guided Onboarding | A simple 3-step onboarding wizard collects essential profile info. |

### 4.2 Worker Profile
| Feature | Details |
|---|---|
| Skill Tags | Workers select from predefined skill categories (e.g., Painting, Plumbing, Cleaning). |
| Expected Wage | Workers set their expected daily / hourly wage. |
| Availability Toggle | A simple ON/OFF toggle — "Available for work today". |
| Profile Photo | Optional profile photo for trust building. |
| Location | Workers set their preferred work radius (e.g., within 5 km). |
| Ratings & Reviews | Aggregate 👍/👎 rating visible on the profile. |

### 4.3 Job Posting (Households)
| Feature | Details |
|---|---|
| Post a Job | Households create a one-day job with: job title, description, skill category, date, time, location, and budget. |
| Location Picker | Map-based or address-based location input. |
| Budget Range | Fixed amount or negotiable range. |
| Job Status | `Open` → `Assigned` → `In Progress` → `Completed` → `Rated`. |

### 4.4 Job Discovery (Workers)
| Feature | Details |
|---|---|
| Browse Nearby Jobs | Workers see a feed of jobs near their location, filtered by skill match. |
| Express Interest | Workers tap "I'm Interested" on a job. Multiple workers can express interest. |
| Job Details View | Full details of the job including map, budget, and household rating. |

### 4.5 Worker Selection (Households)
| Feature | Details |
|---|---|
| View Interested Workers | Households see a list of workers who expressed interest, along with their profiles and ratings. |
| Select Worker | Households pick one worker and confirm the hire. |
| Notification to Worker | The selected worker receives a push notification + in-app alert. |

### 4.6 Job Lifecycle & Completion
| Feature | Details |
|---|---|
| Job Start Confirmation | Both parties confirm the job has started (optional). |
| Mark as Complete | Either party can mark the job as "Completed". |
| Mutual Rating | After completion, both worker and household rate each other with 👍 or 👎 and an optional short comment. |

### 4.7 Ratings & Trust
| Feature | Details |
|---|---|
| Simple Rating | 👍 (Thumbs Up) / 👎 (Thumbs Down) — no complex star system. |
| Trust Score | Derived from the ratio of 👍 to total ratings. Displayed as a percentage (e.g., "92% positive"). |
| Optional Comment | A short text comment (max 150 characters) with each rating. |

### 4.8 Notifications
| Feature | Details |
|---|---|
| Push Notifications | For new matching jobs, interest received, worker selected, job completion, and rating reminders. |
| In-App Notifications | A notification bell with an unread count. |

---

## 5. Non-Functional Requirements

| Requirement | Target |
|---|---|
| **Performance** | App should load in under 3 seconds on a mid-range Android device over 4G. |
| **Offline Resilience** | Graceful degradation when network is weak — queue actions and sync when online. |
| **Language** | Hindi + English (bilingual UI). Regional languages can be added later. |
| **Accessibility** | Large tap targets (48dp+), high-contrast text, icon-driven UI. |
| **Security** | OTP-based auth, encrypted data in transit (HTTPS), no passwords stored. |
| **Scalability** | Architecture should support scaling to 100K+ users per city. |
| **Data Privacy** | Phone numbers are not directly shared — in-app contact only until job is confirmed. |

---

## 6. Out of Scope (v1)

The following features are **intentionally excluded** from the first release to maintain focus:

- In-app payments / wallet integration
- Chat/messaging between worker and household
- Video profiles or portfolio uploads
- Background verification / KYC
- Multi-city support (v1 focuses on a single city)
- Web version (mobile-only for v1)
- Admin dashboard (basic backend-only moderation)

---

## 7. Success Metrics

| Metric | Target (6 months post-launch) |
|---|---|
| Registered Workers | 10,000+ |
| Registered Households | 5,000+ |
| Jobs Posted / Month | 2,000+ |
| Job Completion Rate | > 70% |
| Average Rating Positivity | > 85% 👍 |
| Worker Retention (monthly active) | > 40% |

---

## 8. User Stories

### Worker
1. *As a worker, I want to create a profile with my skills and expected wages so that households can find me.*
2. *As a worker, I want to toggle my availability so I only see jobs when I'm free.*
3. *As a worker, I want to browse nearby jobs that match my skills so I can find work quickly.*
4. *As a worker, I want to express interest in a job so the household knows I'm available.*
5. *As a worker, I want to be notified when I'm selected for a job so I can confirm and go.*
6. *As a worker, I want to rate the household after completing a job so others know if they're trustworthy.*

### Household
1. *As a household, I want to post a one-day job with budget and location so that nearby workers can find it.*
2. *As a household, I want to see which workers are interested and view their ratings before selecting one.*
3. *As a household, I want to be notified when workers express interest so I can respond quickly.*
4. *As a household, I want to rate the worker after the job is done so others can benefit from my experience.*

---

## 9. Assumptions & Constraints

- Users have Android smartphones (iOS is secondary for v1).
- Users have basic smartphone literacy (can install apps, tap buttons, read large text).
- Location services (GPS) are available and permitted by the user.
- Internet connectivity (3G/4G) is available, though may be intermittent.
- The app is free for both workers and households in v1 (monetization comes later).
