import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sunmi_printer_platform_interface.dart';

/// An implementation of [SunmiPrinterPlatform] that uses method channels.
class MethodChannelSunmiPrinter extends SunmiPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sunmi_printer');

  @override
  Future<bool?> bindService() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('bindService');
      return result;
    } catch (e) {
      debugPrint('绑定服务失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> unBindService() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('unBindService');
      return result;
    } catch (e) {
      debugPrint('解绑服务失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printText(String text, int? size, String? align, bool? bold, bool? underline) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printText', {
        'text': text,
        'size': size,
        'align': align,
        'bold': bold,
        'underline': underline,
      });
      return result;
    } catch (e) {
      debugPrint('打印文本失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printImage(List<int> imageData, int? width, int? height, String? align) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printImage', {
        'image': Uint8List.fromList(imageData),
        'width': width,
        'height': height,
        'align': align,
      });
      return result;
    } catch (e) {
      debugPrint('打印图片失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printQRCode(String data, int? size, String? align) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printQRCode', {
        'data': data,
        'size': size,
        'align': align,
      });
      return result;
    } catch (e) {
      debugPrint('打印二维码失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printBarcode(String data, String? type, int? width, int? height, String? align) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printBarcode', {
        'data': data,
        'type': type,
        'width': width,
        'height': height,
        'align': align,
      });
      return result;
    } catch (e) {
      debugPrint('打印条形码失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printTable(List<Map<String, dynamic>> tableData, List<int>? columnWidths) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printTable', {
        'tableData': tableData,
        'columnWidths': columnWidths,
      });
      return result;
    } catch (e) {
      debugPrint('打印表格失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> printReceipt(Map<String, dynamic> receiptData) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('printReceipt', {
        'receiptData': receiptData,
      });
      return result;
    } catch (e) {
      debugPrint('打印小票失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> cutPaper() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('cutPaper');
      return result;
    } catch (e) {
      debugPrint('切纸失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> openDrawer() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('openDrawer');
      return result;
    } catch (e) {
      debugPrint('开钱箱失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> feedPaper(int? lines) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('feedPaper', {
        'lines': lines,
      });
      return result;
    } catch (e) {
      debugPrint('进纸失败: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getPrinterStatus() async {
    try {
      final result = await methodChannel.invokeMethod('getPrinterStatus');
      if (result != null && result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return result as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('获取打印机状态失败: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> getPrinterInfo() async {
    try {
      final result = await methodChannel.invokeMethod('getPrinterInfo');
      if (result != null && result is Map) {
        return Map<String, dynamic>.from(result);
      }
      return result as Map<String, dynamic>?;
    } catch (e) {
      debugPrint('获取打印机信息失败: $e');
      return null;
    }
  }

  @override
  Future<bool?> isPrinterConnected() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('isPrinterConnected');
      return result;
    } catch (e) {
      debugPrint('检查打印机连接失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> enterPrinterBuffer(bool? clear) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('enterPrinterBuffer', {
        'clear': clear,
      });
      return result;
    } catch (e) {
      debugPrint('进入打印缓冲区失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> exitPrinterBuffer(bool? commit) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('exitPrinterBuffer', {
        'commit': commit,
      });
      return result;
    } catch (e) {
      debugPrint('退出打印缓冲区失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> clearPrinterBuffer() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('clearPrinterBuffer');
      return result;
    } catch (e) {
      debugPrint('清空打印缓冲区失败: $e');
      return false;
    }
  }

  // ===== LCD 客显功能 =====

  @override
  Future<bool?> lcdDisplayText(String text, int? size, bool? bold) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdDisplayText', {
        'text': text,
        'size': size,
        'bold': bold,
      });
      return result;
    } catch (e) {
      debugPrint('LCD显示文本失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> lcdDisplayTexts(List<String> texts, List<int>? sizes) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdDisplayTexts', {
        'texts': texts,
        'sizes': sizes,
      });
      return result;
    } catch (e) {
      debugPrint('LCD显示多行文本失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> lcdDisplayBitmap(List<int> imageData) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdDisplayBitmap', {
        'image': Uint8List.fromList(imageData),
      });
      return result;
    } catch (e) {
      debugPrint('LCD显示图片失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> lcdDisplayDigital(String digital) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdDisplayDigital', {
        'digital': digital,
      });
      return result;
    } catch (e) {
      debugPrint('LCD显示数字失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> lcdClear() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdClear');
      return result;
    } catch (e) {
      debugPrint('LCD清屏失败: $e');
      return false;
    }
  }

  @override
  Future<bool?> lcdInit() async {
    try {
      final result = await methodChannel.invokeMethod<bool>('lcdInit');
      return result;
    } catch (e) {
      debugPrint('LCD初始化失败: $e');
      return false;
    }
  }
}
