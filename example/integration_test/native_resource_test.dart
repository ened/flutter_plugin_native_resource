import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:native_resource/native_resource.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("default resource file", (WidgetTester tester) async {
    expect(
      await NativeResource().read(
        androidResourceName: 'app_name',
        iosPlistKey: 'CFBundleName',
      ),
      'native_resource_example',
    );
  });

  testWidgets("specific resource file file", (WidgetTester tester) async {
    expect(
      await NativeResource().read(
        androidResourceName: 'sample_key',
        iosPlistKey: 'SampleKey',
        iosPlistFile: 'Test',
      ),
      'Sample Value',
    );
  });
}
