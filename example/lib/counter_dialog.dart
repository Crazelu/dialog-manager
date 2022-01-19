import 'package:dialog_manager/dialog_manager.dart';
import 'package:flutter/material.dart';

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
              counter.toString(),
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
