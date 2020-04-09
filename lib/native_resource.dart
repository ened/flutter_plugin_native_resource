import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NativeResource {
  static NativeResource _instance;

  factory NativeResource() {
    return _instance ??= NativeResource.private(
      const MethodChannel('asia.ivity.flutter/native_resource/methods'),
    );
  }

  @visibleForTesting
  NativeResource.private(this._channel);

  final MethodChannel _channel;

  Future<String> read({
    @required String androidResourceName,
    @required String iosPlistKey,
    String iosPlistFile,
  }) async {
    return await _channel.invokeMethod<String>('read', {
      'android-resource-name': androidResourceName,
      'ios-plist-key': iosPlistKey,
      'ios-plist-file': iosPlistFile,
    });
  }
}
