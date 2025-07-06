
import 'sunmi_printer_platform_interface.dart';

/// Sunmi打印机插件主类
class SunmiPrinter {
  /// 获取平台版本
  Future<String?> getPlatformVersion() {
    return SunmiPrinterPlatform.instance.getPlatformVersion();
  }

  /// 检查打印机状态
  Future<int?> getPrinterStatus() {
    return SunmiPrinterPlatform.instance.getPrinterStatus();
  }

  /// 初始化打印机
  Future<bool?> initPrinter() {
    return SunmiPrinterPlatform.instance.initPrinter();
  }

  /// 打印文本
  Future<void> printText(String text, {int? textSize, bool? bold, bool? underline, int? alignment}) {
    return SunmiPrinterPlatform.instance.printText(text, textSize, bold, underline, alignment);
  }

  /// 打印换行
  Future<void> printNewLine({int lines = 1}) {
    return SunmiPrinterPlatform.instance.printNewLine(lines);
  }

  /// 打印QR码
  Future<void> printQRCode(String data, {int? size, int? errorLevel}) {
    return SunmiPrinterPlatform.instance.printQRCode(data, size, errorLevel);
  }

  /// 打印条形码
  Future<void> printBarcode(String data, {int? barcodeType, int? height, int? width, int? textPosition}) {
    return SunmiPrinterPlatform.instance.printBarcode(data, barcodeType, height, width, textPosition);
  }

  /// 打印图片（从assets）
  Future<void> printBitmap(String imagePath, {int? width, int? height}) {
    return SunmiPrinterPlatform.instance.printBitmap(imagePath, width, height);
  }

  /// 设置文本对齐方式
  Future<void> setAlignment(int alignment) {
    return SunmiPrinterPlatform.instance.setAlignment(alignment);
  }

  /// 设置文本大小
  Future<void> setTextSize(int size) {
    return SunmiPrinterPlatform.instance.setTextSize(size);
  }

  /// 设置文本样式
  Future<void> setTextStyle({bool? bold, bool? underline}) {
    return SunmiPrinterPlatform.instance.setTextStyle(bold, underline);
  }

  /// 切纸
  Future<void> cutPaper() {
    return SunmiPrinterPlatform.instance.cutPaper();
  }

  /// 开钱箱
  Future<void> openDrawer() {
    return SunmiPrinterPlatform.instance.openDrawer();
  }

  /// 获取打印机序列号
  Future<String?> getPrinterSerialNumber() {
    return SunmiPrinterPlatform.instance.getPrinterSerialNumber();
  }

  /// 获取打印机版本
  Future<String?> getPrinterVersion() {
    return SunmiPrinterPlatform.instance.getPrinterVersion();
  }

  /// 打印表格
  Future<void> printTable(List<String> texts, List<int> widths, List<int> alignments) {
    return SunmiPrinterPlatform.instance.printTable(texts, widths, alignments);
  }

  /// 打印分割线
  Future<void> printDivider({String? char, int? length}) {
    return SunmiPrinterPlatform.instance.printDivider(char, length);
  }

  /// 进纸
  Future<void> feedPaper(int lines) {
    return SunmiPrinterPlatform.instance.feedPaper(lines);
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
  static const int LEFT = 0;
  static const int CENTER = 1;
  static const int RIGHT = 2;
}

/// 文本大小常量
class PrinterTextSize {
  static const int SMALL = 0;
  static const int NORMAL = 1;
  static const int LARGE = 2;
  static const int EXTRA_LARGE = 3;
}

/// 条形码类型常量
class BarcodeType {
  static const int UPC_A = 0;
  static const int UPC_E = 1;
  static const int EAN13 = 2;
  static const int EAN8 = 3;
  static const int CODE39 = 4;
  static const int ITF = 5;
  static const int CODABAR = 6;
  static const int CODE93 = 7;
  static const int CODE128 = 8;
}
