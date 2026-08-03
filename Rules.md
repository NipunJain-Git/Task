# KaamSetu — AI Development Rules

> These rules define strict boundaries for any AI assistant (Copilot, Cursor, Antigravity, etc.) generating code for the KaamSetu project. Follow them without exception.

---

## 1. Technology Constraints

### ✅ MUST Use — Mobile App
| Area | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| Language | Dart (with strict analysis options) |
| Navigation | GoRouter |
| State Management | Riverpod (flutter_riverpod) |
| HTTP Client | Dio |
| Secure Storage | flutter_secure_storage (for tokens) |
| Settings Storage | shared_preferences (for non-sensitive prefs) |
| Data Classes | Freezed + json_serializable (code generation) |
| Localization | flutter_localizations + intl (ARB files) |
| Push Notifications | firebase_messaging + firebase_core |
| Location | geolocator + geocoding |
| Maps | google_maps_flutter |
| Image Handling | image_picker + cached_network_image |
| Error Tracking | sentry_flutter |
| Loading Placeholders | shimmer |

### ✅ MUST Use — Backend
| Area | Technology |
|---|---|
| Runtime | Node.js (v18+) |
| Framework | Express.js |
| Language | TypeScript (strict mode) |
| ORM | Prisma |
| Database | PostgreSQL (with PostGIS extension for geo queries) |
| Validation | Zod |
| Caching | Redis |

### 🚫 MUST NOT Use
| Banned | Reason |
|---|---|
| BLoC / flutter_bloc | Riverpod is the chosen state manager — do not introduce alternatives. |
| Provider (provider package) | Riverpod supersedes Provider. Do not mix them. |
| GetX | Discouraged due to poor testability, global state pollution, and non-standard patterns. |
| MobX | Not part of the stack. |
| MongoDB / Mongoose | PostgreSQL is the chosen database. No document DBs. |
| Firebase Firestore / Realtime DB | Firebase is only for push notifications. Not used for data storage. |
| GraphQL | REST API only for v1. |
| `http` package (Dart) | Dio is the chosen HTTP client. Do not use the basic `http` package. |
| `dynamic` type in Dart | All types must be explicit. Avoid `dynamic` unless absolutely unavoidable. |
| `setState` for app state | `setState` is only acceptable for local widget UI state (animations, form fields). All app/feature state must use Riverpod. |
| External CSS / Tailwind | Flutter does not use CSS. Style via Flutter's ThemeData and widget properties. |

---

## 2. Code Style & Structure

### General Dart
- **Analysis**: Use `analysis_options.yaml` with `flutter_lints` (or stricter). Enable `implicit-casts: false` and `implicit-dynamic: false`.
- **File Naming**: Use `snake_case` for all Dart files (e.g., `auth_provider.dart`, `job_card.dart`).
- **Class Naming**: `PascalCase` for classes, enums, typedefs, and extensions.
- **Variable Naming**: `camelCase` for variables, functions, parameters, and named constants.
- **Folder Structure**: Follow the feature-based structure defined in `Architecture.md`. Do not create ad-hoc folders.
- **Max File Length**: Keep files under 300 lines. If a widget file exceeds this, extract sub-widgets into separate files.
- **Imports**: Use relative imports within the same feature. Use package imports across features.

### Flutter / Widget Specific
- **StatelessWidget by Default**: Use `StatelessWidget` unless the widget needs local mutable UI state (animations, controllers).
- **ConsumerWidget / ConsumerStatefulWidget**: Use these for widgets that read Riverpod providers.
- **Const Constructors**: Always use `const` constructors where possible for performance.
- **Widget Decomposition**: Break large build methods into smaller private widget methods or separate widget classes. No build method should exceed 80 lines.
- **No Inline Styles in Build**: Define reusable style constants in theme files. Avoid hardcoded colors, font sizes, or padding values in widget code.
- **Keys**: Use `ValueKey` or `ObjectKey` on list items for efficient rebuilds.
- **Accessibility**: Always add `Semantics` widgets or `semanticLabel` to interactive elements. Use `Tooltip` for icon buttons.

