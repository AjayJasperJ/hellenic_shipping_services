import 'package:flutter/material.dart';

bool _isDialogOpen = false;

void openDialog(BuildContext context) {
  if (_isDialogOpen) return;
  _isDialogOpen = true;

  showDialog(
    barrierColor: Colors.black.withValues(alpha: .2),
    context: context,
    barrierDismissible: false,
    useRootNavigator: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        child: RepaintBoundary(
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void closeDialog(BuildContext context) {
  if (_isDialogOpen) {
    Navigator.of(context, rootNavigator: true).pop();
    _isDialogOpen = false;
  }
}
