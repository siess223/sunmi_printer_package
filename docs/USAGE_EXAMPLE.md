# 📱 商米打印机插件使用示例

本文档提供了在新项目中使用商米打印机插件的完整示例。

## 🚀 快速开始

### 1. 创建新项目

```bash
flutter create my_pos_app
cd my_pos_app
```

### 2. 添加依赖

编辑 `pubspec.yaml`：

```yaml
dependencies:
  flutter:
    sdk: flutter
  sunmi_printer:
    git:
      url: https://github.com/yourusername/sunmi_printer.git
      ref: v1.0.0
```

### 3. 安装依赖

```bash
flutter pub get
```

### 4. 配置权限

编辑 `android/app/src/main/AndroidManifest.xml`：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- 商米打印机权限 -->
    <uses-permission android:name="android.permission.BLUETOOTH" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="com.sunmi.permission.PRINTER" />
    
    <!-- 包可见性声明（Android 11+） -->
    <queries>
        <package android:name="woyou.aidlservice.jiuv5" />
        <package android:name="com.sunmi.hcservice" />
    </queries>

    <application
        android:label="my_pos_app"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme">
            <!-- ... 其他配置 ... -->
        </activity>
        
    </application>
</manifest>
```

## 📝 完整示例代码

### 主页面 (lib/main.dart)

```dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer/sunmi_printer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '商米打印机示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PrinterDemoPage(),
    );
  }
}

class PrinterDemoPage extends StatefulWidget {
  @override
  _PrinterDemoPageState createState() => _PrinterDemoPageState();
}

class _PrinterDemoPageState extends State<PrinterDemoPage> {
  final SunmiPrinter _printer = SunmiPrinter();
  bool _isConnected = false;
  bool _isConnecting = false;
  String _statusMessage = '未连接';
  String _lcdText = '';

  @override
  void initState() {
    super.initState();
    _initializePrinter();
  }

