---
name: Flutter Template Architect
description: A specialized skill for AI agents working within this specific Feature-Based Clean Architecture Flutter application. Use this skill whenever generating new features, modifying existing code, debugging state logic, adding API integrations, writing UI screens, or referencing the project's patterns. Always use this skill when the user asks to add a screen, API call, route, or feature to this project — even if they phrase it simply.
---

# 🚀 Flutter Template Architect — Complete Project Guide

> **Use this skill** whenever generating new features, modifying existing code,
> debugging state logic, writing tests, or reviewing PRs in this project.

This project follows a **Feature-Based Clean Architecture** built on:

| Layer | Tech | Purpose |
|-------|------|---------|
| State | **RxDart** (`BehaviorSubject`) | Sole reactive state management |
| Network | **Dio** (pre-configured wrappers) | HTTP client |
| DI | **GetIt** | Global singletons |
| Storage | **GetStorage** | Local key-value persistence |
| Scaling | **flutter_screenutil** | Responsive layout scaling |
| Colors | **FlutterGen** (`AppColors`) | Centralized color constants |
| Navigation | **NavigationService** | Global navigator key routing |

---

## 🏗️ 1. Project Architecture

### 1.1 Directory Blueprint

```
lib/
├── common_widgets/          # Shared UI components
│   ├── custom_button.dart
│   ├── custom_textform_field.dart
│   ├── custom_appbar.dart
│   ├── custom_rich_text_button.dart
│   ├── custom_text_button.dart
│   ├── custom_toast.dart
│   ├── loading_indicators.dart
│   ├── no_data_widget.dart
│   ├── not_found_widget.dart
│   ├── waiting_widget.dart
│   └── app_network_image.dart
├── constants/
│   ├── app_constants.dart   # Storage keys (kKey*), regex patterns (AppRegExpText)
│   ├── custome_theme.dart   # Material theme config
│   ├── text_font_style.dart # Pre-defined TextStyles with ScreenUtil (TextFontStyle)
│   └── validator.dart       # Form validators (emailValidator, passwordValidator)
├── features/                # Feature modules (see below)
├── gen/
│   └── colors.gen.dart      # Auto-generated AppColors from assets/color/colors.xml
├── helpers/
│   ├── all_routes.dart      # Route constants (Routes) + RouteGenerator
│   ├── di.dart              # GetIt registration (locator, appData)
│   ├── navigation_service.dart  # Global navigator
│   ├── ui_helpers.dart      # UIHelper spacing utilities
│   ├── helper_methods.dart  # Misc utilities
│   ├── loading_helper.dart  # Future.loader extension (.waitingForFutureWithoutBg())
│   ├── error_message_handler.dart
│   ├── default_response_model.dart
│   ├── location_service.dart
│   ├── notification_service.dart
│   ├── post_login.dart      # performPostLoginActions()
│   ├── register_provider.dart
│   ├── social_auth.dart
│   ├── time_converter.dart
│   ├── toast.dart           # customToastMessage()
│   └── url_lunch.dart
├── networks/
│   ├── api_acess.dart       # Global Rx object instances (one per Rx class)
│   ├── rx_base.dart         # RxResponseInt abstract base class
│   ├── endpoints.dart       # NetworkConstants + Endpoints class
│   └── dio/
│       ├── dio.dart         # DioSingleton + getHttp/postHttp/putHttp/deleteHttp
│       └── log.dart         # Logger interceptor
│   └── exception_handler/
│       ├── data_source.dart # DataSource enum + getFailure()
│       └── error_response.dart
├── main.dart
├── loading_screen.dart
├── welcome_screen.dart
└── navigation_screen.dart
```

### 1.2 Feature Module Structure

Every feature MUST follow this exact structure:

```
lib/features/[feature_name]/
├── data/
│   ├── rx_[verb]_[subject]/    # E.g., rx_get_products, rx_post_login
│   │   ├── api.dart            # Singleton API class — HTTP only
│   │   └── rx.dart             # RxDart controller — stream management
│   └── model/                  # (or models/) — Response model classes
│       └── [feature]_model.dart
└── presentation/
    ├── [feature_name].dart     # Main screen widget
    └── widget/                 # Sub-components for this screen
        └── [widget_name].dart
```

