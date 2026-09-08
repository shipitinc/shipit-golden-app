# Architecture Overview

## System Context

The ShipIt Golden App is a reference implementation demonstrating the standard ShipIt product architecture. It consists of:

- **Frontend**: Flutter application (web — the only scaffolded target)
- **Backend**: Serverpod (Dart) with PostgreSQL
- **Design System**: shipit_ui components
- **State Management**: BLoC + Freezed
- **Monorepo**: Melos-managed

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Client Devices                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Web       │  │  Android    │  │   iOS       │              │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘              │
└─────────┼────────────────┼────────────────┼─────────────────────┘
          │                │                │
          ▼                ▼                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Flutter Application                         │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                    BLoC Layer (State)                      │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐  │  │
│  │  │ AuthBloc    │ │HouseholdBloc│ │ ProgramsBloc        │  │  │
│  │  └─────────────┘ └─────────────┘ └─────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                 Repository Layer                           │  │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐  │  │
│  │  │AuthRepository│ │HouseholdRepo│ │ ProgramsRepository  │  │  │
│  │  └─────────────┘ └─────────────┘ └─────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │              Serverpod Generated Client                    │  │
│  └───────────────────────────────────────────────────────────┘  │
└──────────────────────────────┬──────────────────────────────────┘
                               │ HTTP/JSON
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Serverpod Backend                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐               │
│  │AuthEndpoint │ │HouseholdEp  │ │ProgramsEp   │               │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘               │
│         │               │               │                       │
│         ▼               ▼               ▼                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    Services Layer                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│         │               │               │                       │
│         ▼               ▼               ▼                       │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    PostgreSQL Database                   │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

## Key Architectural Decisions

### 1. Monorepo Structure
- **apps/app**: End-user Flutter application
- **apps/server**: Serverpod backend
- **packages/app_client**: Generated Serverpod client (shared contract)

### 2. State Management: BLoC + Freezed
- Feature-scoped BLoCs (AuthenticationBloc, HouseholdBloc, ProgramsBloc)
- Immutable events and states via Freezed
- No global application state

### 3. API Contract
- Serverpod generates client from endpoint definitions
- Single source of truth for API contracts
- Type-safe communication

### 4. Design System Integration
- All UI via shipit_ui package
- No arbitrary colors, spacing, or custom components
- DESIGN_PENDING markers for unimplemented designs

### 5. Dependency Rules
```
apps/app → shipit_ui, app_client, approved packages
apps/server → serverpod, postgres, NO apps/app
packages/app_client → serverpod_client, NO apps/*
```

## Data Flow

### Authentication Flow
```
User Input → LoginScreen → AuthenticationBloc → AuthRepository → Serverpod generated client (auth + jwtTokens)
                                                              ↓
                                                    Serverpod AuthEndpoint
                                                              ↓
                                                    PostgreSQL (serverpod_auth user tables)
                                                              ↓
                                                    AuthResult ← Token
                                                              ↓
                                              AuthenticationState.authenticated
```

### Household Flow
```
HouseholdScreen → HouseholdBloc → HouseholdRepository → Serverpod generated client (household)
                                                                  ↓
                                                        Serverpod HouseholdEndpoint
                                                                  ↓
                                                        PostgreSQL (Household, Members)
                                                                  ↓
                                                        HouseholdState.loaded
```

## Technology Stack Versions

| Component | Version | Source |
|-----------|---------|--------|
| Flutter | 3.44.7 | FVM pinned |
| Dart | 3.12.2 | Bundled with Flutter |
| Serverpod | 3.4.13 | Latest stable |
| Melos | 8.6.0 | Latest stable |
| FVM | 4.1.2 | Latest stable |
| shipit_ui | 0.1.0 | Git main |
| bloc | 9.0.0 | Latest stable |
| freezed | 3.0.0 | Latest stable |