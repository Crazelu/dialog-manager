import 'package:example/form_dialog.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:example/counter_dialog.dart';
import 'package:example/dialog_handler.dart';
import 'package:example/floating_dialog.dart';
import 'package:flutter/material.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
DialogHandler dialogHandler = DialogHandlerImpl();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogManager(
      dialogKey: dialogHandler.dialogKey,
      navigatorKey: _navigatorKey,
      onGenerateDialogs: (settings) {
        switch (settings.name) {
          case "/counter":
            if (settings.arguments != null) {
              return CounterDialog(
                counter: settings.arguments as int,
              );
            }
            break;
          case "/floating":
            if (settings.arguments != null) {
              final argument = settings.arguments as FloatingDialogArg;
              return FloatingDialog(
                message: argument.message,
                status: argument.status,
              );
            }
            break;
          case "/form":
            return const FormDialog();
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
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    DialogManager.of(context).showDialog(
      routeName: "/counter",
      arguments: _counter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                TextButton(
                  onPressed: () {
                    DialogManager.of(context).showDialog(
                      routeName: "/floating",
                      arguments: FloatingDialogArg(
                        message: "Successfully tapped this button. Yay!",
                        status: FloatingDialogStatus.success,
                      ),
                    );
                  },
                  child: const Text("Show floating success dialog"),
                ),
                TextButton(
                  onPressed: () {
                    DialogManager.of(context).showDialog(
                      routeName: "/floating",
                      arguments: FloatingDialogArg(
                        message: "Ugh! An unexpected error occurred",
                        status: FloatingDialogStatus.error,
                      ),
                    );
                  },
                  child: const Text("Show floating error dialog"),
                ),
                TextButton(
                  onPressed: () {
                    DialogManager.of(context).showDialog(
                      routeName: "/floating",
                      arguments: FloatingDialogArg(
                        message: "FYI, I'm a cool little info dialog",
                        status: FloatingDialogStatus.info,
                      ),
                    );
                  },
                  child: const Text("Show floating info dialog"),
                ),
                TextButton(
                  onPressed: () {
                    DialogManager.of(context).showDialog(
                      routeName: "/floating",
                      autoDismiss: true,
                      arguments: FloatingDialogArg(
                        message: "I will self destruct in a moment",
                        status: FloatingDialogStatus.info,
                      ),
                    );
                  },
                  child: const Text("Show auto dismissible floating dialog"),
                ),

                //show dialog using a service that abstracts the dialog key
                TextButton(
                  onPressed: () {
                    dialogHandler.showDialog(
                      routeName: "/floating",
                      arguments: FloatingDialogArg(
                        message:
                            "Hehe, a dialog key abstraction brought me here ey?",
                        status: FloatingDialogStatus.info,
                      ),
                    );
                  },
                  child: const Text("Dialog Handler demo"),
                ),

                //Demonstrates how results can be retrieved from dismissed dialogs
                TextButton(
                  onPressed: () {
                    DialogManager.of(context)
                        .showDialog(routeName: "/form")
                        .then(
                          (value) => setState(() {
                            _counter = value as int;
                          }),
                        );
                  },
                  child: const Text("Form Dialog"),
                ),
              ],
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
