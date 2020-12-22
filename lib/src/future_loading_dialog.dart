// Copyright (c) 2020 Famedly
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a loading dialog which reacts to the given [future]. The dialog
/// will be dismissed and the value will be returned when the future completes.
/// If an error occured, then [onError] will be called and this method returns
/// null. Set [title] and [backLabel] to controll the look and feel or set
/// [LoadingDialog.defaultTitle], [LoadingDialog.defaultBackLabel] and
/// [LoadingDialog.defaultOnError] to have global preferences.
Future<T> showFutureLoadingDialog<T>({
  @required BuildContext context,
  @required Future<T> future,
  String title,
  String backLabel,
  String Function(dynamic exception) onError,
  bool barrierDismissible = false,
}) {
  final dialog = LoadingDialog<T>(
    future: future,
    title: title,
    backLabel: backLabel,
    onError: onError,
  );
  if (dialog.isCupertinoStyle) {
    return showCupertinoDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => dialog,
  );
}

class LoadingDialog<T> extends StatefulWidget {
  final String title;
  final String backLabel;
  final Future<T> future;
  final String Function(dynamic exception) onError;

  static String defaultTitle = 'Loading... Please Wait!';
  static String defaultBackLabel = 'Back';
  static String Function(dynamic exception) defaultOnError =
      (exception) => exception.toString();

  bool get isCupertinoStyle => !kIsWeb && Platform.isIOS;

  const LoadingDialog({
    Key key,
    @required this.future,
    this.title,
    this.onError,
    this.backLabel,
  }) : super(key: key);
  @override
  _LoadingDialogState<T> createState() => _LoadingDialogState<T>();
}

class _LoadingDialogState<T> extends State<LoadingDialog> {
  dynamic exception;

  @override
  void initState() {
    super.initState();
    widget.future.catchError((e) => setState(() => exception = e)).then(
        (result) =>
            exception == null ? Navigator.of(context).pop<T>(result) : null);
  }

  @override
  Widget build(BuildContext context) {
    final titleLabel = exception != null
        ? widget.onError?.call(exception) ??
            LoadingDialog.defaultOnError(exception)
        : widget.title ?? LoadingDialog.defaultTitle;

    if (widget.isCupertinoStyle) {
      return CupertinoAlertDialog(
        title: Text(titleLabel),
        content: exception != null ? null : CupertinoActivityIndicator(),
        actions: [
          if (exception != null)
            CupertinoDialogAction(
              child: Text(widget.backLabel ?? LoadingDialog.defaultBackLabel),
              onPressed: Navigator.of(context).pop,
            )
        ],
      );
    }
    return AlertDialog(
      title: exception == null ? Text(titleLabel) : null,
      content: exception != null
          ? ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
              ),
              title: Text(titleLabel),
            )
          : LinearProgressIndicator(),
      actions: [
        if (exception != null)
          FlatButton(
            child: Text(widget.backLabel ?? LoadingDialog.defaultBackLabel),
            onPressed: Navigator.of(context).pop,
          ),
      ],
    );
  }
}
