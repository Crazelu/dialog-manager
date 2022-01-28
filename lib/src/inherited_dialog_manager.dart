import 'dart:async';
import 'package:flutter_dialog_manager/src/dialog_settings.dart';
import 'package:flutter_dialog_manager/src/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef DialogRouteGenerator = Widget? Function(DialogSettings);

class InheritedDialogManager extends InheritedWidget {
  const InheritedDialogManager({
    Key? key,
    required this.dialogHandler,
    required Widget child,
  }) : super(key: key, child: child);

  final DialogHandler dialogHandler;

  @override
  bool updateShouldNotify(covariant InheritedDialogManager oldWidget) => false;
}

class DialogHandler {
  DialogHandler({
    required this.navigatorKey,
    this.dialogRoutes = const {},
    this.errorDialog,
    this.onGenerateDialogs,
  });

  ///Navigator key used to push routes onto the navigation stack.
  final GlobalKey<NavigatorState> navigatorKey;

  ///Top level dialog routing table.
  ///
  ///When a dialog is pushed with [showDialog],
  ///the corresponding dialog name is looked up and it's associated widget returned.
  ///
  ///If no dialog implementation is found, [errorDialog] or the default
  ///error dialog (if [errorDialog] is null) is returned.
  final Map<String, Widget Function(BuildContext)> dialogRoutes;

  ///Dialog generator callback that allows binding data with dialogs.
  ///
  ///When a dialog is pushed with [showDialog],
  ///the corresponding dialog name is looked up and it's associated widget constructed.
  ///Data passed from [showDialog] can be extracted from [DialogSettings] here and
  ///passed down to the widget.
  final DialogRouteGenerator? onGenerateDialogs;

  ///Error dialog shown when a dialog route that doesn't exist in [dialogs]
  ///is pushed.
  final Widget? errorDialog;

  ///Timer object used to schedule an auto dismissal of dialogs
  Timer? _dismissalTimer;

  /// Displays a dialog on screen.
  ///
  /// [routeName] is used to look up a dialog's implementation.
  ///
  /// [autoDismiss] when true, implies that the dialog will be shown on screen for [duration]
  /// before being automatically dismissed.
  ///
  /// [barrierColor] -> Barrier colors of dialog. Defaults to [Colors.black38].
  ///
  /// [opaque] when true implies that [barrierColor] will take effect.
  /// Otherwise, barrier will be transparent.
  /// This might be helpful when there are multiple dialogs stacked on top of each other.
  ///
  /// Optional [arguments] can be passed down to dialogs generated with [onGenerateDialogs].
  Future<Object?> showDialog({
    String routeName = "/",
    Duration duration = const Duration(seconds: 3),
    bool autoDismiss = false,
    Object? arguments,
    bool opaque = true,
    Color? barrierColor,
  }) {
    final result = navigatorKey.currentState?.push(
      DialogRoute(
        context: navigatorKey.currentContext!,
        builder: _getDialog(
          DialogSettings(
            name: routeName,
            arguments: arguments,
          ),
        ),
        barrierDismissible: true,
        barrierColor:
            !opaque ? Colors.transparent : barrierColor ?? Colors.black38,
      ),
    );

    //dismiss dialog after period of time specified by `duration`
    if (autoDismiss) {
      _dismissalTimer = Timer.periodic(duration, (_) {
        dismissDialog();
      });
    }

    return result!;
  }

  ///Dismisses current dialog
  void dismissDialog([Object? result]) {
    //if a timer is active, cancel to prevent another navigation
    _dismissalTimer?.cancel();
    navigatorKey.currentState?.pop(result);
  }

  ///Returns `true` if [tapDetails] contains any offset
  ///in screen area where a dialog with [dialogKey] is not rendered.
  ///
  ///Otherwise, returns `false`.
  bool canDismissDialog({
    required TapDownDetails tapDetails,
    required GlobalKey dialogKey,
    double dialogMargin = 0,
  }) {
    try {
      final size = navigatorKey.currentContext!.size!;
      final height = size.height;
      final width = size.width;

      final screenOffset = tapDetails.localPosition;
      final dialogHeight = dialogKey.currentContext!.size!.height;
      final dialogWidth = dialogKey.currentContext!.size!.width;

      return screenOffset.dy < (height - dialogHeight) / 2 ||
          screenOffset.dy > (height + dialogHeight) / 2 ||
          screenOffset.dx < ((width / 2) - (dialogWidth / 2) - dialogMargin) ||
          screenOffset.dx > ((width / 2) + (dialogWidth / 2) + dialogMargin);
    } catch (e) {
      return false;
    }
  }

  Widget Function(BuildContext ctx) _getDialog(DialogSettings settings) {
    try {
      if (onGenerateDialogs != null) {
        return (ctx) =>
            onGenerateDialogs!(settings) ??
            ErrorDialog(
              canDismissDialog: canDismissDialog,
              dialogname: settings.name,
              dismissDialog: dismissDialog,
              errorDialog: errorDialog,
            );
      }

      return dialogRoutes[settings.name]!;
    } catch (e) {
      return (ctx) => ErrorDialog(
            canDismissDialog: canDismissDialog,
            dialogname: settings.name,
            dismissDialog: dismissDialog,
            errorDialog: errorDialog,
          );
    }
  }
}
