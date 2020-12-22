# Future Loading Dialog

Easy to use adaptive loading dialog to visualize a Dart Future.

Displays a loading dialog which reacts to the given [future]. The dialog
will be dismissed and the value will be returned when the future completes.
If an error occured, then [onError] will be called and this method returns
null. Set [title] and [backLabel] to controll the look and feel or set
[LoadingDialog.defaultTitle], [LoadingDialog.defaultBackLabel] and
[LoadingDialog.defaultOnError] to have global preferences.

### Example:

Will display a loading dialog for one second.

```dart
MaterialApp(
  title: 'Test',
  home: Scaffold(
    body: Builder(
      builder: (context) => RaisedButton(
        child: Text('Test'),
        onPressed: () => showFutureLoadingDialog(
          context: context,
          future: Future.delayed(Duration(seconds: 1)),
        ),
      ),
    ),
  ),
);
```