import 'package:flutter/material.dart';

typedef DismissDialogCallback = bool Function({
  required TapDownDetails tapDetails,
  required GlobalKey<State<StatefulWidget>> dialogKey,
  double dialogMargin,
});

///Default error dialog for [DialogManager].
class ErrorDialog extends StatefulWidget {
  final String dialogname;
  final DismissDialogCallback canDismissDialog;
  final VoidCallback dismissDialog;
  final Widget? errorDialog;

  const ErrorDialog({
    Key? key,
    required this.dialogname,
    required this.canDismissDialog,
    required this.dismissDialog,
    this.errorDialog,
  }) : super(key: key);

  @override
  State<ErrorDialog> createState() => ErrorDialogState();
}

class ErrorDialogState extends State<ErrorDialog> {
  late GlobalKey errorDialogContainerKey;

  @override
  void initState() {
    super.initState();
    errorDialogContainerKey =
        GlobalKey(debugLabel: "errorDialogFor${widget.dialogname}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        //if user taps on any area outside the space the dialog
        //takes on the screen, you can dismiss the dialog
        //to simulate the native dialog dismissal with Flutter dialogs
        if (widget.canDismissDialog(
          tapDetails: details,
          dialogKey: errorDialogContainerKey,
        )) {
          widget.dismissDialog();
        }
      },
      child: widget.errorDialog ??
          Material(
            color: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    key: errorDialogContainerKey,
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => widget.dismissDialog(),
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Spacer(),
                        Center(
                          child: Text(
                            "No dialog defined for ${widget.dialogname}",
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextButton(
                          onPressed: () => widget.dismissDialog(),
                          child: const Text("Ok"),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
