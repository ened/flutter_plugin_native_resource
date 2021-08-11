import 'package:flutter_test/flutter_test.dart';
import 'package:native_resource/native_resource.dart';

void main() {
  group("singleton pattern", () {
    test("It always return the same instance", () {
      final object1 = NativeResource();
      final object2 = NativeResource();

      expect(object1 == object2, true);
    });
  });
}
