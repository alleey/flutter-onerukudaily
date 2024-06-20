import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel _channel = MethodChannel('android.native');

  static Future<bool> isAndroidTV() async {
    try {
      return await _channel.invokeMethod('isAndroidTV');
    } on PlatformException catch (e) {
      log("Failed to check feature: '${e.message}'.");
      return false;
    }
  }
}

bool _highlightModeSet = kIsWeb || !Platform.isAndroid;
bool kIsAndroidTV = false;

Future<void> setTraditionalFocusHighlightStrategy() async {
  if (!_highlightModeSet) {
    kIsAndroidTV = await NativeChannel.isAndroidTV();
    if (kIsAndroidTV) {
      FocusManager.instance.highlightStrategy = FocusHighlightStrategy.alwaysTraditional;
    }
  }
  _highlightModeSet = true;
}
