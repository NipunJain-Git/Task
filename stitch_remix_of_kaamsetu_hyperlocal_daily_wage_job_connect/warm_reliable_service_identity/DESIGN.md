---
name: Warm & Reliable Service Identity
colors:
  surface: '#fcf9f8'
  surface-dim: '#dcd9d9'
  surface-bright: '#fcf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f2'
  surface-container: '#f0eded'
  surface-container-high: '#eae7e7'
  surface-container-highest: '#e5e2e1'
  on-surface: '#1b1c1c'
  on-surface-variant: '#41493e'
  inverse-surface: '#303030'
  inverse-on-surface: '#f3f0ef'
  outline: '#717a6d'
  outline-variant: '#c0c9bb'
  surface-tint: '#2a6b2c'
  primary: '#00450d'
  on-primary: '#ffffff'
  primary-container: '#1b5e20'
  on-primary-container: '#90d689'
  inverse-primary: '#91d78a'
  secondary: '#835400'
  on-secondary: '#ffffff'
  secondary-container: '#fcab28'
  on-secondary-container: '#694300'
  tertiary: '#323e36'
  on-tertiary: '#ffffff'
  tertiary-container: '#49554c'
  on-tertiary-container: '#bcc9be'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#acf4a4'
  primary-fixed-dim: '#91d78a'
  on-primary-fixed: '#002203'
  on-primary-fixed-variant: '#0c5216'
  secondary-fixed: '#ffddb5'
  secondary-fixed-dim: '#ffb957'
  on-secondary-fixed: '#2a1800'
  on-secondary-fixed-variant: '#643f00'
  tertiary-fixed: '#d9e6da'
  tertiary-fixed-dim: '#bdcabe'
  on-tertiary-fixed: '#131e17'
  on-tertiary-fixed-variant: '#3e4a41'
  background: '#fcf9f8'
  on-background: '#1b1c1c'
  surface-variant: '#e5e2e1'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 30px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
  button-text:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  touch-target-min: 48px
  margin-mobile: 16px
  margin-desktop: 32px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style
The design system is built on the principles of **accessibility, warmth, and dignity**. It serves users who value reliability and straightforwardness, specifically catering to individuals with varying levels of digital literacy. The visual style is **Modern-Corporate with a Soft Humanist touch**, blending the professionalism of a service platform with the approachability of a community-driven tool.

The emotional response should be one of "quiet confidence." By utilizing high-contrast elements, generous whitespace, and friendly iconography inspired by the provided illustrations, the UI minimizes cognitive load and maximizes task success.

- **Minimalism:** Use heavy whitespace to separate distinct actions.
- **Humanist:** Incorporate soft, organic shapes and supportive imagery to reduce the "coldness" of a digital interface.
- **High-Contrast:** Ensure all text and critical iconography meet WCAG AAA standards for legibility.

## Colors
The palette is rooted in the "Forest Green" primary color, symbolizing growth, stability, and trust. 

- **Primary (#1B5E20):** Used for main actions, active states, and brand-defining elements.
- **Secondary (#F9A825):** A warm gold used sparingly for highlights, status indicators (pending), or specific call-to-action buttons that need to stand out against the green.
- **Tertiary/Surface (#E8F5E9):** A very light mint-green used for large background areas, cards, and input fields to reduce eye strain compared to pure white.
- **Neutral (#212121):** Deep charcoal for text to ensure maximum contrast. 
- **Error (#C62828):** A clear, high-contrast red for alerts and destructive actions.

## Typography
Plus Jakarta Sans is chosen for its geometric yet warm terminal strokes, which maintain high legibility even at smaller sizes. 

- **Hierarchy:** Use `headline-lg` sparingly for page titles. `body-lg` is the default for all descriptive text to ensure readability for users with visual impairments.
- **Weight:** Avoid using weights below 400. Headlines should use 600 or 700 to provide a clear structural anchor for the eyes.
- **Line Height:** Generous line heights are used to prevent "crowding" of text, which is essential for users with limited digital literacy.

## Layout & Spacing
This design system uses a **Fluid-Responsive Grid** based on an 8px base unit.

- **Touch Targets:** Every interactive element (buttons, links, checkboxes) must have a minimum height/width of 48px to accommodate all thumb sizes and motor skill levels.
- **Mobile First:** A 4-column grid for mobile devices with 16px side margins.
- **Desktop:** A 12-column centered grid with a max-width of 1200px.
- **Rhythm:** Use "Stack" spacing (vertical) to group related information. For example, a label and its input field should have `stack-sm` (8px), while two different sections should have `stack-lg` (24px).

## Elevation & Depth
To keep the UI grounded and easy to understand, we use **Tonal Layers** rather than complex shadows. 

- **Level 0 (Background):** Pure White (#FFFFFF) or Tertiary Mint (#E8F5E9).
- **Level 1 (Cards/Containers):** White background with a subtle 1px border (#E0E0E0) and no shadow. This creates a "flat-tactile" feel.
- **Level 2 (Active/Floating):** Use a soft, diffused shadow (0px 4px 12px, 5% opacity black) only for elements that appear over the main layout, like Modals or Bottom Sheets.
- **Focus States:** High-visibility 3px primary color border to clearly indicate keyboard or tap focus.

## Shapes
The shape language is consistently **Soft**. 

- All primary containers and buttons use an 8px (0.5rem) corner radius.
- **Exceptions:** Use the "Pill" shape (rounded-full) for status chips and tags to distinguish them from actionable buttons.
- Avoid sharp corners entirely to maintain the "warm" and "safe" brand personality.

## Components
Consistent component styling ensures the interface remains predictable.

- **Buttons:** 
  - **Primary:** Filled with #1B5E20, white text, 48px minimum height. 
  - **Secondary:** Outlined with #1B5E20, 2px border width.
- **Input Fields:** Use a 16px (body-md) font size for the input text to prevent iOS zoom-on-focus. Labels must always be visible (never use placeholder text as the only label).
- **Cards:** 8px rounded corners, 16px internal padding. Use for list items like "Job Postings" or "Worker Profiles."
- **Checkboxes & Radios:** Scaled up to 24x24px within a 48px touch-target container to ensure ease of selection.
- **Bottom Sheets:** For mobile actions, use bottom sheets instead of mid-screen modals to keep controls within the "thumb zone."
- **Progress Indicators:** Use the secondary gold (#F9A825) for progress bars to show active movement or completion.