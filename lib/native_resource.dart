import 'dart:async';
import 'dart:typed_data';

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
  ///
  /// If the property can not be resolved, a exception is thrown.
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

  /// Reads *raw* stored in the platform resource system.
  ///
  /// On Android `resourceName` is resolved using the resource system and the `raw` resource type.
  ///
  /// On iOS, a file named `resourceName` is being resolved from the main bundle and read fully.
  ///
  /// If the property can not be resolved, a exception is thrown.
  Future<Uint8List> readRaw({
    required String resourceName,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return (await _channel.invokeMethod<Uint8List>('readRaw', resourceName))!;
    }

    return (await _channel.invokeMethod<Uint8List>('read', {
      'android-resource-name': resourceName,
      'resource-type': 'raw',
    }))!;
  }
}
