---
name: Testing & Architecture Analyzer
description: A skill for running architecture analysis, writing widget tests, and maintaining code quality in this Flutter template project. Use this skill when generating tests, debugging test failures, or auditing project structure. Always use this skill when the user asks to write a test, run the analyzer, or check if their new feature follows the correct architecture.
---

# 🧪 Testing & Architecture Analyzer Skill

This project has two quality tools: a **Dart CLI architecture analyzer** and a **widget test suite** using `flutter_test` + `mocktail`. Follow these rules strictly when writing or modifying tests.

---

## 🔍 1. Architecture Analyzer Script

**Location:** `tool/analyze_architecture.dart`

### How to Run
```bash
dart run tool/analyze_architecture.dart           # standard report
dart run tool/analyze_architecture.dart --verbose  # line-by-line details
```

### What It Checks (8 Categories)

| # | Category | Key Rules |
|---|----------|-----------| 
| 1 | **Structure** | Every feature has `data/` + `presentation/`, rx_* naming, api.dart + rx.dart pairs |
| 2 | **API Layer** | Singleton pattern, Dio wrappers (`getHttp`/`postHttp`), `endpoints.dart` import, no hardcoded URLs |
| 3 | **Rx Layer** | Extends `RxResponseInt`, try/catch, `handleSuccessWithReturn`/`handleErrorWithReturn`, `ValueStream` |
| 4 | **Endpoints** | No URLs/API paths outside `endpoints.dart` |
| 5 | **Code Quality** | ScreenUtil `.h`/`.w`/`.r`/`.sp`, `AppColors` not `Colors.*`, `NavigationService` not `Navigator`, no provider/riverpod/bloc |
| 6 | **DI & Routes** | `api_access.dart` registrations, `all_routes.dart` import validity, orphaned features |
| 7 | **Common Widgets** | Flags duplicate widget implementations |
| 8 | **Pubspec** | Required deps: rxdart, dio, get_it, get_storage, flutter_screenutil, mocktail |

### Exit Codes
- `0` = all checks pass
- `1` = one or more failures detected

### Extending the Analyzer
To add a new check category:
1. Create a `void checkXxx(Directory libDir, String root)` function
2. Use `pass()`, `warn()`, `fail()` to record results
3. Call it from `main()` before `printReport()`

---

## 🧩 2. Widget Test Suite

**Location:** `test/`

### Project Test Structure
```
test/
├── helpers/
│   └── test_helpers.dart          # Reusable harness (setUpTestDependencies, testableWidget, etc.)
├── common_widgets/
│   ├── custom_button_test.dart
│   └── custom_textform_field_test.dart
└── features/
    ├── auth/
    │   ├── login_test.dart
    │   └── signup_test.dart
    └── home/
        └── home_test.dart
```

### How to Run
```bash
flutter test                           # run all tests
flutter test test/features/auth/       # run specific feature tests
flutter test --coverage                # generate coverage report
```

---

## ⚙️ 3. Test Harness Rules (MANDATORY)

Every widget test **MUST** use the test harness from `test/helpers/test_helpers.dart`.

### Setup/Teardown Pattern
```dart
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpTestDependencies();   // Stubs path_provider, inits GetStorage, resets GetIt
  });

  tearDownAll(() async {
    await tearDownTestDependencies(); // Resets GetIt
  });

  group('MyScreen', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(testableWidget(const MyScreen()));
      await tester.pump();  // Use pump(), NOT pumpAndSettle()
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
```

### Two Wrapper Functions

| Function | Use When |
|----------|----------|
| `testableWidget(child)` | Screen needs ScreenUtil `.h/.w/.r/.sp`, NavigationService, or RouteGenerator |
| `simpleTestableWidget(child)` | Simple widget with no ScreenUtil or routing deps (e.g., `CustomTextFormField`) |

---

## ⚠️ 4. Common Test Pitfalls

### `pumpAndSettle` Timeouts
**Never** use `pumpAndSettle()` when the widget contains an infinite animation (e.g., `CircularProgressIndicator`, Lottie loops). Use `pump()` instead:
```dart
// ❌ BAD — will timeout on WaitingWidget / loading indicators
await tester.pumpAndSettle();

// ✅ GOOD
await tester.pump();
```

