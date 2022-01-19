## flutter_dialog_manager

A Flutter package that allows for neater declaration, abstraction and use of customisable dialogs.

## Install

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  flutter_dialog_manager: ^1.0.0+1
```

Import the package in your project:

```dart
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
```

## Getting started

Wrap your MaterialApp widget with a `DialogManager`
and pass the required `GlobalKey<NavigatorState> navigatorKey` parameter.
Also pass the navigator key to `MaterialApp`.

```dart
@override
  Widget build(BuildContext context) {
    return DialogManager(
      navigatorKey: _navigatorKey,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorKey: _navigatorKey,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    )
```

## Usage

Declare dialog UI implementations and their associated route names with `onGenerateDialogs` or `dialogRoutes` 

```dart
  onGenerateDialogs: (settings) {
        switch (settings.name) {
          case "/counter":
            if (settings.arguments != null) {
              return CounterDialog(
                counter: settings.arguments as int,
              );
            }
            break;
      }}
```

```dart
 dialogRoutes: {
        "/": (context) => DefaultDialog(),
        "/home": (context) => HomeDialog(),
      }
```

Show dialog in your UI

```dart
 DialogManager.of(context).showDialog(
      routeName: "/counter",
      arguments: _counter,
    );
```

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/Crazelu/dialog-manager/issues).  
If you fixed a bug or implemented a feature, please send a [pull request](https://github.com/Crazelu/dialog-manager/pulls).
