# Sunmi Printer Flutter Plugin

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

一个功能完整的商米打印机 Flutter 插件，支持打印、LCD 客显等功能。

## ✨ 功能特性

### 📄 打印功能
- ✅ 文本打印（支持字体大小、加粗、下划线、对齐）
- ✅ 图片打印（支持 Bitmap 格式）
- ✅ 二维码打印（可设置大小和纠错级别）
- ✅ 条形码打印（支持多种格式）
- ✅ 表格打印（支持多列对齐）
- ✅ 小票打印（自定义格式）

### 🖥️ LCD 客显功能
- ✅ 单行文本显示（可设置字体大小和加粗）
- ✅ 多行文本显示（最多3行，支持对齐）
- ✅ 图片显示（128x40 像素）
- ✅ 数字价格显示
- ✅ 屏幕清除和初始化

### 🔧 硬件控制
- ✅ 切纸功能
- ✅ 开钱箱
- ✅ 进纸控制
- ✅ 打印机状态查询
- ✅ 缓冲区管理

## 📱 支持设备

- 商米 T1 系列
- 商米 T2 系列  
- 商米 V1 系列
- 商米 V2 系列
- 商米 P1 系列
- 商米 P2 系列
- 其他支持商米打印服务的设备

## 🚀 安装

### 1. 添加依赖

在您的 `pubspec.yaml` 文件中添加：

```yaml
dependencies:
  sunmi_printer: 
    git:
      url: https://github.com/yourusername/sunmi_printer.git
      ref: main
```

### 2. 安装依赖

```bash
flutter pub get
```

### 3. Android 权限配置

在 `android/app/src/main/AndroidManifest.xml` 中添加必要权限：

```xml
<!-- 商米打印机权限 -->
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- 商米打印服务权限 -->
<uses-permission android:name="com.sunmi.permission.PRINTER" />

<!-- 包可见性声明（Android 11+） -->
<queries>
    <package android:name="woyou.aidlservice.jiuv5" />
    <package android:name="com.sunmi.hcservice" />
</queries>
```

## 📖 使用方法

### 基础使用

```dart
import 'package:sunmi_printer/sunmi_printer.dart';

class PrinterExample extends StatefulWidget {
  @override
  _PrinterExampleState createState() => _PrinterExampleState();
}

class _PrinterExampleState extends State<PrinterExample> {
  final _printer = SunmiPrinter();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    try {
      // 绑定打印服务
      await _printer.bindService();
      setState(() {
        _isConnected = true;
      });
    } catch (e) {
      print('初始化打印机失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商米打印机示例')),
      body: Center(
        child: Column(
          children: [
            Text(_isConnected ? '打印机已连接' : '打印机未连接'),
            ElevatedButton(
              onPressed: _isConnected ? _printText : null,
              child: Text('打印文本'),
            ),
            ElevatedButton(
              onPressed: _isConnected ? _printQRCode : null,
              child: Text('打印二维码'),
            ),
            ElevatedButton(
              onPressed: _isConnected ? _lcdDisplayText : null,
              child: Text('LCD 显示文本'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printText() async {
    await _printer.printText(
      '欢迎光临！',
      size: 24,
      bold: true,
      align: 'center',
    );
  }

  Future<void> _printQRCode() async {
    await _printer.printQRCode(
      'https://www.sunmi.com',
      size: 8,
      align: 'center',
    );
  }

  Future<void> _lcdDisplayText() async {
    await _printer.lcdDisplayText(
      '欢迎光临商米！',
      size: 20,
      bold: true,
    );
  }

  @override
  void dispose() {
    _printer.unBindService();
    super.dispose();
  }
}
```

### 打印表格示例

```dart
Future<void> printTableExample() async {
  List<Map<String, dynamic>> tableData = [
    {'columns': ['商品', '数量', '价格']},
    {'columns': ['苹果', '2', '10.00']},
    {'columns': ['香蕉', '3', '6.00']},
    {'columns': ['橙子', '1', '5.00']},
  ];
  
  await _printer.printTable(
    tableData, 
    columnWidths: [15, 8, 10]
  );
}
```

### LCD 客显示例

```dart
// 初始化 LCD
await _printer.lcdInit();

// 显示单行文本
await _printer.lcdDisplayText('欢迎光临！', size: 24, bold: true);

// 显示多行文本
await _printer.lcdDisplayTexts([
  '商品：苹果',
  '数量：2个', 
  '价格：¥10.00'
]);

// 显示价格
await _printer.lcdDisplayDigital('¥128.50');

// 清除屏幕
await _printer.lcdClear();
```

## 📚 API 文档

### 打印机服务

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `bindService()` | - | `Future<bool?>` | 绑定打印服务 |
| `unBindService()` | - | `Future<bool?>` | 解绑打印服务 |
| `isPrinterConnected()` | - | `Future<bool?>` | 检查打印机连接状态 |

### 打印功能

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `printText()` | `text, size?, align?, bold?, underline?` | `Future<bool?>` | 打印文本 |
| `printImage()` | `imageData, width?, height?, align?` | `Future<bool?>` | 打印图片 |
| `printQRCode()` | `data, size?, align?` | `Future<bool?>` | 打印二维码 |
| `printBarcode()` | `data, type?, width?, height?, align?` | `Future<bool?>` | 打印条形码 |
| `printTable()` | `tableData, columnWidths?` | `Future<bool?>` | 打印表格 |

### LCD 客显功能

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `lcdInit()` | - | `Future<bool?>` | 初始化 LCD |
| `lcdDisplayText()` | `text, size?, bold?` | `Future<bool?>` | 显示单行文本 |
| `lcdDisplayTexts()` | `texts, sizes?` | `Future<bool?>` | 显示多行文本 |
| `lcdDisplayBitmap()` | `imageData` | `Future<bool?>` | 显示图片 |
| `lcdDisplayDigital()` | `digital` | `Future<bool?>` | 显示数字 |
| `lcdClear()` | - | `Future<bool?>` | 清除屏幕 |

### 硬件控制

| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| `cutPaper()` | - | `Future<bool?>` | 切纸 |
| `openDrawer()` | - | `Future<bool?>` | 开钱箱 |
| `feedPaper()` | `lines?` | `Future<bool?>` | 进纸 |
| `getPrinterStatus()` | - | `Future<Map<String, dynamic>?>` | 获取打印机状态 |
| `getPrinterInfo()` | - | `Future<Map<String, dynamic>?>` | 获取打印机信息 |

## ⚠️ 注意事项

1. **权限要求**：确保应用已获得必要的蓝牙和存储权限
2. **设备支持**：仅支持商米设备，其他设备无法使用
3. **服务连接**：使用前请先调用 `bindService()` 连接打印服务
4. **LCD 功能**：LCD 客显功能仅在支持的商米设备上可用
5. **异常处理**：建议使用 try-catch 包装所有打印操作

## 🐛 常见问题

### Q: 打印机无法连接？
A: 
1. 检查设备是否为商米设备
2. 确认已添加必要权限
3. 检查打印服务是否正常运行

### Q: LCD 显示不正常？
A: 
1. 确认设备支持 LCD 客显功能
2. 先调用 `lcdInit()` 初始化
3. 检查文本长度是否超出屏幕限制

### Q: 打印乱码？
A: 
1. 确认文本编码为 UTF-8
2. 检查字体是否支持中文显示

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

本项目基于 MIT 许可证开源。

## 📞 联系我们

- GitHub: [您的 GitHub 链接]
- Email: [您的邮箱]

---

**注意：本插件仅适用于商米设备，请确保在正确的硬件环境中使用。**

