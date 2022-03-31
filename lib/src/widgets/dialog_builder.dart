import 'package:flutter_dialog_manager/flutter_dialog_manager.dart';
import 'package:flutter/material.dart';

enum DialogAlignment { start, center, end }

///Builds a dialog with dismissal handled as with default Flutter dialogs.
///
///[builder] -> Builder method that returns the dialog.
///
///[GlobalKey] should be set as the key of the widget to enable dismissal
///of dialog when any area in the barrier is tapped.
///
///[alignment] -> Position of dialog along the vertical axis.
///
///Defaults to [DialogAlignment.center]
///
///[debugLabel] -> Debug label for [GlobalKey] accessed from [builder]
///
///[dismissible] -> Whether dialog can be dismissed by tapping any area in the barrier.
///
///[crossAxisAlignment] -> Position of dialog along the horizontal axis.
class DialogBuilder extends StatefulWidget {
  const DialogBuilder({
    Key? key,
    required this.builder,
    this.alignment = DialogAlignment.center,
    this.debugLabel,
    this.dismissible = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  ///Builder method that returns the dialog.
  ///
  ///[GlobalKey] should be set as the key of the widget to enable dismissal
  ///of dialog when any area in the barrier is tapped.
  final Widget Function(GlobalKey) builder;

  ///Debug label for [GlobalKey] accessed from [builder]
  final String? debugLabel;

  ///Position of dialog along the vertical axis.
  ///
  ///Defaults to [DialogAlignment.center]
  final DialogAlignment alignment;

  ///Whether dialog can be dismissed by tapping any area in the barrier.
  final bool dismissible;

  ///Position of dialog along the horizontal axis.
  ///
  ///Defaults to [CrossAxisAlignment.center]
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<DialogBuilder> createState() => _DialogBuilderState();
}

class _DialogBuilderState extends State<DialogBuilder> {
  late GlobalKey dialogKey;

  @override
  void initState() {
    super.initState();
    dialogKey = GlobalKey(debugLabel: widget.debugLabel);
  }

  MainAxisAlignment get alignment {
    switch (widget.alignment) {
      case DialogAlignment.start:
        return MainAxisAlignment.start;
      case DialogAlignment.end:
        return MainAxisAlignment.end;

      default:
        return MainAxisAlignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        //if user taps on any area outside the space the dialog
        //takes on the screen, you can dismiss the dialog
        //to simulate the native dialog dismissal with Flutter dialogs
        if (widget.dismissible &&
            DialogManager.of(context).canDismissDialog(
              tapDetails: details,
              dialogKey: dialogKey,
            )) {
          DialogManager.of(context).dismissDialog();
        }
      },
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: widget.crossAxisAlignment,
            mainAxisAlignment: alignment,
            children: [
              widget.builder(dialogKey),
            ],
          ),
        ),
      ),
    );
  }
}