### Riverpod Specific
- **Provider Naming**: End all providers with `Provider` (e.g., `authProvider`, `jobsProvider`).
- **Notifier Naming**: End all notifiers with `Notifier` (e.g., `AuthNotifier`, `JobsNotifier`).
- **Immutable State**: Use Freezed data classes for all provider states. Never mutate state directly.
- **AsyncValue**: Use `AsyncValue` (via `AsyncNotifierProvider` / `FutureProvider`) for all API-backed state.
- **Provider Scope**: Keep providers feature-scoped. Do not create god-providers that manage multiple unrelated concerns.
- **No Global State**: Do not use global variables. All shared state flows through Riverpod providers.

### Data Layer
- **Freezed Models**: All data models must use `@freezed` for immutability and generated `fromJson`/`toJson`.
- **Repository Pattern**: Each feature has a repository class that abstracts data sources (API, local cache).
- **API Layer**: Separate API classes (e.g., `auth_api.dart`) handle raw Dio calls. Repositories compose them.
- **Error Mapping**: API errors must be caught in repositories and mapped to typed failure objects — never let raw `DioException` leak to the UI.

### Backend Specific
- **Module Pattern**: Each feature module must have: `*.controller.ts`, `*.service.ts`, `*.routes.ts`, and `*.validators.ts`.
- **Controller**: Handles request/response only. No business logic.
- **Service**: Contains all business logic. Returns data, throws errors.
- **Validators**: Use Zod schemas. Validate all incoming request bodies, params, and query strings.
- **No Raw SQL**: Use Prisma's query builder. Only use raw SQL for PostGIS geospatial queries when Prisma doesn't support the operation.

---

## 3. Error Handling

### Client-Side (Flutter)
- Use Riverpod's `AsyncValue` to represent loading, data, and error states in the UI.
- Display user-friendly error messages in **Hindi and English** (via i18n keys — never raw error strings).
- Use a **global error observer** (Riverpod `ProviderObserver`) to log errors to Sentry.
- Wrap the app in a **Flutter error boundary** (`ErrorWidget.builder`) for unexpected widget build errors.
- Handle Dio errors in repositories — map them to user-friendly error types:
  ```dart
  sealed class AppFailure {
    const factory AppFailure.network() = NetworkFailure;
    const factory AppFailure.server(String message) = ServerFailure;
    const factory AppFailure.unauthorized() = UnauthorizedFailure;
    const factory AppFailure.notFound() = NotFoundFailure;
  }
  ```

### Server-Side (Express)
- Use a centralized `ApiError` class for all thrown errors:
  ```typescript
  throw new ApiError(404, "JOB_NOT_FOUND", "The requested job does not exist.");
  ```
- All errors must include: HTTP status code, error code (string), and human-readable message.
- Use a global `errorMiddleware` to catch and format all errors consistently.
- **Never expose stack traces** or internal details in API responses (production mode).
- Log all errors with context (userId, endpoint, timestamp) using a structured logger.

### Error Response Format (API)
```json
{
  "success": false,
  "error": {
    "code": "JOB_NOT_FOUND",
    "message": "The requested job does not exist.",
    "statusCode": 404
  }
}
```

---

## 4. API Response Format

All API responses must follow this consistent structure:

