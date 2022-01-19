class DialogSettings {
  const DialogSettings({
    this.name = "/",
    this.arguments,
  });

  ///Name of dialog
  ///
  ///This is typically looked at to determine what dialog implementation to return.
  ///You can write different UI implementations for different dialogs and reference
  ///them using [name] just like you'd do with [Navigator]'s named routes.
  ///
  ///Defaults to "/".
  final String name;

  ///Optional arguments just like you have with the Navigator API.
  ///
  ///Fun story, I really needed this as I started building complex dialogs
  ///with more than one purpose. E.g using one dialog with form for creating
  ///and updating some record. For updating, you might want to prefill the fields.
  ///
  ///Those values can be pulled from [arguments].
  final Object? arguments;
}
