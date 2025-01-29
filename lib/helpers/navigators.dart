import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushTo(Widget widget, BuildContext context) {
  Navigator.of(context).push(Platform.isIOS
      ? CupertinoPageRoute(
          builder: (context) => widget,
        )
      : MaterialPageRoute(
          builder: (context) => widget,
        ));
}

void pushToUntil(Widget widget, BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      Platform.isIOS
          ? CupertinoPageRoute(
              builder: (context) => widget,
            )
          : MaterialPageRoute(
              builder: (context) => widget,
            ),
      (route) => false);
}

void pushToReplace(Widget widget, BuildContext context) {
  Navigator.of(context).pushReplacement(Platform.isIOS
      ? CupertinoPageRoute(
          builder: (context) => widget,
        )
      : MaterialPageRoute(
          builder: (context) => widget,
        ));
}

void pop(BuildContext context) {
  if (Navigator.canPop(context)) {
  Navigator.of(context).pop();
  }
}