### RichText / TextSpan Content
`find.text()` does **NOT** match text inside `TextSpan` (used by `CustomRichTextButton`). Use `find.byWidgetPredicate`:
```dart
final finder = find.byWidgetPredicate((widget) {
  if (widget is RichText) {
    return widget.text.toPlainText().contains('Sign Up');
  }
  return false;
});
expect(finder, findsOneWidget);
```

### Off-Screen Widgets in Scrollable Forms
Widgets below the fold (e.g., checkboxes at bottom of long forms) are off-screen in the 800×600 test viewport:
```dart
await tester.ensureVisible(find.byType(Checkbox));
await tester.pump();
await tester.tap(find.byType(Checkbox));
```

### GetStorage MissingPluginException
Always use `setUpTestDependencies()` from the harness — it stubs the `path_provider` platform channel before calling `GetStorage.init()`.

### Testing Screens with StreamBuilder
For screens that consume Rx streams, inject test data directly into the `BehaviorSubject`:
```dart
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/networks/api_acess.dart';

// In setUpAll or test body — push mock data into the stream
getProductsRxObj.dataFetcher.sink.add({
  'success': true,
  'data': [{'id': 1, 'name': 'Test Product'}],
});

// Then pump the widget and assert on rendered content
await tester.pumpWidget(testableWidget(const ProductsScreen()));
await tester.pump();
expect(find.text('Test Product'), findsOneWidget);
```

---

## 📝 5. Writing Tests for a New Feature

When a new feature is created at `lib/features/[name]/`, add tests at `test/features/[name]/`:

1. **Create test file** — `test/features/[name]/[screen_name]_test.dart`
2. **Import harness** — `import '../../helpers/test_helpers.dart';`
3. **Add setUpAll/tearDownAll** — call `setUpTestDependencies()` / `tearDownTestDependencies()`
4. **Wrap screen** — use `testableWidget(const MyScreen())`
5. **Test these minimum checks:**
   - Screen renders without errors (`find.byType(Scaffold)`)
   - Key UI text elements are present (`find.text(...)`)
   - Form fields exist and accept input (if applicable)
   - Buttons exist and are tappable
   - StreamBuilder states: loading (`WaitingWidget`), data, error (`NotFoundWidget`)

### Minimum Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_flutter/features/auth/presentation/login.dart';
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpTestDependencies();
  });

  tearDownAll(() async {
    await tearDownTestDependencies();
  });

  group('LoginScreen', () {
    testWidgets('renders without error', (tester) async {
      await tester.pumpWidget(testableWidget(const LoginScreen()));
      await tester.pump();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(testableWidget(const LoginScreen()));
      await tester.pump();
      // CustomTextFormField wraps TextField
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('shows sign in button', (tester) async {
      await tester.pumpWidget(testableWidget(const LoginScreen()));
      await tester.pump();
      expect(find.text('Sign In'), findsOneWidget);
    });
  });
}
```

---

## 🏗️ 6. Architecture Compliance Checklist

Run before every PR. Each item maps to an analyzer check category:

| Check | Category | Passes When |
|-------|----------|-------------|
| Feature has `data/` + `presentation/` | Structure | Both dirs exist |
| `rx_*` dirs have `api.dart` + `rx.dart` | Structure | Both files present |
| API class is `final class` singleton | API Layer | Pattern matches |
| API uses `getHttp`/`postHttp` wrappers | API Layer | No raw `Dio()` calls |
| API imports `Endpoints.*` | API Layer | No hardcoded strings |
| Rx extends `RxResponseInt` | Rx Layer | Class declaration |
| Rx has `try/catch` in methods | Rx Layer | Wraps API calls |
| Rx overrides handle methods | Rx Layer | Both overrides present |
| No URLs in non-endpoint files | Endpoints | No `"/api/..."` strings |
| ScreenUtil on all dimensions | Code Quality | `.h`, `.w`, `.sp`, `.r` |
| `AppColors.*` (not `Colors.*`) | Code Quality | Exception: transparent/black/white |
| `NavigationService` (not `Navigator`) | Code Quality | No direct Navigator calls |
| Rx objects in `api_acess.dart` | DI & Routes | Registration exists |
| Routes in `all_routes.dart` | DI & Routes | `Routes.*` const + case |
| No duplicate widgets | Common Widgets | No reimplemented basics |
| All required deps in pubspec | Pubspec | rxdart, dio, get_it, etc. |
