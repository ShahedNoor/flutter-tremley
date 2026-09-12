---
name: RxDart Reactive Programming
description: A skill for working with RxDart-based reactive state management in this Flutter template. Use this skill when creating, debugging, or extending Rx controllers, API integrations, and stream-based UI patterns. Always use this skill when the user asks to add an API call, Rx controller, or StreamBuilder-based screen — even if they don't mention RxDart by name.
---

# 🔄 RxDart Reactive Programming Skill

This project uses **RxDart** (`rxdart: ^0.28.0`) as its **sole state management solution**. There is **NO** Provider, Riverpod, Bloc, or MobX. All reactive state flows through RxDart `BehaviorSubject` streams, following an **API → Rx → UI** pipeline.

> **Official Docs:** [pub.dev/packages/rxdart](https://pub.dev/packages/rxdart) | [API Reference](https://pub.dev/documentation/rxdart/latest/rx/rx-library.html)

---

## 🏗️ 1. Architecture: Why RxDart Instead of Provider/Riverpod

| Concern | How RxDart Handles It |
|---------|----------------------|
| **State storage** | `BehaviorSubject<T>` — caches last value, replays to new listeners |
| **State updates** | `.sink.add(data)` pushes new state |
| **UI reactivity** | `StreamBuilder(stream: rxObj.fileData)` rebuilds on new events |
| **Error handling** | `.sink.addError(err)` + centralized `ErrorMessageHandler` |
| **Dependency injection** | Global Rx objects in `api_acess.dart` — no `ChangeNotifier`, no `StateNotifier` |
| **Stream composition** | RxDart operators: `debounceTime`, `switchMap`, `combineLatest`, etc. |

**This architecture is intentional.** Do NOT introduce any other state management library.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   API Layer  │────▶│   Rx Layer   │────▶│   UI Layer   │
│  (api.dart)  │     │  (rx.dart)   │     │ (screen.dart)│
│              │     │              │     │              │
│  final class │     │  final class │     │ StreamBuilder │
│  Singleton   │     │  extends     │     │  snapshot    │
│  Dio HTTP    │     │  RxResponseInt│    │  .hasData    │
│  Endpoints.* │     │  BehaviorSubj│     │  .hasError   │
└──────────────┘     └──────────────┘     └──────────────┘
```

---

## 📦 2. Core: `BehaviorSubject<T>` (Official API)

> **Source:** [BehaviorSubject class](https://pub.dev/documentation/rxdart/latest/rx/BehaviorSubject-class.html)

A special `StreamController` that:
- **Caches the latest item** added to the controller
- **Emits that cached item** as the first event to any new listener
- Is a **broadcast (hot) controller** — multiple listeners allowed

```dart
// Without seed — starts empty
final subject = BehaviorSubject<int>();
subject.add(3);
subject.stream.listen(print); // prints 3 (latest cached value)

// With seed — starts with initial value
final seeded = BehaviorSubject<int>.seeded(0);
seeded.stream.listen(print); // prints 0 immediately
```

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `value` | `T` | Synchronously read the last emitted value |
| `valueOrNull` | `T?` | Same as `value` but nullable if no value emitted |
| `hasValue` | `bool` | `true` if at least one value has been emitted |
| `hasError` | `bool` | `true` if the last event was an error |
| `stream` | `ValueStream<T>` | The observable stream |
| `sink` | `StreamSink<T>` | Add data/errors to the subject |
| `isClosed` | `bool` | Whether `close()` has been called |

---

## 🧬 3. Base Class: `RxResponseInt<T>` (Project-Specific)

**Location:** `lib/networks/rx_base.dart`

Every Rx controller in this project extends this abstract class:

```dart
abstract class RxResponseInt<T> {
  T empty;                          // Reset value (usually {})
  BehaviorSubject<T> dataFetcher;   // Primary reactive stream
  Map? map;                         // Optional secondary data (rarely used)
  BehaviorSubject? dataFetcher2;    // Optional secondary stream (rarely used)

  RxResponseInt({
    required this.empty,
    required this.dataFetcher,
    this.map,
    this.dataFetcher2,
  });

  dynamic handleSuccessWithReturn(T data) {
    dataFetcher.sink.add(data);   // Push data to UI
    return data;
  }

  dynamic handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }

  void clean() => dataFetcher.sink.add(empty);  // Reset stream
  void dispose() => dataFetcher.close();         // Close permanently
}
```

### Override Pattern
Always override both handle methods in your Rx controllers:

```dart
@override
handleSuccessWithReturn(data) async {
  // Custom: save auth token, navigate, update storage, etc.
  String? token = data['data']['token'];
  DioSingleton.instance.update(token!);
  await appData.write(kKeyAccessToken, token);
  dataFetcher.sink.add(data);  // Always push to stream
  return true;
}

