# Sunmi 打印机 Flutter 插件

这是一个用于集成 Sunmi 打印机的 Flutter 插件，支持文本打印、二维码打印、条形码打印、图片打印等功能。

## 特性

- ✅ 文本打印（支持不同字体大小、对齐方式）
- ✅ 二维码打印
- ✅ 条形码打印（支持多种条形码类型）
- ✅ 图片打印
- ✅ 表格打印
- ✅ 打印机状态检查
- ✅ 切纸功能
- ✅ 开钱箱功能
- ✅ 获取打印机信息（版本、序列号等）

## 安装

在你的 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  sunmi_printer: ^1.0.0
```

然后运行：

```bash
flutter pub get
```

## 配置

### Android 配置

插件已经自动配置了所需的权限和依赖。确保你的 `android/build.gradle` 文件中包含：

```gradle
dependencies {
    implementation("com.sunmi:printerlibrary:1.0.18")
}
```

## 使用方法

### 基本使用

```dart
import 'package:sunmi_printer/sunmi_printer.dart';

class MyPrinterApp extends StatefulWidget {
  @override
  _MyPrinterAppState createState() => _MyPrinterAppState();
}

class _MyPrinterAppState extends State<MyPrinterApp> {
  final SunmiPrinter _printer = SunmiPrinter();

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    try {
      await _printer.initPrinter();
      print('打印机初始化成功');
    } catch (e) {
      print('打印机初始化失败: $e');
    }
  }

  Future<void> _printText() async {
    try {
      await _printer.printText(
        '欢迎使用 Sunmi 打印机！',
        textSize: PrinterTextSize.NORMAL,
        alignment: PrinterAlignment.CENTER,
      );
      await _printer.printNewLine(lines: 2);
    } catch (e) {
      print('打印失败: $e');
    }
  }
}
```

### 检查打印机状态

```dart
Future<void> _checkPrinterStatus() async {
  try {
    final status = await _printer.getPrinterStatus();
    switch (status) {
      case PrinterStatus.NORMAL:
        print('打印机正常');
        break;
      case PrinterStatus.OUT_OF_PAPER:
        print('打印机缺纸');
        break;
      case PrinterStatus.OVERHEATED:
        print('打印机过热');
        break;
      default:
        print('打印机状态未知');
    }
  } catch (e) {
    print('获取状态失败: $e');
  }
}
```

### 打印二维码

```dart
Future<void> _printQRCode() async {
  try {
    await _printer.setAlignment(PrinterAlignment.CENTER);
    await _printer.printQRCode(
      'https://www.example.com',
      size: 8,
      errorLevel: 0,
    );
    await _printer.printNewLine(lines: 2);
  } catch (e) {
    print('打印二维码失败: $e');
  }
}
```

### 打印条形码

```dart
Future<void> _printBarcode() async {
  try {
    await _printer.setAlignment(PrinterAlignment.CENTER);
    await _printer.printBarcode(
      '1234567890123',
      barcodeType: BarcodeType.CODE128,
      height: 162,
      width: 2,
      textPosition: 0,
    );
    await _printer.printNewLine(lines: 2);
  } catch (e) {
    print('打印条形码失败: $e');
  }
}
```

### 打印表格

```dart
Future<void> _printTable() async {
  try {
    await _printer.printTable(
      ['商品', '数量', '单价', '金额'],
      [10, 4, 6, 8],
      [PrinterAlignment.LEFT, PrinterAlignment.CENTER, PrinterAlignment.RIGHT, PrinterAlignment.RIGHT],
    );
  } catch (e) {
    print('打印表格失败: $e');
  }
}
```

### 打印图片

```dart
Future<void> _printImage() async {
  try {
    await _printer.printBitmap(
      'assets/images/logo.png',
      width: 200,
      height: 200,
    );
  } catch (e) {
    print('打印图片失败: $e');
  }
}
```

## 常量定义

### 打印机状态

```dart
class PrinterStatus {
  static const int NORMAL = 0;                    // 正常
  static const int PREPARING = 1;                 // 准备中
  static const int ABNORMAL_COMMUNICATION = 2;    // 通信异常
  static const int OUT_OF_PAPER = 3;             // 缺纸
  static const int OVERHEATED = 4;               // 过热
  static const int OPEN_COVER = 5;               // 开盖
  static const int PAPER_CUTTER_ABNORMAL = 6;    // 切纸器异常
  static const int PAPER_CUTTER_RECOVERED = 7;   // 切纸器恢复
  static const int BLACK_LABEL_OUT = 8;          // 黑标纸用完
  static const int BLACK_LABEL_READY = 9;        // 黑标纸就绪
}
```

### 对齐方式

```dart
class PrinterAlignment {
  static const int LEFT = 0;     // 左对齐
  static const int CENTER = 1;   // 居中对齐
  static const int RIGHT = 2;    // 右对齐
}
```

### 文本大小

```dart
class PrinterTextSize {
  static const int SMALL = 0;        // 小号字体
  static const int NORMAL = 1;       // 正常字体
  static const int LARGE = 2;        // 大号字体
  static const int EXTRA_LARGE = 3;  // 超大字体
}
```

### 条形码类型

```dart
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
```

## API 文档

### 基本功能

- `initPrinter()` - 初始化打印机
- `getPrinterStatus()` - 获取打印机状态
- `getPrinterVersion()` - 获取打印机版本
- `getPrinterSerialNumber()` - 获取打印机序列号

### 打印功能

- `printText(String text, {int? textSize, bool? bold, bool? underline, int? alignment})` - 打印文本
- `printNewLine({int lines = 1})` - 打印换行
- `printQRCode(String data, {int? size, int? errorLevel})` - 打印二维码
- `printBarcode(String data, {int? barcodeType, int? height, int? width, int? textPosition})` - 打印条形码
- `printBitmap(String imagePath, {int? width, int? height})` - 打印图片
- `printTable(List<String> texts, List<int> widths, List<int> alignments)` - 打印表格
- `printDivider({String? char, int? length})` - 打印分割线

### 设置功能

- `setAlignment(int alignment)` - 设置对齐方式
- `setTextSize(int size)` - 设置文本大小
- `setTextStyle({bool? bold, bool? underline})` - 设置文本样式

### 硬件控制

- `cutPaper()` - 切纸
- `openDrawer()` - 开钱箱
- `feedPaper(int lines)` - 进纸

## 注意事项

1. 此插件仅适用于 Sunmi 设备
2. 确保设备已连接 Sunmi 打印机
3. 在使用打印功能前需要先初始化打印机
4. 某些功能可能需要特定的打印机型号支持

## 示例

查看 `example/` 目录中的完整示例应用，了解如何使用所有功能。

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

