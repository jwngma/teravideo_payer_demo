import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class Tools {
  static showToasts(String message, {bool? success, int duration = 2}) {
    BotToast.showText(
      contentColor: success == null
          ? Colors.black54
          : success
              ? Colors.green
              : Colors.red,
      text: message,
      duration: Duration(seconds: duration),
    );
  }

  static showDebugPrint(String message) {
    debugPrint("Console : $message");
  }

  static showLoading() {
    BotToast.showLoading();
  }

  static hideLoading() {
    BotToast.closeAllLoading();
  }
}
