import 'package:dialog_manager/src/dialog_manager_api.dart';
import 'package:flutter/material.dart';
import 'package:dialog_manager/src/dialog_settings.dart';

class DialogManager extends StatelessWidget {
  const DialogManager({
    Key? key,
    required this.child,
    required this.navigatorKey,
    this.dialogs = const {},
    this.onGenerateDialogs,
    this.errorDialog,
    this.dialogKey,
  }) : super(key: key);

  ///Unique key which can be used to abstract [DialogManager] into
  ///a service without direct dependence on [BuildContext].
  final GlobalKey? dialogKey;

  ///Navigator key used to push routes onto the navigation stack.
  final GlobalKey<NavigatorState> navigatorKey;

  ///Top level dialog routing table.
  ///
  ///When a dialog is pushed with [showDialog],
  ///the corresponding dialog name is looked up and it's associated widget returned.
  ///
  ///If no dialog implementation is found, [errorDialog] or the default
  ///error dialog (if [errorDialog] is null) is returned.
  final Map<String, Widget Function(BuildContext)> dialogs;

  ///Dialog generator callback that allows binding data with dialogs.
  ///
  ///When a dialog is pushed with [showDialog],
  ///the corresponding dialog name is looked up and it's associated widget constructed.
  ///Data passed from [showDialog] can be extracted from [DialogSettings] here and
  ///passed down to the widget.
  final DialogRouteGenerator? onGenerateDialogs;

  final Widget child;

  ///Error dialog shown when a dialog route that doesn't exist in [dialogs]
  ///is pushed.
  final Widget? errorDialog;

  static DialogConfig of(BuildContext context) {
    final DialogConfig? config = context
        .dependOnInheritedWidgetOfExactType<DialogManagerApi>()
        ?.dialogConfig;

    assert(
      config != null,
      'DialogManager operation requested with a context that does not include a DialogManager.'
      'The context used to show dialogs from the DialogManager must be that of a '
      'widget that is a descendant of a DialogManager widget.',
    );

    return config!;
  }

  @override
  Widget build(BuildContext context) {
    return DialogManagerApi(
      key: dialogKey,
      dialogConfig: DialogConfig(
        navigatorKey: navigatorKey,
        onGenerateDialogs: onGenerateDialogs,
        dialogs: dialogs,
        errorDialog: errorDialog,
      ),
      child: child,
    );
  }
}
