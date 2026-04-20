# Presentation Layer - Kita POS

## Package Identity

Handles all UI logic, state management (BLoC), and user interaction across features.

## Patterns & Conventions

- **Feature Folders:** `lib/presentation/<feature_name>/`
  - `bloc/`: BLoC, Event, State files.
  - `pages/`: Full-screen widgets.
  - `widgets/`: Small, reusable components specific to this feature.
- **BLoC Pattern (Strict):**
  - Use `freezed` for `Event` and `State`.
  - Always have `initial`, `loading`, `success`, and `error` states.
  - Fold result using `result.fold((failure) => emit(Error), (success) => emit(Success))`.
  - See `lib/presentation/home/bloc/checkout/checkout_bloc.dart`.
- **UI Conventions:**
  - Standard spacing: `SpaceHeight(16)`, `SpaceWidth(8)`.
  - Standard radius: `8.0` for search/input, `16.0` for buttons/cards.
  - Navigation: Use context extensions in `lib/core/extensions/build_context_ext.dart`.

## Key Files

- Main Provider: `lib/main.dart` (MultiBlocProvider).
- Design System: `lib/core/design_system/`.
- Checkout BLoC: `lib/presentation/home/bloc/checkout/checkout_bloc.dart`.
- Sync BLoC: `lib/presentation/transaction/blocs/sync_order/sync_order_bloc.dart`.

## JIT Index Hints

- Find Page: `find . -name "*_page.dart"`
- Find BLoC Builder: `rg -n "BlocBuilder"`
- Find Navigation: `rg -n "context.push"`
- Find Price Formatter: `rg -n ".currencyFormatRp"`

## Common Gotchas

- "Run `build_runner` after any changes to `bloc` files."
- "All UI strings should be in **Indonesian**."
- "Avoid logic in widgets; keep it in BLoCs."
- "Global BLoCs must be registered in `main.dart`."
