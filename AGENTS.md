# Jago POS (POS Kita) - Agent Guide

## Project Snapshot

Flutter POS application for Indonesian SMBs. Features offline-first capability with SQLite sync, BLoC state management, and a custom design system.

## Root Setup Commands

- Install dependencies: `flutter pub get`
- Generate code (Freezed): `flutter pub run build_runner build --delete-conflicting-outputs`
- Run in debug: `flutter run`
- Analyze code: `flutter analyze`
- Clean build: `flutter clean && flutter pub get`

## Universal Conventions

- **Language:** UI text must be in **Indonesian**.
- **Naming:** `snake_case` for files, `PascalCase` for classes.
- **State Management:** Use BLoC with `freezed`. Every BLoC must have initial, loading, success, and error states.
- **Error Handling:** Use `dartz` `Either<String, T>` in DataSources.
- **UI:** Follow `lib/core/design_system/`. Use `SpaceHeight(n)` and `SpaceWidth(n)` for spacing.
- **Currency:** Use `.currencyFormatRp` extension for prices.

## Security & Secrets

- Never commit API keys or production URLs.
- Base URL is in `lib/core/constants/variables.dart`.
- Auth tokens are stored in `SharedPreferences` via `AuthLocalDatasource`.

## JIT Index

### Layer Structure

- **Core:** `lib/core/` -> Common components & utils.
- **Data Layer:** `lib/data/` -> [See lib/data/AGENTS.md](lib/data/AGENTS.md)
- **Presentation:** `lib/presentation/` -> [See lib/presentation/AGENTS.md](lib/presentation/AGENTS.md)

### Quick Find Commands

- Find BLoC: `rg -n "class .*Bloc"`
- Find DataSource: `rg -n "class .*DataSource"`
- Find UI Page: `find lib/presentation -name "*_page.dart"`
- Find Database Schema: `cat lib/data/datasources/db_local_datasource.dart`

## Definition of Done

- `flutter analyze` passes with no errors.
- `build_runner` command executed if models/states changed.
- New features include necessary SQLite table updates in `DBLocalDatasource`.
- All prices formatted with `.currencyFormatRp`.
