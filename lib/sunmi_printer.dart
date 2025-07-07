
import 'sunmi_printer_platform_interface.dart';

/// Sunmi打印机插件主类
class SunmiPrinter {
  /// 绑定打印机服务
  Future<bool?> bindService() {
    return SunmiPrinterPlatform.instance.bindService();
  }

  /// 解绑打印机服务
  Future<bool?> unBindService() {
    return SunmiPrinterPlatform.instance.unBindService();
  }

  /// 打印文本
  Future<bool?> printText(String text, {int? size, String? align, bool? bold, bool? underline}) {
    return SunmiPrinterPlatform.instance.printText(text, size, align, bold, underline);
  }

  /// 打印图片
  Future<bool?> printImage(List<int> imageData, {int? width, int? height, String? align}) {
    return SunmiPrinterPlatform.instance.printImage(imageData, width, height, align);
  }

  /// 打印QR码
  Future<bool?> printQRCode(String data, {int? size, String? align}) {
    return SunmiPrinterPlatform.instance.printQRCode(data, size, align);
  }

  /// 打印条形码
  Future<bool?> printBarcode(String data, {String? type, int? width, int? height, String? align}) {
    return SunmiPrinterPlatform.instance.printBarcode(data, type, width, height, align);
  }

  /// 打印表格
  Future<bool?> printTable(List<Map<String, dynamic>> tableData, {List<int>? columnWidths}) {
    return SunmiPrinterPlatform.instance.printTable(tableData, columnWidths);
  }

  /// 打印小票
  Future<bool?> printReceipt(Map<String, dynamic> receiptData) {
    return SunmiPrinterPlatform.instance.printReceipt(receiptData);
  }

  /// 切纸
  Future<bool?> cutPaper() {
    return SunmiPrinterPlatform.instance.cutPaper();
  }

  /// 开钱箱
  Future<bool?> openDrawer() {
    return SunmiPrinterPlatform.instance.openDrawer();
  }

  /// 进纸
  Future<bool?> feedPaper({int? lines}) {
    return SunmiPrinterPlatform.instance.feedPaper(lines);
  }

  /// 获取打印机状态
  Future<Map<String, dynamic>?> getPrinterStatus() {
    return SunmiPrinterPlatform.instance.getPrinterStatus();
  }

  /// 获取打印机信息
  Future<Map<String, dynamic>?> getPrinterInfo() {
    return SunmiPrinterPlatform.instance.getPrinterInfo();
  }

  /// 检查打印机是否连接
  Future<bool?> isPrinterConnected() {
    return SunmiPrinterPlatform.instance.isPrinterConnected();
  }

  /// 进入打印缓冲区
  Future<bool?> enterPrinterBuffer({bool? clear}) {
    return SunmiPrinterPlatform.instance.enterPrinterBuffer(clear);
  }

  /// 退出打印缓冲区
  Future<bool?> exitPrinterBuffer({bool? commit}) {
    return SunmiPrinterPlatform.instance.exitPrinterBuffer(commit);
  }

  /// 清空打印缓冲区
  Future<bool?> clearPrinterBuffer() {
    return SunmiPrinterPlatform.instance.clearPrinterBuffer();
  }

  // ===== LCD 客显功能 =====
  
  /// LCD显示文本
  Future<bool?> lcdDisplayText(String text, {int? size, bool? bold}) {
    return SunmiPrinterPlatform.instance.lcdDisplayText(text, size, bold);
  }

  /// LCD显示多行文本
  Future<bool?> lcdDisplayTexts(List<String> texts, {List<int>? sizes}) {
    return SunmiPrinterPlatform.instance.lcdDisplayTexts(texts, sizes);
  }

  /// LCD显示图片
  Future<bool?> lcdDisplayBitmap(List<int> imageData) {
    return SunmiPrinterPlatform.instance.lcdDisplayBitmap(imageData);
  }

  /// LCD显示数字/价格
  Future<bool?> lcdDisplayDigital(String digital) {
    return SunmiPrinterPlatform.instance.lcdDisplayDigital(digital);
  }

  /// LCD清屏
  Future<bool?> lcdClear() {
    return SunmiPrinterPlatform.instance.lcdClear();
  }

  /// LCD初始化
  Future<bool?> lcdInit() {
    return SunmiPrinterPlatform.instance.lcdInit();
  }
}

/// 打印机状态常量
class PrinterStatus {
  static const int NORMAL = 0;
  static const int PREPARING = 1;
  static const int ABNORMAL_COMMUNICATION = 2;
  static const int OUT_OF_PAPER = 3;
  static const int OVERHEATED = 4;
  static const int OPEN_COVER = 5;
  static const int PAPER_CUTTER_ABNORMAL = 6;
  static const int PAPER_CUTTER_RECOVERED = 7;
  static const int BLACK_LABEL_OUT = 8;
  static const int BLACK_LABEL_READY = 9;
}

/// 对齐方式常量
class PrinterAlignment {
  static const String LEFT = 'left';
  static const String CENTER = 'center';
  static const String RIGHT = 'right';
}

/// 条形码类型常量
class BarcodeType {
  static const String CODE39 = 'CODE39';
  static const String CODE93 = 'CODE93';
  static const String CODE128 = 'CODE128';
  static const String EAN8 = 'EAN8';
  static const String EAN13 = 'EAN13';
  static const String ITF = 'ITF';
  static const String CODABAR = 'CODABAR';
  static const String UPC_A = 'UPC_A';
  static const String UPC_E = 'UPC_E';
}