**Key rules:**
- The `data/` directory is optional — simple UI-only features (e.g., `home`) may omit it.
- Each `rx_*` folder must contain both `api.dart` AND `rx.dart`.
- Folder names use `rx_[verb]_[subject]` pattern: `rx_get_products`, `rx_post_login`.

---

## 🔌 2. API Integration Workflow

When adding a new API endpoint, follow these 6 steps **in order**:

### Step 1: Define the Endpoint

Add the URL in `lib/networks/endpoints.dart`:

```dart
final class Endpoints {
  Endpoints._();
  static String users() => "/api/users";
  static String userById(int id) => "/api/users/$id";
  static String products(int pageNum, int perPage) =>
      "/products?page=$pageNum&per_page=$perPage";
}
```

### Step 2: Create the API Class

File: `lib/features/[feature]/data/rx_[action]/api.dart`

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetUsersApi {
  static final GetUsersApi _singleton = GetUsersApi._internal();
  GetUsersApi._internal();
  static GetUsersApi get instance => _singleton;

  Future<Map> getUsersData() async {
    try {
      Response response = await getHttp(Endpoints.users());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow; // Let Rx layer handle errors
    }
  }
}
```

**Mandatory patterns:**
- ✅ `final class` singleton: `_singleton`, `_internal()`, `get instance`
- ✅ Use `getHttp`/`postHttp`/`putHttp`/`deleteHttp` wrappers
- ✅ Import and use `Endpoints.*` — **NEVER** hardcode URLs
- ✅ Use `DataSource.DEFAULT.getFailure()` for error handling
- ✅ `rethrow` in catch — let the Rx layer handle it

### Step 3: Create the Rx Controller

File: `lib/features/[feature]/data/rx_[action]/rx.dart`

```dart
import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetUsersRx extends RxResponseInt {
  final api = GetUsersApi.instance;

  GetUsersRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> fetchUsers() async {
    try {
      Map data = await api.getUsersData();
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}
```

**Mandatory patterns:**
- ✅ `final class` extending `RxResponseInt`
- ✅ `try/catch` with `handleSuccessWithReturn` / `handleErrorWithReturn`
- ✅ `ValueStream get fileData => dataFetcher.stream`
- ✅ Override both handle methods to customize behavior
- ✅ References `*Api.instance`

### Step 4: Register the Rx Object

File: `lib/networks/api_acess.dart`

```dart
import 'package:rxdart/rxdart.dart';
import '../features/[feature]/data/rx_[action]/rx.dart';

GetUsersRx getUsersRxObj =
    GetUsersRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
```

> ⚠️ Note: imports use `'../features/...'` path (relative from `networks/`).

### Step 5: Consume in UI

File: `lib/features/[feature]/presentation/[screen].dart`

```dart
import '../../../networks/api_acess.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    getUsersRxObj.fetchUsers();  // Trigger API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getUsersRxObj.fileData,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return _buildContent(snapshot.data!);
          } else if (snapshot.hasError) {
            return const NotFoundWidget();
          }
          return const WaitingWidget();
        },
      ),
    );
  }
}
```

### Step 6: Register Route (if navigable)

File: `lib/helpers/all_routes.dart`

```dart
// 1. Add route constant in Routes class
static const String usersScreen = '/UsersScreen';

// 2. Add case in RouteGenerator.generateRoute()
case Routes.usersScreen:
  return defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoPageRoute(builder: (context) => const UsersScreen())
      : _FadedTransitionRoute(
          widget: const UsersScreen(), settings: settings);

// 3. For screens that receive arguments:
case Routes.productDetailsScreen:
  final args = settings.arguments as Map;
  return defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoPageRoute(
          builder: (context) =>
              ProductDetailsScreen(productId: args['productId']))
      : _FadedTransitionRoute(
          widget: ProductDetailsScreen(productId: args['productId']),
          settings: settings);