  Future<void> _initializePrinter() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = '正在连接...';
    });

    try {
      final result = await _printer.bindService();
      if (result == true) {
        setState(() {
          _isConnected = true;
          _statusMessage = '打印机已连接';
        });
        
        // 初始化 LCD
        await _printer.lcdInit();
        await _printer.lcdDisplayText('欢迎使用商米打印机！');
      } else {
        setState(() {
          _statusMessage = '连接失败';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = '连接出错: $e';
      });
    } finally {
      setState(() {
        _isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商米打印机示例'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态卡片
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.check_circle : Icons.error,
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _statusMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_isConnecting)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // 打印功能按钮
            Text(
              '打印功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isConnected ? _printText : null,
                  child: Text('打印文本'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _printReceipt : null,
                  child: Text('打印小票'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _printQRCode : null,
                  child: Text('打印二维码'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _printBarcode : null,
                  child: Text('打印条形码'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _printTable : null,
                  child: Text('打印表格'),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // LCD 控制
            Text(
              'LCD 客显控制',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            
            TextField(
              onChanged: (text) {
                setState(() {
                  _lcdText = text;
                });
              },
              decoration: InputDecoration(
                labelText: 'LCD 显示文本',
                border: OutlineInputBorder(),
              ),
            ),
            
            SizedBox(height: 10),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isConnected ? _lcdDisplayText : null,
                  child: Text('显示文本'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _lcdDisplayMultiText : null,
                  child: Text('多行显示'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _lcdDisplayPrice : null,
                  child: Text('显示价格'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _lcdClear : null,
                  child: Text('清屏'),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // 硬件控制
            Text(
              '硬件控制',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isConnected ? _cutPaper : null,
                  child: Text('切纸'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _openDrawer : null,
                  child: Text('开钱箱'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _feedPaper : null,
                  child: Text('进纸'),
                ),
                ElevatedButton(
                  onPressed: _isConnected ? _checkStatus : null,
                  child: Text('检查状态'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 打印文本
  Future<void> _printText() async {
    try {
      await _printer.printText(
        '这是一个测试文本\n',
        size: 24,
        bold: true,
        align: 'center',
      );
      await _printer.feedPaper(lines: 2);
      _showMessage('文本打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  // 打印小票
  Future<void> _printReceipt() async {
    try {
      await _printer.printText('========== 购物小票 ==========\n', 
          size: 20, bold: true, align: 'center');
      await _printer.printText('商店名称: 测试商店\n', size: 16);
      await _printer.printText('时间: ${DateTime.now().toString().substring(0, 19)}\n', 
          size: 16);
      await _printer.printText('--------------------------------\n', size: 16);
      
      // 商品列表
      List<Map<String, dynamic>> items = [
        {'name': '苹果', 'qty': '2', 'price': '10.00'},
        {'name': '香蕉', 'qty': '3', 'price': '6.00'},
        {'name': '橙子', 'qty': '1', 'price': '5.00'},
      ];
      
      for (var item in items) {
        await _printer.printText(
          '${item['name']} x${item['qty']} ¥${item['price']}\n',
          size: 16,
        );
      }
      
      await _printer.printText('--------------------------------\n', size: 16);
      await _printer.printText('总计: ¥21.00\n', size: 18, bold: true);
      await _printer.printText('谢谢惠顾！\n', size: 16, align: 'center');
      
      await _printer.feedPaper(lines: 3);
      await _printer.cutPaper();
      
      _showMessage('小票打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  // 打印二维码
  Future<void> _printQRCode() async {
    try {
      await _printer.printText('扫描二维码:\n', size: 16, align: 'center');
      await _printer.printQRCode(
        'https://www.sunmi.com',
        size: 8,
        align: 'center',
      );
      await _printer.feedPaper(lines: 2);
      _showMessage('二维码打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  // 打印条形码
  Future<void> _printBarcode() async {
    try {
      await _printer.printText('商品条码:\n', size: 16, align: 'center');
      await _printer.printBarcode(
        '1234567890123',
        type: 'CODE128',
        width: 2,
        height: 100,
        align: 'center',
      );
      await _printer.feedPaper(lines: 2);
      _showMessage('条形码打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  // 打印表格
  Future<void> _printTable() async {
    try {
      List<Map<String, dynamic>> tableData = [
        {'columns': ['商品', '数量', '单价', '金额']},
        {'columns': ['苹果', '2', '5.00', '10.00']},
        {'columns': ['香蕉', '3', '2.00', '6.00']},
        {'columns': ['橙子', '1', '5.00', '5.00']},
        {'columns': ['总计', '', '', '21.00']},
      ];
      
      await _printer.printTable(
        tableData,
        columnWidths: [12, 6, 8, 8],
      );
      await _printer.feedPaper(lines: 2);
      _showMessage('表格打印成功');
    } catch (e) {
      _showMessage('打印失败: $e');
    }
  }

  // LCD 显示文本
  Future<void> _lcdDisplayText() async {
    try {
      await _printer.lcdDisplayText(
        _lcdText.isEmpty ? '你好，商米！' : _lcdText,
        size: 20,
        bold: true,
      );
      _showMessage('LCD 显示成功');
    } catch (e) {
      _showMessage('LCD 显示失败: $e');
    }
  }

  // LCD 多行显示
  Future<void> _lcdDisplayMultiText() async {
    try {
      await _printer.lcdDisplayTexts([
        '欢迎光临',
        '商米设备',
        '谢谢惠顾！'
      ]);
      _showMessage('LCD 多行显示成功');
    } catch (e) {
      _showMessage('LCD 显示失败: $e');
    }
  }

  // LCD 显示价格
  Future<void> _lcdDisplayPrice() async {
    try {
      await _printer.lcdDisplayDigital('¥128.50');
      _showMessage('LCD 价格显示成功');
    } catch (e) {
      _showMessage('LCD 显示失败: $e');
    }
  }

  // LCD 清屏
  Future<void> _lcdClear() async {
    try {
      await _printer.lcdClear();
      _showMessage('LCD 清屏成功');
    } catch (e) {
      _showMessage('LCD 操作失败: $e');
    }
  }

  // 切纸
  Future<void> _cutPaper() async {
    try {
      await _printer.cutPaper();
      _showMessage('切纸成功');
    } catch (e) {
      _showMessage('切纸失败: $e');
    }
  }

  // 开钱箱
  Future<void> _openDrawer() async {
    try {
      await _printer.openDrawer();
      _showMessage('开钱箱成功');
    } catch (e) {
      _showMessage('开钱箱失败: $e');
    }
  }

  // 进纸
  Future<void> _feedPaper() async {
    try {
      await _printer.feedPaper(lines: 5);
      _showMessage('进纸成功');
    } catch (e) {
      _showMessage('进纸失败: $e');
    }
  }

  // 检查状态
  Future<void> _checkStatus() async {
    try {
      final status = await _printer.getPrinterStatus();
      final info = await _printer.getPrinterInfo();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('打印机状态'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('状态: ${status?['message'] ?? '未知'}'),
              Text('设备: ${info?['deviceName'] ?? '未知'}'),
              Text('版本: ${info?['version'] ?? '未知'}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('确定'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showMessage('获取状态失败: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _printer.unBindService();
    super.dispose();
  }
}
```

## 🎯 专业 POS 应用示例

### 销售界面 (lib/pages/sales_page.dart)

```dart
import 'package:flutter/material.dart';
import 'package:sunmi_printer/sunmi_printer.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final SunmiPrinter _printer = SunmiPrinter();
  final List<SaleItem> _cart = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    await _printer.bindService();
    await _printer.lcdInit();
    await _printer.lcdDisplayText('欢迎使用 POS 系统');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('销售终端'),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt),
            onPressed: _printReceipt,
          ),
        ],
      ),
      body: Column(
        children: [
          // 商品列表
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final item = _cart[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('数量: ${item.quantity}'),
                  trailing: Text('¥${item.totalPrice.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          
          // 总计
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('总计:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('¥${_total.toStringAsFixed(2)}', 
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // 操作按钮
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addItem,
                    child: Text('添加商品'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _checkout,
                    child: Text('结算'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addItem() {
    // 添加商品逻辑
    setState(() {
      _cart.add(SaleItem(
        name: '商品${_cart.length + 1}',
        price: 10.0,
        quantity: 1,
      ));
      _updateTotal();
    });
  }

  void _updateTotal() {
    _total = _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
    
    // 更新 LCD 显示
    _printer.lcdDisplayTexts([
      '总计金额:',
      '¥${_total.toStringAsFixed(2)}',
      '商品${_cart.length}件'
    ]);
  }

  Future<void> _checkout() async {
    if (_cart.isEmpty) return;
    
    try {
      await _printReceipt();
      await _printer.cutPaper();
      
      setState(() {
        _cart.clear();
        _total = 0.0;
      });
      
      await _printer.lcdDisplayText('交易完成，谢谢惠顾！');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('交易完成')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('打印失败: $e')),
      );
    }
  }

  Future<void> _printReceipt() async {
    await _printer.printText('========== 购物小票 ==========\n', 
        size: 20, bold: true, align: 'center');
    await _printer.printText('商店名称: 测试商店\n', size: 16);
    await _printer.printText('时间: ${DateTime.now().toString().substring(0, 19)}\n', 
        size: 16);
    await _printer.printText('--------------------------------\n', size: 16);
    
    for (var item in _cart) {
      await _printer.printText(
        '${item.name} x${item.quantity} ¥${item.totalPrice.toStringAsFixed(2)}\n',
        size: 16,
      );
    }
    
    await _printer.printText('--------------------------------\n', size: 16);
    await _printer.printText('总计: ¥${_total.toStringAsFixed(2)}\n', 
        size: 18, bold: true);
    await _printer.printText('谢谢惠顾！\n', size: 16, align: 'center');
    
    await _printer.feedPaper(lines: 3);
  }

  @override
  void dispose() {
    _printer.unBindService();
    super.dispose();
  }
}

class SaleItem {
  final String name;
  final double price;
  final int quantity;
  
  SaleItem({required this.name, required this.price, required this.quantity});
  
  double get totalPrice => price * quantity;
}
```

## 🛡️ 错误处理最佳实践

### 打印服务管理器 (lib/services/printer_service.dart)

```dart
import 'package:sunmi_printer/sunmi_printer.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  final SunmiPrinter _printer = SunmiPrinter();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      final result = await _printer.bindService();
      if (result == true) {
        _isInitialized = true;
        await _printer.lcdInit();
        return true;
      }
      return false;
    } catch (e) {
      print('打印机初始化失败: $e');
      return false;
    }
  }

  Future<bool> printWithRetry(Future<bool?> Function() printAction, 
      {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final result = await printAction();
        if (result == true) return true;
        
        // 重试前等待
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        print('打印尝试 ${i + 1} 失败: $e');
        if (i == maxRetries - 1) rethrow;
      }
    }
    return false;
  }

  Future<bool> checkPrinterHealth() async {
    try {
      final connected = await _printer.isPrinterConnected();
      final status = await _printer.getPrinterStatus();
      
      return connected == true && status != null;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _printer.unBindService();
    _isInitialized = false;
  }
}
```

## 🎨 UI 组件库

### 打印预览组件 (lib/widgets/print_preview.dart)

```dart
import 'package:flutter/material.dart';

class PrintPreview extends StatelessWidget {
  final List<PrintItem> items;
  final VoidCallback? onPrint;

  const PrintPreview({
    Key? key,
    required this.items,
    this.onPrint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AppBar(
            title: Text('打印预览'),
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.black,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.print),
                onPressed: onPrint,
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: items.map((item) => _buildPreviewItem(item)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(PrintItem item) {
    switch (item.type) {
      case PrintItemType.text:
        return Text(
          item.content,
          style: TextStyle(
            fontSize: item.fontSize?.toDouble() ?? 16,
            fontWeight: item.bold ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: _getTextAlign(item.align),
        );
      case PrintItemType.qrCode:
        return Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
          child: Center(child: Text('QR: ${item.content}')),
        );
      case PrintItemType.barcode:
        return Container(
          width: 200,
          height: 50,
          color: Colors.grey[300],
          child: Center(child: Text('条码: ${item.content}')),
        );
      default:
        return Container();
    }
  }

  TextAlign _getTextAlign(String? align) {
    switch (align) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      default:
        return TextAlign.left;
    }
  }
}

class PrintItem {
  final PrintItemType type;
  final String content;
  final int? fontSize;
  final String? align;
  final bool bold;

  PrintItem({
    required this.type,
    required this.content,
    this.fontSize,
    this.align,
    this.bold = false,
  });
}

enum PrintItemType {
  text,
  qrCode,
  barcode,
}
```

## 🔧 实用工具

### 打印模板管理 (lib/utils/print_templates.dart)

```dart
import 'package:sunmi_printer/sunmi_printer.dart';

class PrintTemplates {
  static Future<void> printReceipt(
    SunmiPrinter printer, {
    required String storeName,
    required List<ReceiptItem> items,
    required double total,
    String? customerInfo,
  }) async {
    // 店铺信息
    await printer.printText('$storeName\n', size: 24, bold: true, align: 'center');
    await printer.printText('电话: 123-456-7890\n', size: 16, align: 'center');
    await printer.printText('地址: 测试地址\n', size: 16, align: 'center');
    await printer.printText('${'=' * 32}\n', size: 16);
    
    // 时间
    await printer.printText('时间: ${DateTime.now().toString().substring(0, 19)}\n', 
        size: 16);
    
    // 客户信息
    if (customerInfo != null) {
      await printer.printText('客户: $customerInfo\n', size: 16);
    }
    
    await printer.printText('${'-' * 32}\n', size: 16);
    
    // 商品列表
    await printer.printText('商品                 数量  金额\n', size: 16);
    for (var item in items) {
      await printer.printText(
        '${item.name.padRight(16)} x${item.quantity.toString().padLeft(2)} '
        '¥${item.totalPrice.toStringAsFixed(2).padLeft(6)}\n',
        size: 16,
      );
    }
    
    await printer.printText('${'-' * 32}\n', size: 16);
    await printer.printText('总计: ¥${total.toStringAsFixed(2)}\n', 
        size: 20, bold: true);
    await printer.printText('${'-' * 32}\n', size: 16);
    
    // 二维码
    await printer.printText('扫码关注我们:\n', size: 16, align: 'center');
    await printer.printQRCode('https://www.example.com', size: 6, align: 'center');
    
    await printer.printText('谢谢惠顾，欢迎再来！\n', size: 16, align: 'center');
    await printer.feedPaper(lines: 3);
  }
}

class ReceiptItem {
  final String name;
  final int quantity;
  final double price;
  
  ReceiptItem({required this.name, required this.quantity, required this.price});
  
  double get totalPrice => price * quantity;
}
```

## 🚀 运行应用

1. 确保您的设备是商米设备
2. 运行命令：
   ```bash
   flutter run
   ```

## 📝 注意事项

1. **设备要求**：必须在商米设备上运行
2. **权限**：确保已添加所有必要权限
3. **网络**：首次运行需要网络下载依赖
4. **调试**：使用 `flutter logs` 查看详细日志

## 🎯 扩展功能

您可以基于此示例扩展更多功能：

- 商品数据库管理
- 销售统计报表
- 会员管理系统
- 库存管理
- 网络同步功能
- 多语言支持

---

**完整示例代码可在 [GitHub](https://github.com/yourusername/sunmi_printer_example) 上查看。** 