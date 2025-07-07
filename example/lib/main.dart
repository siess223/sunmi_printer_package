import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunmi_printer/sunmi_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunmi 打印机示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sunmi 打印机示例'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SunmiPrinter _printer = SunmiPrinter();
  bool _isConnected = false;
  String _statusMessage = '未连接';

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    try {
      bool? result = await _printer.bindService();
      if (result == true) {
        setState(() {
          _isConnected = true;
          _statusMessage = '连接成功';
        });
      } else {
        setState(() {
          _isConnected = false;
          _statusMessage = '连接失败';
        });
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
        _statusMessage = '连接出错: $e';
      });
    }
  }

  Future<void> _printText() async {
    await _printer.printText('Hello, Sunmi Printer!', 
        size: 24, align: PrinterAlignment.CENTER, bold: true);
  }

  Future<void> _printQRCode() async {
    await _printer.printQRCode('https://www.sunmi.com', 
        size: 8, align: PrinterAlignment.CENTER);
  }

  Future<void> _printBarcode() async {
    await _printer.printBarcode('123456789012', 
        type: BarcodeType.CODE128, align: PrinterAlignment.CENTER);
  }

  Future<void> _printTable() async {
    List<Map<String, dynamic>> tableData = [
      {'columns': ['商品', '数量', '价格']},
      {'columns': ['苹果', '2', '10.00']},
      {'columns': ['香蕉', '3', '6.00']},
      {'columns': ['橙子', '1', '5.00']},
    ];
    
    await _printer.printTable(tableData, columnWidths: [15, 8, 10]);
  }

  Future<void> _printReceipt() async {
    Map<String, dynamic> receiptData = {
      'header': '购物小票',
      'items': [
        {'name': '苹果', 'quantity': '2', 'price': '10.00'},
        {'name': '香蕉', 'quantity': '3', 'price': '6.00'},
        {'name': '橙子', 'quantity': '1', 'price': '5.00'},
      ],
      'total': '21.00',
      'footer': '谢谢光临!',
    };
    
    await _printer.printReceipt(receiptData);
  }

  Future<void> _cutPaper() async {
    await _printer.cutPaper();
  }

  Future<void> _feedPaper() async {
    await _printer.feedPaper(lines: 3);
  }

  Future<void> _checkStatus() async {
    var status = await _printer.getPrinterStatus();
    var info = await _printer.getPrinterInfo();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('打印机状态'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('状态: ${status.toString()}'),
            Text('信息: ${info.toString()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  // ===== LCD 客显功能 =====
  
  Future<void> _lcdDisplayText() async {
    await _printer.lcdDisplayText('欢迎光临商米！', size: 32, bold: true);
  }

  Future<void> _lcdDisplayTexts() async {
    List<String> texts = ['商品A', '商品B', '商品C', '商品D'];
    await _printer.lcdDisplayTexts(texts);
  }

  Future<void> _lcdDisplayDigital() async {
    await _printer.lcdDisplayDigital('¥128.50');
  }

  Future<void> _lcdClear() async {
    await _printer.lcdClear();
  }

  Future<void> _lcdInit() async {
    await _printer.lcdInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 状态显示
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '打印机状态',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isConnected ? Icons.check_circle : Icons.error,
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(_statusMessage),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 打印机功能按钮
            const Text(
              '打印机功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isConnected ? _printText : null,
              child: const Text('打印文本'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _printQRCode : null,
              child: const Text('打印二维码'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _printBarcode : null,
              child: const Text('打印条形码'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _printTable : null,
              child: const Text('打印表格'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _printReceipt : null,
              child: const Text('打印小票'),
            ),
            const SizedBox(height: 16),
            
            // 硬件功能按钮
            const Text(
              '硬件功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isConnected ? _cutPaper : null,
              child: const Text('切纸'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _feedPaper : null,
              child: const Text('进纸'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _checkStatus : null,
              child: const Text('检查状态'),
            ),
            const SizedBox(height: 16),
            
            // LCD 客显功能按钮
            const Text(
              'LCD 客显功能',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            ElevatedButton(
              onPressed: _isConnected ? _lcdInit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('LCD 初始化'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _lcdDisplayText : null,
              child: const Text('LCD 显示文本'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _lcdDisplayTexts : null,
              child: const Text('LCD 显示列表'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _lcdDisplayDigital : null,
              child: const Text('LCD 显示价格'),
            ),
            const SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _isConnected ? _lcdClear : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('LCD 清屏'),
            ),
            const SizedBox(height: 16),
            
            // 重新连接按钮
            ElevatedButton(
              onPressed: _initPrinter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('重新连接打印机'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _printer.unBindService();
    super.dispose();
  }
}
