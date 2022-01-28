import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:flutter/material.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogManager(
      navigatorKey: _navigatorKey,
      onGenerateDialog: (settings) {
        switch (settings.name) {
          case "/counter":
            if (settings.arguments != null) {
              return CounterDialog(
                counter: settings.arguments as int,
              );
            }
            break;
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.blue,
              ),
              foregroundColor: MaterialStateProperty.resolveWith(
                (states) => Colors.white,
              ),
            ),
          ),
        ),
        navigatorKey: _navigatorKey,
        home: const DemoPage(),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter Dialog Demo Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () {
                _incrementCounter();
                DialogManager.of(context).showDialog(
                  routeName: "/counter",
                  arguments: _counter,
                );
              },
              child: const Text("Show counter dialog"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterDialog extends StatelessWidget {
  final int counter;

  const CounterDialog({
    Key? key,
    required this.counter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      builder: (dialogKey) => Container(
        key: dialogKey,
        height: 250,
        width: 300,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You have pushed the button this many times:",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              "$counter",
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => DialogManager.of(context).dismissDialog(),
              child: const Text("Ok"),
            ),
          ],
        ),
      ),
    );
  }
}