@override
handleErrorWithReturn(error) {
  ErrorMessageHandler.showErrorToast(error); // One call is sufficient
  return false;
}
```

---

## 🔌 4. Creating a GET Rx Controller (Complete Template)

### Step 1: Endpoint (`lib/networks/endpoints.dart`)
```dart
final class Endpoints {
  Endpoints._();
  static String users() => "/users";
}
```

### Step 2: API Class (`data/rx_get_users/api.dart`)
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
      rethrow;  // Let Rx layer handle errors
    }
  }
}
```

### Step 3: Rx Controller (`data/rx_get_users/rx.dart`)
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

### Step 4: Register (`lib/networks/api_acess.dart`)
```dart
import 'package:rxdart/rxdart.dart';
import '../features/users/data/rx_get_users/rx.dart';

GetUsersRx getUsersRxObj =
    GetUsersRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
```

### Step 5: UI (`presentation/users_screen.dart`)
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
    getUsersRxObj.fetchUsers();
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

---

## 📤 5. POST Rx Controller with Auth Token

POST controllers follow the same pattern but override `handleSuccessWithReturn` to persist auth:

```dart
final class PostLoginRx extends RxResponseInt {
  final api = PostLoginApi.instance;
  PostLoginRx({required super.empty, required super.dataFetcher});

  ValueStream get getPostLoginRes => dataFetcher.stream;

  Future<bool> postLogin({
    required String email,
    required String password,
  }) async {
    try {
      Map<String, dynamic> data = {"email": email, "password": password};
      Map resdata = await api.postLogIn(data);
      return await handleSuccessWithReturn(resdata);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    String? accesstoken = data['data']['token'];
    int id = data['data']['user']['id'];
    DioSingleton.instance.update(accesstoken!);
    await appData.write(kKeyIsLoggedIn, true);
    await appData.write(kKeyUserID, id);
    await appData.write(kKeyAccessToken, accesstoken);
    dataFetcher.sink.add(data);
    performPostLoginActions();  // from helpers/post_login.dart
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}
```

**Consuming a POST result in UI (boolean return pattern):**
```dart
Future<void> _login() async {
  setState(() => _isLoading = true);
  try {
    final success = await postLoginRxObj
        .postLogin(email: _emailController.text.trim(), password: ...)
        .waitingForFutureWithoutBg();  // from helpers/loading_helper.dart

    if (success) {
      customToastMessage('Success', 'Logged in!');
      NavigationService.navigateTo(Routes.homeScreen);
    }
  } catch (e) {
    customToastMessage('Failed', 'Login failed. Please try again.');
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}
```

---

## 🛠️ 6. RxDart Operators Reference