```

---

## 🛡️ 3. Code Quality Rules

### 3.1 ScreenUtil — MANDATORY

**Every** layout dimension in presentation files must use ScreenUtil extensions:

| Property | Extension | Example |
|----------|-----------|---------| 
| Height, vertical | `.h` | `height: 60.h` |
| Width, horizontal | `.w` | `width: 200.w`, `EdgeInsets.all(16.w)` |
| Border radius | `.r` | `BorderRadius.circular(12.r)` |
| Font size, icon size | `.sp` | `fontSize: 14.sp`, `size: 24.sp` |

**Exceptions** (raw numbers OK):
- Line-height multiplier: `height: 1.5` inside `.copyWith()`
- `childAspectRatio`, `crossAxisCount`, `flex`, `Offset`, `opacity`, `alpha`

❌ `height: 120` → ✅ `height: 120.h`  
❌ `SizedBox(width: 20)` → ✅ `SizedBox(width: 20.w)`  
❌ `EdgeInsets.all(16)` → ✅ `EdgeInsets.all(16.w)`

### 3.2 Colors — Use AppColors

Always use `AppColors` from `lib/gen/colors.gen.dart`.

**Allowed exceptions:**
- `Colors.transparent` ✅
- `Colors.black` ✅
- `Colors.white` ✅

❌ `Colors.green` → ✅ `AppColors.c4CAF50`

**Adding new colors / assets / fonts — FlutterGen:**

```bash
# Regenerate after changing colors.xml, adding assets, or updating fonts:
fluttergen -c pubspec.yaml
```

| Resource | Source file | Generated output |
|----------|-----------|-----------------|
| Colors | `assets/color/colors.xml` | `lib/gen/colors.gen.dart` (`AppColors`) |
| Assets | `assets/` directories | `lib/gen/assets.gen.dart` |
| Fonts | `pubspec.yaml` font declarations | `lib/gen/fonts.gen.dart` |

**Workflow:** Add hex → run fluttergen → use `AppColors.cXXXXXX`.

### 3.3 Navigation — Use NavigationService

**NEVER** use `Navigator.of(context)`, `Navigator.push()`, or `Navigator.pop()`.

```dart
// ✅ Correct
NavigationService.navigateTo(Routes.usersScreen);
NavigationService.navigateToWithArgs(Routes.details, {'id': 42});
NavigationService.navigateToWithObject(Routes.details, someObject);
NavigationService.goBack;
NavigationService.goBackCall();         // safe version (uses ?. instead of !)
NavigationService.navigateToReplacement(Routes.home);
NavigationService.navigateToUntilReplacement(Routes.login);
NavigationService.popAndReplace(Routes.home);
NavigationService.popAndReplaceWihArgs(Routes.home, {'key': 'val'});
bool canPop = NavigationService.goBeBack;
BuildContext? ctx = NavigationService.context;
```

### 3.4 State Management — RxDart ONLY

**FORBIDDEN:** `provider`, `riverpod`, `flutter_bloc`, `mobx`, `getx`

- Stream flow: **API → Rx Controller → StreamBuilder in UI**
- Use `BehaviorSubject` for all reactive streams
- Never call API methods directly from widgets

### 3.5 Text Styles — Use TextFontStyle

Use pre-defined styles from `lib/constants/text_font_style.dart`:

```dart
// Naming convention: textStyle{size}c{hexColor}{Font}{Weight}
Text("Hello", style: TextFontStyle.textStyle26c202020DMSans600);
Text("Sub", style: TextFontStyle.textStyle14c606060DMSans400);
```

To add a new style, append to `TextFontStyle` class following the same naming pattern.

### 3.6 Loading — Use .waitingForFutureWithoutBg()

```dart
// In presentation code — shows loading overlay automatically
final success = await someRxObj
    .someMethod()
    .waitingForFutureWithoutBg();  // extension from loading_helper.dart
```

### 3.7 Code Style

| Rule | Detail |
|------|--------|
| No `print()` | Use `dart:developer` `log()` instead |
| No `var` in data layer | Use explicit types in `api.dart` and `rx.dart` |
| Use `final class` | All API, Rx, and service classes should be `final class` |
| Reuse common widgets | Use `CustomButton`, `CustomTextFormField`, `WaitingWidget`, etc. |
| No hardcoded URLs | All API URLs go in `Endpoints` class |
| Explicit types | Prefer `final String name` over `var name` |
| Null safety | Use `?`, `!`, `??` properly; never force-unwrap without guard |
| Toast messages | Use `customToastMessage('Title', 'Body')` from `helpers/toast.dart` |

---

## 📁 4. Key Files Reference

### `lib/networks/rx_base.dart` — Base Class for All Rx Controllers

```dart
abstract class RxResponseInt<T> {
  T empty;
  BehaviorSubject<T> dataFetcher;
  Map? map;                    // optional secondary data map
  BehaviorSubject? dataFetcher2; // optional secondary stream

