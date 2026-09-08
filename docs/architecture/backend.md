# Backend Architecture

## Serverpod Overview

The backend uses Serverpod (3.4.13), a Dart-based backend framework that shares
code with the Flutter frontend through generated client packages. The server
owns real authentication (email registration + JWT), households, and programs.

## Structure

```
apps/server/
├── bin/
│   └── main.dart               # Entry point
├── config/
│   ├── development.yaml        # Ports, db name, applyMigrations
│   ├── passwords.yaml          # Secrets + test db password (never committed in prod)
│   ├── generator.yaml          # Serverpod generate options + server test tools path
│   └── test.yaml               # Test port + shipit_golden_test db
├── lib/src/
│   ├── auth/
│   │   └── auth_setup.dart     # Shared auth bootstrap (main + tests)
│   ├── endpoints/              # API endpoints (Dart; type: server, YAML optional)
│   │   ├── auth_endpoint.dart      # extends EmailIdpBaseEndpoint
│   │   ├── jwt_tokens_endpoint.dart# extends RefreshJwtTokensEndpoint
│   │   ├── household_endpoint.dart # requireLogin
│   │   └── programs_endpoint.dart  # requireLogin
│   ├── models/                 # DB models (YAML)
│   │   ├── household.yaml
│   │   ├── household_member.yaml
│   │   └── program.yaml
│   └── generated/              # Serverpod generated code (committed by design:
│                               # required for analyze/tests without a generate step)
├── migrations/                 # Generated migration baseline (applied on boot)
└── test/
    ├── dart_test.yaml          # integration tag
    ├── protocol_test.dart
    └── integration/            # DB-backed auth integration tests
        ├── test_tools/         # generated serverpod_test_tools.dart
        └── auth_flow_test.dart
```

## Key Components

### 1. Models (YAML → Dart)

Serverpod models defined in YAML generate Dart classes with serialization,
database table definitions, and migration baselines. There is NO custom `User`
model/table: user identities and credentials are owned by the Serverpod Auth
tables (`serverpod_auth`) created by `EmailIdp` in the shared bootstrap.

```yaml
# household.yaml
class: Household
table: households
fields:
  name: String
  ownerId: String?  # references the Serverpod Auth user id
```

### 2. Endpoints (Dart)

Endpoints are Dart classes under `lib/src/endpoints/`, registered via the
annotations (`@serverpod.Route` / `@serverpod.Serializer`) that the `serverpod
generate` step reads; there is no `endpoints.yaml` manifest. `EmailIdp` and
`JwtTokens` endpoints are the live auth surface:

```dart
// auth_endpoint.dart — subclass of the Serverpod Auth Email IDP
class AuthEndpoint extends EmailIdpBaseEndpoint {
  // registration: startRegistration → verifyRegistrationCode → finishRegistration
  // login: auth.login(email, password)
}
```

Protected product endpoints enforce auth server-side:

```dart
@serverpod.Serializer(serializer: 'household/getCurrent')
Future<Household> getCurrent(Session session) {
  // requireLogin throws ServerpodUnauthenticatedException (HTTP 401)
  // when no valid JWT is present, before the handler runs.
}
```

### 3. Auth Bootstrap (shared between app and tests)

`apps/server/lib/src/auth/auth_setup.dart` initializes the Serverpod Auth
services once, after the `Serverpod(...)` constructor:

```dart
void configureAuthServices(Serverpod pod) {
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      EmailIdpConfigFromPasswords(
        passwordHashPepperKey: 'emailSecretHashPepper',
        service: EmailIdpConfigWithDevCodeLogging(pod),
      ),
    ],
  );
}
```

The `EmailIdpConfig` is decorated to log verification codes to the server
console for the development workflow (no SMTP provider yet). `test.yaml`
configures mailGun/test overrides; `serverpod_test_tools.dart` exercises the
same `configureAuthServices` in a `setUp()`.

## Authentication

Real email registration + JWT session management via `serverpod_auth`:

- **Registration**: `startRegistration(email)` returns an `UuidValue`
  account-request; the code is logged to the dev console; `verifyRegistrationCode`
  returns a one-time token; `finishRegistration` creates the account and returns
  an `AuthSuccess` (access JWT + refresh token).
- **Login**: `auth.login(email, password)` — wrong credential throws a typed
  `EmailAccountLoginException` (HTTP 400 with `reason: invalidCredentials`).
- **Session**: access tokens expire; `jwtTokens/refreshAccessToken` issues a new
  access token from the refresh token. The Flutter client leverages
  `FlutterAuthSessionManager` for automatic refresh in the app.
- **Protection**: `requireLogin` on protected endpoints → HTTP 401
  (`ServerpodUnauthenticatedException`) for unauthenticated calls.

```
Client → auth.startRegistration(email) → UuidValue request id
    ↓
(dev console) verification code
Client → auth.verifyRegistrationCode(requestId, code) → registration token
    ↓
Client → auth.finishRegistration(token, password) → AuthSuccess(access + refresh)
    ↓
Subsequent calls → household/programs accept Bearer access token (requireLogin)
```

## API Contract Generation

```bash
melos run generate:server      # full server generate + regenerated client package
melos run generate:client      # regenerate client package only
melos run generate:check       # generate && git diff --exit-code
```

`generator.yaml` declares `type: server`, the relative client package path
(`../../packages/app_client`), and `server_test_tools_path` so
`serverpod generate` also emits `test/integration/test_tools/serverpod_test_tools.dart`.

The generated client (`packages/app_client`) contains endpoint client classes
(`auth`, `jwtTokens`, `household`, `programs`) and protocol models with
serialization. Generated contracts are authoritative for client/server
communication; the app maps protocol models to feature domain models via
dedicated converters.

## Configuration

- **development.yaml** — port 8080, db `shipit_golden`,
  `applyMigrations: true` (fresh checkout starts with `docker compose up` +
  `melos run dev:server`).
- **test.yaml** — port 8081, db `shipit_golden_test`.
- **passwords.yaml** — Serverpod Auth secrets (`jwtRefreshTokenHashPepper`,
  `jwtHmacSha512PrivateKey`, `emailSecretHashPepper`) and the `database`
  password. NEVER commit production secrets.

## Testing

DB-backed integration tests exercise the full auth surface against a real
Serverpod instance and PostgreSQL (`shipit_golden_test`):

- registration → verification → login issues tokens
- `hasAccount` returns false for unauthenticated sessions (no account leakage)
- wrong password → `EmailAccountLoginException` (typed 400)
- protected endpoints (`household`, `programs`) reject unauthenticated calls
  with `ServerpodUnauthenticatedException`

The harness builds its own Serverpod (bypassing `bin/main.dart`) and calls
`configureAuthServices` inside each `withServerpod` `setUp`, with
`RollbackDatabase.disabled` (the email IDP uses internal transactions
incompatible with the rollback proxy). Run with
`melos run test:server` (tag: `integration`).

Additional manual/live verification of token refresh and 401/400 failure
injection is documented in `docs/qa/strategy.md`.