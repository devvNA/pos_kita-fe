# Data Layer - POS Kita

## Package Identity

Handles all data persistence and external communication via Remote and Local DataSources.

## Patterns & Conventions

- **Remote DataSources:** HTTP calls using `http` package. Return `Future<Either<String, T>>`.
  - Always handle non-200 status codes.
  - See `lib/data/datasources/product_remote_datasource.dart` for example.
- **Local DataSources:**
  - `DBLocalDatasource`: Singleton for SQLite. Handle all offline CRUD.
  - `AuthLocalDatasource`: SharedPreferences for session persistence.
- **Models:**
  - Requests: `lib/data/models/requests/`
  - Responses: `lib/data/models/responses/` (Use `@freezed` or standard classes with `fromJson`/`toJson`).

## Key Files

- SQLite Singleton: `lib/data/datasources/db_local_datasource.dart`
- Auth Storage: `lib/data/datasources/auth_local_datasource.dart`
- Base API URL: `lib/core/constants/variables.dart`

## JIT Index Hints

- Find DB query: `rg -n "await db.query"`
- Find API endpoint: `rg -n "http.get"` or `rg -n "http.post"`
- Find Model mapping: `rg -n "factory .*Model.fromJson"`

## Common Gotchas

- "Remember to increment SQLite version in `DBLocalDatasource` if schema changes."
- "All SQLite date formats should be ISO8601 strings."
- "Sync status `is_sync` must be handled for all transactions."
