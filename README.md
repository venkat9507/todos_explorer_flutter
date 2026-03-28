# Todos Explorer

A Flutter application built with **Clean Architecture** and **Riverpod** state management. Fetches todos from [JSONPlaceholder](https://jsonplaceholder.typicode.com/todos), displays them in a scrollable card list with filtering, sorting, search highlighting, favorites, pagination, and responsive design.

**Flutter Version:** `3.35.7` (managed via [FVM](https://fvm.app/) - see `.fvmrc`)

---

## Features

- **Paginated Loading** - Offset-based pagination with infinite scroll and pull-to-refresh
- **Filtering** - All / Completed / Pending / Favorites
- **Sorting** - Title (A-Z, Z-A), Status (Completed first, Pending first), ID (Low-High, High-Low)
- **Search** - Case-insensitive substring matching with card highlight (`#FFF9C4`) and optional search-as-filter toggle
- **Favorites** - Mark/unmark todos as favorite (local state)
- **Network Monitoring** - Real-time connectivity detection with offline screen
- **Responsive Design** - Adaptive layout for phone, tablet, and desktop
- **Material 3 Theming** - Light and dark themes following system preference
- **Footer** - Persistent "Showing X of Y todos" count

---

## Architecture

The project follows **Clean Architecture** organized by feature, with three layers:

```
Presentation  -->  Domain  <--  Data
   (UI)         (Business)    (API/Models)
```

- **Domain** - Abstract interfaces (`TodoRepository`, `TodoRemoteDataSource`) and pure entities (`TodoEntity`). No framework dependencies.
- **Data** - Implements domain interfaces. Contains API models (`TodoModel` with `fromJson`/`toJson`), HTTP data sources, and repository implementations.
- **Presentation** - Screens, widgets, state notifiers, and Riverpod providers. Consumes domain entities only.

### Folder Structure

```
lib/
├── main.dart
├── common/
│   └── widgets/                        # Shared UI (ErrorRetryView, NoResultsView, etc.)
├── core/
│   ├── constants/                      # AppConstants, Enums, Extensions
│   ├── di/                             # Riverpod provider wiring
│   ├── exceptions/                     # AppException hierarchy + ExceptionHandler
│   ├── logger/                         # Centralized AppLogger
│   ├── network/                        # AppHttpClient, NetworkMonitor
│   ├── responsive/                     # ResponsiveConfig, ResponsiveBuilder
│   └── theme/                          # Material 3 light + dark themes
└── features/
    └── todos/
        ├── domain/
        │   ├── entities/               # TodoEntity (Freezed)
        │   ├── repositories/           # TodoRepository (abstract interface)
        │   └── datasources/            # TodoRemoteDataSource (abstract interface)
        ├── data/
        │   ├── models/                 # TodoModel (Freezed + JSON serializable)
        │   ├── datasources/            # TodoRemoteDataSourceImpl
        │   └── repositories/           # TodoRepositoryImpl
        └── presentation/
            ├── providers/              # TodosNotifier + TodosState (Freezed)
            └── widgets/                # TodosScreen, TodoCard, SearchField, etc.
```

---

## Dependency Flow

```
httpClientProvider
       |
       v
todoRemoteDataSourceProvider
       |
       v
todoRepositoryProvider
       |
       v
TodosNotifier (reads todoRepositoryProvider)
       |
       v
TodosState (Freezed immutable state)
       |
       v
UI Widgets (watch todosNotifierProvider)
```

Each layer depends only on the one above it. The domain layer has zero dependencies on data or presentation.

---

## State Management

**Riverpod v2** with code generation (`@riverpod` annotation) handles both dependency injection and state management.

### Provider Chain

| Provider | Type | Creates |
|----------|------|---------|
| `httpClientProvider` | `Provider` | `AppHttpClientImpl` |
| `todoRemoteDataSourceProvider` | `Provider` | `TodoRemoteDataSourceImpl` |
| `todoRepositoryProvider` | `Provider` | `TodoRepositoryImpl` |
| `todosNotifierProvider` | `NotifierProvider` | `TodosNotifier` (manages `TodosState`) |
| `networkStatusProvider` | `StreamProvider` | `Stream<NetworkStatus>` |

### TodosState (Freezed)

```dart
TodosState({
  List<TodoEntity> todos,       // All fetched todos
  bool isLoading,               // Initial load indicator
  bool isLoadingMore,           // Pagination load indicator
  String? error,                // Error message (null = no error)
  bool hasMore,                 // More pages available
  int offset,                   // Current pagination offset
  TodoFilter filter,            // Active filter (all/completed/pending/favorites)
  TodoSort sort,                // Active sort order
  String searchQuery,           // Current search text
  bool searchAsFilter,          // Whether search filters or just highlights
})
```

**Computed getters:**
- `filteredAndSortedTodos` - Applies filter -> search-as-filter -> sort pipeline
- `visibleCount` - Number of todos after filtering
- `totalCount` - Total fetched todos

### TodosNotifier Methods

| Method | Description |
|--------|-------------|
| `build()` | Initializes state and triggers first page fetch via `Future.microtask` |
| `refresh()` | Resets pagination and fetches first page (pull-to-refresh) |
| `loadMore()` | Fetches next page and appends to existing todos (guarded against concurrent calls) |
| `setFilter(TodoFilter)` | Updates the active status filter. Resets sort to `titleAZ` if it conflicts (e.g. `completed` filter + `pendingFirst` sort) |
| `setSort(TodoSort)` | Updates the active sort order. Syncs filter to match sort intent if conflicting (e.g. `completedFirst` sort + `pending` filter switches filter to `completed`) |
| `setSearchQuery(String)` | Updates search text |
| `toggleSearchAsFilter()` | Toggles between highlight-only and filter mode |
| `toggleFavorite(int)` | Toggles favorite status for a todo by ID |

### Filter-Sort Conflict Resolution

When a filter and sort combination is redundant or contradictory, the notifier auto-corrects:

| Action | Conflict | Resolution |
|--------|----------|------------|
| Set filter to `completed` | Sort is `pendingFirst` | Sort resets to `titleAZ` |
| Set filter to `pending` | Sort is `completedFirst` | Sort resets to `titleAZ` |
| Set sort to `completedFirst` | Filter is `pending` | Filter switches to `completed` |
| Set sort to `pendingFirst` | Filter is `completed` | Filter switches to `pending` |

**Rationale:** Changing the filter resets the sort (sort follows filter), while changing the sort syncs the filter to match intent (filter follows sort).

### Data Flow

```
User Action (scroll, tap filter, type search)
       |
       v
TodosNotifier method called
       |
       v
state = state.copyWith(...)       // Immutable state update
       |
       v
filteredAndSortedTodos recomputed  // Filter -> Search -> Sort pipeline
       |
       v
UI rebuilds via ref.watch()        // Selective rebuilds with .select()
```

---

## Exception Handling

```
AppException (base)
├── NetworkException      - No internet connection
├── ServerException       - HTTP 4xx/5xx errors (includes statusCode)
├── AppTimeoutException   - Request timed out
└── ParseException        - JSON parsing failure
```

`ExceptionHandler` maps low-level exceptions (`SocketException`, `FormatException`, `TimeoutException`, `http.ClientException`) into the appropriate `AppException` subtype. All errors are logged via `AppLogger`.

---

## Responsive Design

Three breakpoints via `ResponsiveConfig`:

| Screen Type | Width | Layout |
|-------------|-------|--------|
| Phone | < 600px | Full-width, single column |
| Tablet | 600 - 900px | Centered content, max 600px |
| Desktop | > 900px | Centered content, max 800px |

`ResponsiveBuilder` wraps the UI and provides a `ResponsiveConfig` with adaptive values for padding, card margins, font sizes, and spacing.

---

## UI Components

| Widget | Description |
|--------|-------------|
| `TodosScreen` | Root scaffold with `ResponsiveBuilder` and bottom "Showing X of Y" bar |
| `TodosListBody` | `CustomScrollView` with Lottie header, pinned search/filter bar, and `SliverList` of cards |
| `TodoCard` | Card with status icon, highlighted title, subtitle, favorite button, and status badge |
| `TodosSearchField` | Text input with clear button and search-as-filter toggle switch |
| `TodosFilterChips` | Horizontally scrollable `ChoiceChip` row (All, Completed, Pending, Favorites) |
| `TodosSortMenu` | `PopupMenuButton` with 6 sort options in the app bar |
| `NetworkAwareWrapper` | Root wrapper that shows `NoInternetScreen` when disconnected |
| `ErrorRetryView` | Error message with retry button |
| `NoResultsView` | Empty state for filtered/searched results |
| `SearchHighlightText` | Highlights matching substrings in todo titles |

---

## API

**Base URL:** `https://jsonplaceholder.typicode.com/todos`

**Endpoint:** `GET /todos?_start={offset}&_limit={pageSize}`

**Response:**
```json
[
  {
    "userId": 1,
    "id": 1,
    "title": "delectus aut autem",
    "completed": false
  }
]
```

Pagination uses `_start` (offset) and `_limit` (page size of 20) query parameters.

---

## Testing

Tests use **Mockito** for mocking with `@GenerateMocks` code generation.

```
test/
├── common/widgets/          # Widget tests (ErrorRetryView, NetworkAwareWrapper, etc.)
├── core/
│   ├── constants/           # AppConstants, Enums, Extensions
│   ├── exceptions/          # ExceptionHandler
│   ├── logger/              # AppLogger
│   ├── network/             # HttpClient
│   ├── responsive/          # ResponsiveConfig, ResponsiveBuilder
│   └── theme/               # AppTheme
├── features/todos/
│   ├── helpers/             # Test mocks + shared test data
│   ├── data/
│   │   ├── models/          # TodoModel (fromJson, toJson, toEntity)
│   │   ├── datasources/     # TodoRemoteDataSourceImpl (mock HttpClient)
│   │   └── repositories/    # TodoRepositoryImpl (mock DataSource)
│   └── presentation/
│       └── providers/       # TodosState (filter/sort/search logic), TodosNotifier
└── widget_test.dart         # App smoke test
```

Run tests:
```bash
flutter test
```

---

## Prerequisites

This project uses [FVM (Flutter Version Management)](https://fvm.app/) to pin Flutter `3.35.7`. Install FVM first:

```bash
dart pub global activate fvm
```

Then install the pinned Flutter version:

```bash
fvm install
```

## Getting Started

> **Note:** Prefix all Flutter/Dart commands with `fvm` to use the pinned version. If you have Flutter `3.35.7` installed globally, you can omit the `fvm` prefix.

```bash
# Install dependencies
fvm flutter pub get

# Generate code (Freezed, Riverpod, JSON serialization, Mockito mocks)
fvm dart run build_runner build --delete-conflicting-outputs

# Run the app
fvm flutter run

# Run tests
fvm flutter test

# Generate test coverage
fvm flutter test --coverage

# Generate app icons
fvm dart run flutter_launcher_icons

# Static analysis
fvm flutter analyze
```

---

## Tech Stack

| Category | Package |
|----------|---------|
| State Management | `flutter_riverpod` + `riverpod_annotation` |
| Immutable Models | `freezed_annotation` + `freezed` |
| JSON Serialization | `json_annotation` + `json_serializable` |
| HTTP Client | `http` |
| Network Monitoring | `connectivity_plus` |
| Logging | `logger` |
| Animations | `lottie` |
| Code Generation | `build_runner` + `riverpod_generator` |
| Testing | `mockito` |
| App Icons | `flutter_launcher_icons` |
