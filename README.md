# KaamSetu

KaamSetu is a hyperlocal blue-collar job marketplace designed to bridge the gap between households/local businesses and verified workers in real-time. By leveraging a lightning-fast onboarding process, multilingual support, and a robust trust system, KaamSetu makes finding the right match easier, faster, and safer than ever before.

## 🌟 Key Features

*   **Role-Based Experience**: Dedicated user flows for **Workers** (finding jobs, building a profile, managing earnings) and **Households/Employers** (posting jobs, browsing nearby workers, hiring).
*   **Frictionless Onboarding**: A blazing fast 5-step registration process (Language ➔ Role ➔ Phone ➔ OTP ➔ Name) gets users into the app in seconds. Deep profile completion (Location, Skills, Availability) is deferred until the user is ready.
*   **Secure KYC & Trust Score**: A beautiful, fluid Aadhar-based identity verification system. Verified workers get a trust badge, boosting their visibility and match rate.
*   **Multilingual Support**: Built-in internationalization (i18n) allows users to navigate the app in their preferred local language (English, Hindi, etc.).
*   **Real-Time Chat & Inbox**: Integrated messaging with swipe-to-archive functionality, allowing employers and workers to negotiate and coordinate instantly.
*   **Dynamic UI & Glassmorphism**: Premium design aesthetics featuring glassmorphic navigation bars, shimmer loading effects, and fluid animations using `flutter_animate`.

## 🛠️ Tech Stack

*   **Frontend**: Flutter (Dart)
*   **State Management**: Riverpod
*   **Styling**: Custom Theme Engine + Google Fonts
*   **Backend**: Node.js / Express (Available in the `/backend` directory)

## 🚀 Getting Started

### Prerequisites
*   Flutter SDK (v3.19+ recommended)
*   Dart SDK
*   Android Studio / Xcode for emulation

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/NipunJain-Git/Task.git
    cd Task
    ```

2.  **Navigate to the Flutter project**
    ```bash
    cd kaamsetu_flutter
    ```

3.  **Install dependencies**
    ```bash
    flutter pub get
    ```

4.  **Run the application**
    ```bash
    flutter run
    ```

## 📱 Project Structure

The frontend application (`/kaamsetu_flutter`) is organized by feature:
*   `lib/screens/auth`: Login, OTP, Role Selection, and Onboarding wizard.
*   `lib/screens/home`: The main dashboard for both Workers and Households.
*   `lib/screens/jobs`: Job feed, job details, and "Post a Job" functionality.
*   `lib/screens/kyc`: Identity verification and Aadhar input UI.
*   `lib/screens/shared`: Common screens like Profile, Chat, and the main Navigation Shell.
*   `lib/providers`: Riverpod state management and mock API integrations.
*   `lib/core`: Theming, Typography, and i18n configurations.

## 🎨 UI/UX Highlights

*   **KYC Verification**: A fluid, animated Aadhar input screen that automatically verifies 12-digit IDs with a beautiful scale-in success state.
*   **Worker Profiles**: Highlighted "Complete Profile" banners utilizing vibrant gradients to encourage workers to add their skills and location.
*   **Bottom Navigation**: A premium glassmorphic frosted-glass effect applied to the main navigation shell.
