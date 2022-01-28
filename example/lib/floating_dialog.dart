import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:flutter/material.dart';

enum FloatingDialogStatus { success, error, info }

final _navigatorKey = GlobalKey<NavigatorState>();

class FloatingDialogDemo extends StatelessWidget {
  const FloatingDialogDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogManager(
      navigatorKey: _navigatorKey,
      onGenerateDialogs: (settings) {
        switch (settings.name) {
          case "/floating":
            if (settings.arguments != null) {
              final argument = settings.arguments as FloatingDialogArg;
              return FloatingDialog(
                message: argument.message,
                status: argument.status,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Dialog Demo Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingDialog extends StatelessWidget {
  final String message;
  final FloatingDialogStatus status;

  const FloatingDialog({
    Key? key,
    required this.message,
    this.status = FloatingDialogStatus.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogBuilder(
      alignment: DialogAlignment.start,
      builder: (dialogKey) => Container(
        key: dialogKey,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: status == FloatingDialogStatus.success
              ? Colors.green
              : status == FloatingDialogStatus.error
                  ? Colors.redAccent
                  : Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => DialogManager.of(context).dismissDialog(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class FloatingDialogArg {
  final FloatingDialogStatus status;
  final String message;

  FloatingDialogArg({
    required this.message,
    this.status = FloatingDialogStatus.info,
  });
}