  RxResponseInt({
    required this.empty,
    required this.dataFetcher,
    this.map,
    this.dataFetcher2,
  });

  dynamic handleSuccessWithReturn(T data) {
    dataFetcher.sink.add(data);
    return data;
  }

  dynamic handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }

  void clean() => dataFetcher.sink.add(empty);
  void dispose() => dataFetcher.close();
}
```

### `lib/networks/endpoints.dart` — Endpoint Definitions

```dart
const String url = "https://your-api-base-url.com";

final class NetworkConstants {
  static const ACCEPT = "Accept";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
  static const ACCEPT_TYPE = "application/json";
  // ...
}

final class Endpoints {
  Endpoints._();
  static String logIn() => "/auth/login";
  static String signUp() => "/auth/register";
  static String profile() => "/user/profile";
  static String products(int pageNum, int perPage) =>
      "/products?page=$pageNum&per_page=$perPage";
  static String productDetails(int id) => "/products/$id";
}
```

### `lib/networks/dio/dio.dart` — HTTP Wrappers

```dart
// DioSingleton — manages Dio instance lifecycle
DioSingleton.instance.create();        // Initial setup (unauthenticated)
DioSingleton.instance.update(token);  // Update with auth token

// HTTP method wrappers — always use these, never raw Dio
Future<Response> getHttp(String path, [dynamic data]);
Future<Response> postHttp(String path, [dynamic data]);
Future<Response> putHttp(String path, [dynamic data]);
Future<Response> deleteHttp(String path, [dynamic data]);
```

### `lib/helpers/di.dart` — Dependency Injection

```dart
final locator = GetIt.instance;
final appData = locator.get<GetStorage>();  // Use this everywhere for storage

void diSetup() {
  locator.registerSingleton<GetStorage>(GetStorage());
}
```

### `lib/helpers/navigation_service.dart` — All Available Methods

| Method | Description |
|--------|-------------|
| `navigateTo(route)` | Push named route |
| `navigateToReplacement(route)` | Replace current with named route |
| `navigateToUntilReplacement(route)` | Clear stack, push route |
| `navigateToWithArgs(route, Map?)` | Push with `Map` arguments |
| `navigateToWithObject(route, Object?)` | Push with object argument |
| `popAndReplace(route)` | Pop current, push route |
| `popAndReplaceWihArgs(route, Map?)` | Pop current, push route with args |
| `goBack` | Pop current route (getter) |
| `goBackCall()` | Safe pop (uses `?.`) |
| `goBeBack` | Returns `bool` — can pop? |
| `context` | Get current `BuildContext?` |

### `lib/helpers/ui_helpers.dart` — Spacing Utilities

```dart
// Custom spacing
UIHelper.verticalSpace(8.h)      // SizedBox(height: value)
UIHelper.horizontalSpace(12.w)   // SizedBox(width: value)

// Preset vertical spacings (all use .w internally)
UIHelper.verticalSpaceSmall         // 10.w
UIHelper.verticalSpaceMedium        // 20.w
UIHelper.verticalSpaceMediumLarge   // 25.w
UIHelper.verticalSpaceSemiLarge     // 40.w
UIHelper.verticalSpaceLarge         // 60.w
UIHelper.verticalSpaceExtraLarge    // 100.w

// Preset horizontal spacings (use .h internally)
UIHelper.horizontalSpaceSmall       // 10.h
UIHelper.horizontalSpaceMedium      // 20.h
UIHelper.horizontalSpaceSemiLarge   // 40.h
UIHelper.horizontalSpaceLarge       // 60.h

