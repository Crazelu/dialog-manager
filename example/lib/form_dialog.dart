import 'package:flutter/material.dart';
import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';

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
                    DialogManager.of(context).dismissDialog(counter);
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
