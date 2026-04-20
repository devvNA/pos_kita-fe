# Jago POS (POS Kita) - Technical Overview

## 🏗 Core Components & Architecture

### 1. Technology Stack
- **Framework:** Flutter (Dart 3.11+)
- **State Management:** BLoC (Business Logic Component) using `flutter_bloc` and `freezed` for immutable states/events.
- **Local Persistence:** 
  - **SQLite (`sqflite`):** Main database for products, categories, and transactions.
  - **SharedPreferences:** For auth tokens and simple app settings.
- **Networking:** HTTP package with functional error handling via `dartz` (`Either<String, T>`).
- **Design System:** Custom theme in `lib/core/design_system/` with Material 3.

### 2. Architectural Pattern
The project follows a **Layered Architecture** (simplified Clean Architecture):
- **Presentation Layer (`lib/presentation/`):** Organized by feature. Contains BLoCs, Pages, and Widgets.
- **Data Layer (`lib/data/`):** 
  - **Models:** Request/Response objects and local database entities.
  - **DataSources:** Remote (API calls) and Local (SQLite/Prefs).
- **Core Layer (`lib/core/`):** Shared utilities, constants, extensions, and reusable UI components.

*Note: There is no explicit Repository layer; BLoCs interact directly with DataSources.*

## 🔄 Component Interactions

### 1. Data Flow
`UI (Widget) → BLoC/Event → DataSource (Remote or Local) → BLoC/State → UI`

### 2. Offline-First Synchronization
- **Transaction Flow:** Transactions are first saved to SQLite with an `is_sync = 0` flag.
- **Sync Mechanism:** `SyncOrderBloc` periodically (or via trigger) fetches unsynced records from `DBLocalDatasource` and pushes them to `OrderRemoteDatasource`. Upon success, records are marked as `is_sync = 1`.

### 3. Dependency Injection
Dependencies (DataSources) are manually injected into BLoCs within the `MultiBlocProvider` in `lib/main.dart`.

## 🚀 Runtime Behavior

### 1. Initialization
1. `main()` ensures Flutter bindings and sets preferred orientations/UI styles.
2. `MyApp` initializes `MultiBlocProvider` with all global BLoCs.
3. `FutureBuilder` in `MaterialApp.home` checks `AuthLocalDatasource` for an existing token:
   - Token exists → `HomePage`
   - No token → `SplashPage`

### 2. Error Handling
- **Data Layer:** Returns `Left(ErrorMessage)` or `Right(Data)` using `dartz.Either`.
- **Presentation Layer:** BLoC states include an `.error(String message)` variant which is typically handled in the UI via `BlocListener` showing SnackBars or error widgets.

### 3. Hardware Integration
- **Printer:** Managed via `PrinterBloc`, communicating with Bluetooth thermal printers.
- **Scanner:** Uses `mobile_scanner` for barcode/QR code input.

## 📦 Deployment & Environment
- **API Base URL:** Defined in `lib/core/constants/variables.dart` (Note: Currently set to a local IP address).
- **Database:** `jagoposf8.db` (SQLite).
- **Builds:** Standard Flutter build process (`flutter build apk`). Requires `build_runner` for generating `freezed` files.
