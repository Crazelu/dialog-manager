import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:flutter/material.dart';

enum FloatingDialogStatus { success, error, info }

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