### Success
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 150
  }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Phone number is required.",
    "statusCode": 400
  }
}
```

---

## 5. Authentication & Security Rules

- **OTP Expiry**: OTP must expire after **5 minutes**. Store in Redis with TTL.
- **OTP Attempts**: Maximum **3 failed OTP attempts** before requiring a new OTP.
- **JWT Expiry**: Access token = 7 days. Refresh token = 30 days.
- **Password Storage**: There are NO passwords. Do not create password fields.
- **Token Storage**: Store JWT tokens using `flutter_secure_storage` (backed by Keychain on iOS, EncryptedSharedPreferences on Android). Never use plain `SharedPreferences` for tokens.
- **Rate Limiting**: Apply rate limiting on OTP endpoints (max 5 requests per phone per hour).
- **Input Sanitization**: Sanitize all user inputs to prevent XSS and SQL injection.
- **CORS**: Restrict CORS to known origins only.
- **Environment Variables**: Never hardcode secrets. Use `.env` files (and `.env.example` as a template).
- **Phone Privacy**: Never expose a user's phone number to another user via API.

---

## 6. Database Rules

- **UUIDs**: Use UUIDs as primary keys (not auto-increment integers).
- **Timestamps**: Every table must have `createdAt` and `updatedAt` fields (auto-managed by Prisma).
- **Soft Deletes**: Use a `deletedAt` timestamp for soft deletes — never hard-delete user data.
- **Indexes**: Create indexes on frequently queried columns: `userId`, `jobId`, `status`, `location`.
- **Migrations**: Always generate migrations via Prisma. Never modify the database schema manually.
- **Seeds**: Provide a seed script (`prisma/seed.ts`) with realistic test data.

---

## 7. What the AI Should Do

- ✅ Write **complete, working code** — no placeholders like `// TODO: implement this`.
- ✅ Add **DartDoc comments** (`///`) to all public classes, methods, and providers.
- ✅ Use **Freezed data classes** for all models with `fromJson`/`toJson`.
- ✅ Follow the **folder structure** defined in Architecture.md exactly.
- ✅ Create **reusable widgets** — avoid duplicating UI code.
- ✅ Handle **loading, error, and empty states** in every screen using `AsyncValue.when()`.
- ✅ Support **Hindi and English** using ARB localization files (never hardcode user-facing strings).
- ✅ Write **Zod validation schemas** for every API input (backend).
- ✅ Use **semantic, descriptive names** for variables, functions, widgets, and providers.
- ✅ Keep **accessibility** in mind — `Semantics` widgets, large tap targets (48dp+), readable fonts, meaningful labels.
- ✅ Always run `dart fix --apply` and `dart format .` before committing.
- ✅ Always run `build_runner` after modifying Freezed models: `dart run build_runner build --delete-conflicting-outputs`.
- ✅ Use `const` constructors wherever possible.

---

## 8. What the AI Should NOT Do

- 🚫 Do not generate **mock data in production code** — use API calls or seed scripts.
- 🚫 Do not create **monolithic files** — split into logical modules (< 300 lines per file).
- 🚫 Do not use `print()` for error handling — use the structured logger or Sentry.
- 🚫 Do not **hardcode strings** in UI — always use localization keys (`context.l10n.someKey`).
- 🚫 Do not **skip error handling** — every API call must handle failure gracefully via `AsyncValue`.
- 🚫 Do not create **new dependencies** without justification. Prefer built-in / existing packages.
- 🚫 Do not generate **test files with empty test cases** — every test must have assertions.
- 🚫 Do not modify the **database schema** without creating a proper Prisma migration.
- 🚫 Do not store **sensitive data** (tokens, phone numbers) in `SharedPreferences` — use `flutter_secure_storage`.
- 🚫 Do not use **`setState`** for feature/app state — only for local widget UI state (form fields, animations).
- 🚫 Do not use `dynamic` types — always define explicit types.
- 🚫 Do not nest widgets deeply — extract sub-widgets into separate methods or classes.
- 🚫 Do not use `late` keyword without a clear initialization guarantee. Prefer nullable types with null checks.

---

## 9. Testing Rules

### Flutter (Client)
- Use **Flutter Test** framework (built-in).
- **Widget Tests** for critical UI flows: login, job posting, rating.
- **Unit Tests** for all providers, repositories, and utility functions.
- Use `ProviderContainer` to test Riverpod providers in isolation.
- Use `mocktail` for mocking dependencies (do NOT use `mockito`).
- Test files mirror `lib/` structure inside `test/` directory.
- Name test files as `*_test.dart`.

### Backend
- Use **Jest** as the test runner.
- Use **Supertest** for API endpoint integration tests.
- Minimum **80% code coverage** target for backend services.
- Name test files as `*.test.ts`, co-located or in a `tests/` directory.

---

## 10. Git & Version Control

- **Branch Naming**: `feature/<name>`, `bugfix/<name>`, `hotfix/<name>`.
- **Commit Messages**: Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`.
- **No Large Commits**: Keep commits focused — one feature/fix per commit.
- **Pull Requests**: Every change must go through a PR with a description.
- **`.gitignore`**: Ensure `node_modules/`, `.env`, `dist/`, `build/`, `.dart_tool/`, `.flutter-plugins`, and generated files (`*.g.dart`, `*.freezed.dart`) are properly handled. Generated files should be committed to avoid requiring `build_runner` on every clone.
