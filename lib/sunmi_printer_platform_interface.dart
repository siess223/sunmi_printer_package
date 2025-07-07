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

  /// 绑定打印机服务
  Future<bool?> bindService() {
    throw UnimplementedError('bindService() has not been implemented.');
  }

  /// 解绑打印机服务
  Future<bool?> unBindService() {
    throw UnimplementedError('unBindService() has not been implemented.');
  }

  /// 打印文本
  Future<bool?> printText(String text, int? size, String? align, bool? bold, bool? underline) {
    throw UnimplementedError('printText() has not been implemented.');
  }

  /// 打印图片
  Future<bool?> printImage(List<int> imageData, int? width, int? height, String? align) {
    throw UnimplementedError('printImage() has not been implemented.');
  }

  /// 打印QR码
  Future<bool?> printQRCode(String data, int? size, String? align) {
    throw UnimplementedError('printQRCode() has not been implemented.');
  }

  /// 打印条形码
  Future<bool?> printBarcode(String data, String? type, int? width, int? height, String? align) {
    throw UnimplementedError('printBarcode() has not been implemented.');
  }

  /// 打印表格
  Future<bool?> printTable(List<Map<String, dynamic>> tableData, List<int>? columnWidths) {
    throw UnimplementedError('printTable() has not been implemented.');
  }

  /// 打印小票
  Future<bool?> printReceipt(Map<String, dynamic> receiptData) {
    throw UnimplementedError('printReceipt() has not been implemented.');
  }

  /// 切纸
  Future<bool?> cutPaper() {
    throw UnimplementedError('cutPaper() has not been implemented.');
  }

  /// 开钱箱
  Future<bool?> openDrawer() {
    throw UnimplementedError('openDrawer() has not been implemented.');
  }

  /// 进纸
  Future<bool?> feedPaper(int? lines) {
    throw UnimplementedError('feedPaper() has not been implemented.');
  }

  /// 获取打印机状态
  Future<Map<String, dynamic>?> getPrinterStatus() {
    throw UnimplementedError('getPrinterStatus() has not been implemented.');
  }

  /// 获取打印机信息
  Future<Map<String, dynamic>?> getPrinterInfo() {
    throw UnimplementedError('getPrinterInfo() has not been implemented.');
  }

  /// 检查打印机是否连接
  Future<bool?> isPrinterConnected() {
    throw UnimplementedError('isPrinterConnected() has not been implemented.');
  }

  /// 进入打印缓冲区
  Future<bool?> enterPrinterBuffer(bool? clear) {
    throw UnimplementedError('enterPrinterBuffer() has not been implemented.');
  }

  /// 退出打印缓冲区
  Future<bool?> exitPrinterBuffer(bool? commit) {
    throw UnimplementedError('exitPrinterBuffer() has not been implemented.');
  }

  /// 清空打印缓冲区
  Future<bool?> clearPrinterBuffer() {
    throw UnimplementedError('clearPrinterBuffer() has not been implemented.');
  }

  // ===== LCD 客显功能 =====

  /// LCD显示文本
  Future<bool?> lcdDisplayText(String text, int? size, bool? bold) {
    throw UnimplementedError('lcdDisplayText() has not been implemented.');
  }

  /// LCD显示多行文本
  Future<bool?> lcdDisplayTexts(List<String> texts, List<int>? sizes) {
    throw UnimplementedError('lcdDisplayTexts() has not been implemented.');
  }

  /// LCD显示图片
  Future<bool?> lcdDisplayBitmap(List<int> imageData) {
    throw UnimplementedError('lcdDisplayBitmap() has not been implemented.');
  }

  /// LCD显示数字/价格
  Future<bool?> lcdDisplayDigital(String digital) {
    throw UnimplementedError('lcdDisplayDigital() has not been implemented.');
  }

  /// LCD清屏
  Future<bool?> lcdClear() {
    throw UnimplementedError('lcdClear() has not been implemented.');
  }

  /// LCD初始化
  Future<bool?> lcdInit() {
    throw UnimplementedError('lcdInit() has not been implemented.');
  }
}
