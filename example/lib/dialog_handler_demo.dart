import 'package:example/dialog_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

final _navigatorKey = GlobalKey<NavigatorState>();
final _dialogHandler = DialogHandlerImpl();

class FormDialogDemoWithHandler extends StatelessWidget {
  const FormDialogDemoWithHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogManager(
      dialogKey:
          _dialogHandler.dialogKey, //pass a dialog key from your abstraction
      navigatorKey: _navigatorKey,
      dialogRoutes: {"/form": (_) => const FormDialog()},
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
        title: const Text("Form Dialog Demo Page"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
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
            //Demonstrates how results can be retrieved from dismissed dialogs
            TextButton(
              onPressed: () {
                //show dialogs with methods exposed by your abstraction
                _dialogHandler.showDialog(routeName: "/form").then(
                      (value) => setState(() {
                        _counter = value as int;
                      }),
                    );
              },
              child: const Text("Form Dialog"),
            ),
          ],
        ),
      ),
    );
  }
}

///Shows how results can be returned from dialogs to their callers
class FormDialog extends StatefulWidget {
  const FormDialog({Key? key}) : super(key: key);

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormState>();
  late int counter;
  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      builder: (dialogKey) => Form(
        key: _formKey,
        child: Container(
          key: dialogKey,
          height: 250,
          width: 300,
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter a value to reset counter"),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  counter = int.tryParse(value) ?? 0;
                },
                validator: (value) {
                  if (int.tryParse(value!) == null) return "Enter a number";
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "0",
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //return the counter in the dismissDialog call
                    _dialogHandler.dismissDialog(counter);
                  }
                },
                child: const Text("Reset counter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
