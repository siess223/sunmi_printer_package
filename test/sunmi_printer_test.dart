import 'package:flutter_test/flutter_test.dart';
import 'package:sunmi_printer/sunmi_printer.dart';
import 'package:sunmi_printer/sunmi_printer_platform_interface.dart';
import 'package:sunmi_printer/sunmi_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSunmiPrinterPlatform
    with MockPlatformInterfaceMixin
    implements SunmiPrinterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SunmiPrinterPlatform initialPlatform = SunmiPrinterPlatform.instance;

  test('$MethodChannelSunmiPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSunmiPrinter>());
  });

  test('getPlatformVersion', () async {
    SunmiPrinter sunmiPrinterPlugin = SunmiPrinter();
    MockSunmiPrinterPlatform fakePlatform = MockSunmiPrinterPlatform();
    SunmiPrinterPlatform.instance = fakePlatform;

    expect(await sunmiPrinterPlugin.getPlatformVersion(), '42');
  });
}
