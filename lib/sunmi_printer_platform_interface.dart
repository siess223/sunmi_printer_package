import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sunmi_printer_method_channel.dart';

abstract class SunmiPrinterPlatform extends PlatformInterface {
  /// Constructs a SunmiPrinterPlatform.
  SunmiPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SunmiPrinterPlatform _instance = MethodChannelSunmiPrinter();

  /// The default instance of [SunmiPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelSunmiPrinter].
  static SunmiPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SunmiPrinterPlatform] when
  /// they register themselves.
  static set instance(SunmiPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getPrinterStatus() {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  Future<bool?> initPrinter() {
    throw UnimplementedError('initPrinter() has not been implemented.');
  }

  Future<void> printText(String text, int? textSize, bool? bold, bool? underline, int? alignment) {
    throw UnimplementedError('printText() has not been implemented.');
  }

  Future<void> printNewLine(int lines) {
    throw UnimplementedError('printNewLine() has not been implemented.');
  }

  Future<void> printQRCode(String data, int? size, int? errorLevel) {
    throw UnimplementedError('printQRCode() has not been implemented.');
  }

  Future<void> printBarcode(String data, int? barcodeType, int? height, int? width, int? textPosition) {
    throw UnimplementedError('printBarcode() has not been implemented.');
  }

  Future<void> printBitmap(String imagePath, int? width, int? height) {
    throw UnimplementedError('printBitmap() has not been implemented.');
  }

  Future<void> setAlignment(int alignment) {
    throw UnimplementedError('setAlignment() has not been implemented.');
  }

  Future<void> setTextSize(int size) {
    throw UnimplementedError('setTextSize() has not been implemented.');
  }

  Future<void> setTextStyle(bool? bold, bool? underline) {
    throw UnimplementedError('setTextStyle() has not been implemented.');
  }

  Future<void> cutPaper() {
    throw UnimplementedError('cutPaper() has not been implemented.');
  }

  Future<void> openDrawer() {
    throw UnimplementedError('openDrawer() has not been implemented.');
  }

  Future<String?> getPrinterSerialNumber() {
    throw UnimplementedError('getPrinterSerialNumber() has not been implemented.');
  }

  Future<String?> getPrinterVersion() {
    throw UnimplementedError('getPrinterVersion() has not been implemented.');
  }

  Future<void> printTable(List<String> texts, List<int> widths, List<int> alignments) {
    throw UnimplementedError('printTable() has not been implemented.');
  }

  Future<void> printDivider(String? char, int? length) {
    throw UnimplementedError('printDivider() has not been implemented.');
  }

  Future<void> feedPaper(int lines) {
    throw UnimplementedError('feedPaper() has not been implemented.');
  }
}