> **Full list:** [pub.dev/packages/rxdart#extension-methods](https://pub.dev/packages/rxdart#extension-methods)

| Operator | What It Does | Use Case |
|----------|-------------|----------|
| `debounceTime(Duration)` | Waits for a pause in events | Search-as-you-type |
| `throttleTime(Duration)` | Limits emission rate | Scroll events, button spam |
| `switchMap(fn)` | Cancels previous inner stream | API calls that replace previous |
| `distinctUnique()` | Filters duplicate consecutive values | Avoid redundant rebuilds |
| `startWith(value)` | Prepends a value before stream events | Default/loading state |
| `scan(accumulator, seed)` | Reduces stream to accumulated value | Pagination |
| `combineLatest` | Combines latest from multiple streams | Dashboard with multiple sources |
| `mergeWith([streams])` | Merges multiple streams into one | Multiple event sources |
| `onErrorReturn(value)` | Replace errors with fallback | Graceful degradation |
| `whereNotNull()` | Filters null values | Clean data pipeline |

### Example: Search with Debounce
```dart
final searchSubject = BehaviorSubject<String>.seeded('');

searchSubject.stream
    .debounceTime(const Duration(milliseconds: 300))
    .where((query) => query.length >= 2)
    .distinct()
    .switchMap((query) => Stream.fromFuture(api.search(query)))
    .listen((results) {
      searchResultsSubject.add(results);
    });

// In UI text field:
onChanged: (text) => searchSubject.add(text),
```

### Example: Combining Streams
```dart
Rx.combineLatest2(
  getProductsRxObj.fileData,
  profileRxObj.fileData,
  (products, profile) => {'products': products, 'profile': profile},
).listen((combined) {
  dashboardSubject.add(combined);
});
```

---

## 🧩 7. Subjects Reference

| Subject | Description | This Project Uses |
|---------|-------------|-------------------|
| **`BehaviorSubject`** | Caches latest value, replays to new listeners | ✅ **Primary** |
| **`ReplaySubject`** | Caches ALL values, replays full history | ❌ Not used |

---

## ⚠️ 8. Rules & Common Mistakes

### ❌ NEVER Do

| Rule | Explanation |
|------|-------------|
| Use `Provider`/`Riverpod`/`Bloc`/`MobX` | This project uses RxDart exclusively |
| Call API from UI directly | Always go through the Rx controller |
| Use raw `Dio()` | Use `getHttp()`/`postHttp()` wrappers from `dio.dart` |
| Hardcode URLs in api.dart | Use `Endpoints.*` from `endpoints.dart` |
| Use `StreamController` | Use `BehaviorSubject` (replays last value) |
| Create Rx objects inside widgets | Register globally in `api_acess.dart` |
| Forget try/catch in Rx methods | Always wrap API calls in try/catch |
| Forget to override handle methods | Always override both in every Rx class |

### ✅ ALWAYS Do

| Rule | Explanation |
|------|-------------|
| Use `final class` for API + Rx | Prevents unintended subclassing |
| Extend `RxResponseInt` | All Rx controllers inherit from the base class |
| Override `handleSuccessWithReturn` | Customize success behavior per feature |
| Override `handleErrorWithReturn` | Keeps error toast to a single call |
| Use `ValueStream get fileData =>` | Expose the stream as a `ValueStream` getter |
| Register in `api_acess.dart` | One global instance per Rx class |
| Use `StreamBuilder` in UI | The standard pattern for observing Rx streams |

---

## 📚 9. Quick Reference: New API Checklist

- [ ] `lib/networks/endpoints.dart` — add `static String myEndpoint() => "/path";`
- [ ] `lib/features/[name]/data/rx_[verb]_[name]/api.dart` — `final class` singleton API
- [ ] `lib/features/[name]/data/rx_[verb]_[name]/rx.dart` — `final class` Rx extending `RxResponseInt` with overrides
- [ ] `lib/networks/api_acess.dart` — register `MyRx myRxObj = MyRx(empty: {}, dataFetcher: BehaviorSubject<Map>());`
- [ ] `lib/features/[name]/presentation/screen.dart` — `StreamBuilder` consuming the stream
- [ ] `test/features/[name]/screen_test.dart` — widget test (see Testing & Architecture Analyzer skill)