// Default padding
UIHelper.kDefaulutPadding()         // 20.sp
UIHelper.safePadding()              // MediaQuery top padding
```

### `lib/constants/app_constants.dart` — Storage Keys

```dart
// Key constants for GetStorage (appData.write/read)
const String kKeyIsLoggedIn = 'is_logged_in';
const String kKeyAccessToken = 'access_token';
const String kKeyUserID = 'user_id';
const String kKeyIsExploring = 'exploring';
const String kKeyDeviceToken = 'device_token';
const String kKeyFCMToken = 'firebase_token';
// ... and many more (kPhone, kKeySelectedLocation, etc.)

// Regex (in AppRegExpText class)
AppRegExpText.kRegExpEmail
AppRegExpText.kRegExpPhone
AppRegExpText.patternMail
```

### `lib/constants/validator.dart` — Form Validators

```dart
// Use directly as validator parameter in CustomTextFormField
CustomTextFormField(validator: emailValidator, ...)
CustomTextFormField(validator: passwordValidator, ...)
```

---

## 🧩 5. Common Widgets Catalogue

| Widget | File | Usage |
|--------|------|-------|
| `customButton(...)` | `custom_button.dart` | Primary action button |
| `CustomTextFormField(...)` | `custom_textform_field.dart` | Form input field |
| `CustomAppBar(...)` | `custom_appbar.dart` | Reusable app bar |
| `CustomRichTextButton(...)` | `custom_rich_text_button.dart` | "Already have account? **Sign In**" |
| `CustomTexButton(...)` | `custom_text_button.dart` | Plain text button |
| `WaitingWidget()` | `waiting_widget.dart` | Loading state |
| `NotFoundWidget()` | `not_found_widget.dart` | Error/empty state |
| `NoDataWidget(...)` | `no_data_widget.dart` | Empty data state with image |
| `AppNetworkImage(...)` | `app_network_image.dart` | Cached network image |
| `customToastMessage(title, body)` | `helpers/toast.dart` | Toast notification |

---

## 🔧 6. Architecture Analyzer

```bash
dart run tool/analyze_architecture.dart           # standard
dart run tool/analyze_architecture.dart --verbose  # verbose
```

**8 check categories:** Structure, API Layer, Rx Layer, Endpoints, Code Quality, DI & Routes, Common Widgets, Pubspec.

Score: 🎉 PERFECT (0 warnings, 0 failures) | ⚡ Good shape | 🚨 Fix before shipping

---

## 🧹 7. Starting a New Project (Template Cleanup)

1. **Delete sample features**: `auth/`, `product/`, `home/`, `user_profile/`
2. **Remove their routes** from `lib/helpers/all_routes.dart`
3. **Remove their Rx objects** from `lib/networks/api_acess.dart`
4. **Keep `example/`** as an architectural blueprint (safely commented out)
5. **Update identifiers**: `applicationId` (Android), `bundleId` (iOS), package name in `pubspec.yaml`
6. **Update `endpoints.dart`** with your API base URL (`const String url = "..."`)
7. **Run `dart run tool/analyze_architecture.dart`** to verify clean state

---

## ⚠️ 8. Strict Rules Checklist

Before committing any code, verify:

- [ ] Feature follows `features/[name]/data/rx_*/` + `presentation/` structure
- [ ] API class is `final class` with singleton pattern + Dio wrappers
- [ ] Rx class is `final class` extending `RxResponseInt` with try/catch + overrides
- [ ] Rx object registered in `api_acess.dart`
- [ ] All layout values use `.h`, `.w`, `.sp`, `.r` extensions
- [ ] Colors use `AppColors.*`, not `Colors.*` (except transparent/black/white)
- [ ] Navigation uses `NavigationService`, not `Navigator`
- [ ] No `provider`, `riverpod`, or `flutter_bloc` imports
- [ ] No `print()` — use `log()` from `dart:developer`
- [ ] No hardcoded API URLs — everything through `Endpoints`
- [ ] Text styles use `TextFontStyle.*` constants
- [ ] Route registered in `all_routes.dart` (if screen is navigable)
- [ ] Tests use `setUpTestDependencies()` and `pump()` (not `pumpAndSettle()`)
- [ ] `dart run tool/analyze_architecture.dart` passes with 0 failures

---

## 📚 9. Offline Documentation

Flutter 3.41.1 docs are available locally at `flutter_doc/` directory.
Use `view_file` or `grep_search` against these files when you need to check a Flutter API without web searching.
