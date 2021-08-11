import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Retrieve values stored in the native resource system, like .plist files on iOS
/// and .xml files in the `res/values` folder on Android.
class NativeResource {
  static NativeResource? _instance;

  /// Singleton constructor.
  factory NativeResource() {
    return _instance ??= NativeResource.private(
      const MethodChannel('asia.ivity.flutter/native_resource/methods'),
    );
  }

  @visibleForTesting
  NativeResource.private(this._channel);

  final MethodChannel _channel;

  /// Reads a *string* stored in the platform resource system.
  ///
  /// On iOS, the `iosPlistKey` field is used. When specified, `iosPlistFile` specifies the name of a
  /// plist file to read the value from.
  ///
  /// On Android `androidResourceName` is resolved using the resource system.
  Future<String> read({
    required String androidResourceName,
    required String iosPlistKey,
    String? iosPlistFile,
  }) async {
    return (await _channel.invokeMethod<String>('read', {
      'android-resource-name': androidResourceName,
      'ios-plist-key': iosPlistKey,
      'ios-plist-file': iosPlistFile,
    }))!;
  }
}
