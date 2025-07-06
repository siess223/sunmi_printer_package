import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sunmi_printer_platform_interface.dart';

/// An implementation of [SunmiPrinterPlatform] that uses method channels.
class MethodChannelSunmiPrinter extends SunmiPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sunmi_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<int?> getPrinterStatus() async {
    final status = await methodChannel.invokeMethod<int>('getPrinterStatus');
    return status;
  }

  @override
  Future<bool?> initPrinter() async {
    final result = await methodChannel.invokeMethod<bool>('initPrinter');
    return result;
  }

  @override
  Future<void> printText(String text, int? textSize, bool? bold, bool? underline, int? alignment) async {
    await methodChannel.invokeMethod('printText', {
      'text': text,
      'textSize': textSize,
      'bold': bold,
      'underline': underline,
      'alignment': alignment,
    });
  }

  @override
  Future<void> printNewLine(int lines) async {
    await methodChannel.invokeMethod('printNewLine', {'lines': lines});
  }

  @override
  Future<void> printQRCode(String data, int? size, int? errorLevel) async {
    await methodChannel.invokeMethod('printQRCode', {
      'data': data,
      'size': size,
      'errorLevel': errorLevel,
    });
  }

  @override
  Future<void> printBarcode(String data, int? barcodeType, int? height, int? width, int? textPosition) async {
    await methodChannel.invokeMethod('printBarcode', {
      'data': data,
      'barcodeType': barcodeType,
      'height': height,
      'width': width,
      'textPosition': textPosition,
    });
  }

  @override
  Future<void> printBitmap(String imagePath, int? width, int? height) async {
    await methodChannel.invokeMethod('printBitmap', {
      'imagePath': imagePath,
      'width': width,
      'height': height,
    });
  }

  @override
  Future<void> setAlignment(int alignment) async {
    await methodChannel.invokeMethod('setAlignment', {'alignment': alignment});
  }

  @override
  Future<void> setTextSize(int size) async {
    await methodChannel.invokeMethod('setTextSize', {'size': size});
  }

  @override
  Future<void> setTextStyle(bool? bold, bool? underline) async {
    await methodChannel.invokeMethod('setTextStyle', {
      'bold': bold,
      'underline': underline,
    });
  }

  @override
  Future<void> cutPaper() async {
    await methodChannel.invokeMethod('cutPaper');
  }

  @override
  Future<void> openDrawer() async {
    await methodChannel.invokeMethod('openDrawer');
  }

  @override
  Future<String?> getPrinterSerialNumber() async {
    final serial = await methodChannel.invokeMethod<String>('getPrinterSerialNumber');
    return serial;
  }

  @override
  Future<String?> getPrinterVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPrinterVersion');
    return version;
  }

  @override
  Future<void> printTable(List<String> texts, List<int> widths, List<int> alignments) async {
    await methodChannel.invokeMethod('printTable', {
      'texts': texts,
      'widths': widths,
      'alignments': alignments,
    });
  }

  @override
  Future<void> printDivider(String? char, int? length) async {
    await methodChannel.invokeMethod('printDivider', {
      'char': char,
      'length': length,
    });
  }

  @override
  Future<void> feedPaper(int lines) async {
    await methodChannel.invokeMethod('feedPaper', {'lines': lines});
  }
}
