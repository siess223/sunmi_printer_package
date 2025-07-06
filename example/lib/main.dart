import 'package:flutter/material.dart';
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
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SunmiPrinter _printer = SunmiPrinter();
  String _statusText = '未知';
  String _versionText = '未知';
  String _serialText = '未知';
  bool _isConnected = false;
  
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _qrController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initPrinter();
  }

  Future<void> _initPrinter() async {
    try {
      final result = await _printer.initPrinter();
      if (result == true) {
        setState(() {
          _isConnected = true;
        });
        _getPrinterInfo();
      }
    } catch (e) {
      _showError('初始化打印机失败: $e');
    }
  }

  Future<void> _getPrinterInfo() async {
    try {
      final status = await _printer.getPrinterStatus();
      final version = await _printer.getPrinterVersion();
      final serial = await _printer.getPrinterSerialNumber();
      
      setState(() {
        _statusText = _getStatusText(status);
        _versionText = version ?? '未知';
        _serialText = serial ?? '未知';
      });
    } catch (e) {
      _showError('获取打印机信息失败: $e');
    }
  }

  String _getStatusText(int? status) {
    switch (status) {
      case PrinterStatus.NORMAL:
        return '正常';
      case PrinterStatus.PREPARING:
        return '准备中';
      case PrinterStatus.ABNORMAL_COMMUNICATION:
        return '通信异常';
      case PrinterStatus.OUT_OF_PAPER:
        return '缺纸';
      case PrinterStatus.OVERHEATED:
        return '过热';
      case PrinterStatus.OPEN_COVER:
        return '开盖';
      case PrinterStatus.PAPER_CUTTER_ABNORMAL:
        return '切纸器异常';
      case PrinterStatus.PAPER_CUTTER_RECOVERED:
        return '切纸器恢复';
      case PrinterStatus.BLACK_LABEL_OUT:
        return '黑标纸用完';
      case PrinterStatus.BLACK_LABEL_READY:
        return '黑标纸就绪';
      default:
        return '未知状态';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _printText() async {
    if (_textController.text.isEmpty) {
      _showError('请输入要打印的文本');
      return;
    }

    try {
      await _printer.printText(
        _textController.text,
        textSize: PrinterTextSize.NORMAL,
        alignment: PrinterAlignment.CENTER,
      );
      await _printer.printNewLine(lines: 2);
      _showSuccess('文本打印成功');
    } catch (e) {
      _showError('打印失败: $e');
    }
  }

  Future<void> _printQRCode() async {
    if (_qrController.text.isEmpty) {
      _showError('请输入二维码内容');
      return;
    }

    try {
      await _printer.setAlignment(PrinterAlignment.CENTER);
      await _printer.printQRCode(_qrController.text, size: 8);
      await _printer.printNewLine(lines: 2);
      _showSuccess('二维码打印成功');
    } catch (e) {
      _showError('打印失败: $e');
    }
  }

  Future<void> _printBarcode() async {
    if (_barcodeController.text.isEmpty) {
      _showError('请输入条形码内容');
      return;
    }

    try {
      await _printer.setAlignment(PrinterAlignment.CENTER);
      await _printer.printBarcode(
        _barcodeController.text,
        barcodeType: BarcodeType.CODE128,
        height: 162,
        width: 2,
        textPosition: 0,
      );
      await _printer.printNewLine(lines: 2);
      _showSuccess('条形码打印成功');
    } catch (e) {
      _showError('打印失败: $e');
    }
  }

  Future<void> _printReceipt() async {
    try {
      // 打印店铺名称
      await _printer.setAlignment(PrinterAlignment.CENTER);
      await _printer.setTextSize(PrinterTextSize.LARGE);
      await _printer.printText('商店名称');
      await _printer.printNewLine();
      
      // 打印分割线
      await _printer.printDivider();
      await _printer.printNewLine();
      
      // 打印商品信息
      await _printer.setAlignment(PrinterAlignment.LEFT);
      await _printer.setTextSize(PrinterTextSize.NORMAL);
      await _printer.printTable(
        ['商品名称', '数量', '单价', '金额'],
        [10, 4, 6, 8],
        [PrinterAlignment.LEFT, PrinterAlignment.CENTER, PrinterAlignment.RIGHT, PrinterAlignment.RIGHT],
      );
      await _printer.printNewLine();
      
      await _printer.printTable(
        ['苹果', '2', '5.00', '10.00'],
        [10, 4, 6, 8],
        [PrinterAlignment.LEFT, PrinterAlignment.CENTER, PrinterAlignment.RIGHT, PrinterAlignment.RIGHT],
      );
      
      await _printer.printTable(
        ['香蕉', '3', '3.00', '9.00'],
        [10, 4, 6, 8],
        [PrinterAlignment.LEFT, PrinterAlignment.CENTER, PrinterAlignment.RIGHT, PrinterAlignment.RIGHT],
      );
      
      await _printer.printNewLine();
      await _printer.printDivider();
      await _printer.printNewLine();
      
      // 打印总计
      await _printer.setAlignment(PrinterAlignment.RIGHT);
      await _printer.printText('总计: ¥19.00');
      await _printer.printNewLine();
      
      // 打印时间
      await _printer.setAlignment(PrinterAlignment.CENTER);
      await _printer.setTextSize(PrinterTextSize.SMALL);
      await _printer.printText('${DateTime.now().toString().substring(0, 19)}');
      await _printer.printNewLine(lines: 3);
      
      _showSuccess('小票打印成功');
    } catch (e) {
      _showError('打印失败: $e');
    }
  }

  Future<void> _cutPaper() async {
    try {
      await _printer.cutPaper();
      _showSuccess('切纸成功');
    } catch (e) {
      _showError('切纸失败: $e');
    }
  }

  Future<void> _openDrawer() async {
    try {
      await _printer.openDrawer();
      _showSuccess('钱箱打开成功');
    } catch (e) {
      _showError('打开钱箱失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sunmi 打印机示例'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 打印机状态信息
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
                        Text('连接状态: ${_isConnected ? '已连接' : '未连接'}'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('打印机状态: $_statusText'),
                    const SizedBox(height: 4),
                    Text('版本号: $_versionText'),
                    const SizedBox(height: 4),
                    Text('序列号: $_serialText'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _getPrinterInfo,
                      child: const Text('刷新状态'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 文本打印
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '文本打印',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: '输入要打印的文本',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _printText,
                      child: const Text('打印文本'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 二维码打印
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '二维码打印',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _qrController,
                      decoration: const InputDecoration(
                        labelText: '输入二维码内容',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _printQRCode,
                      child: const Text('打印二维码'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 条形码打印
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '条形码打印',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: '输入条形码内容',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _printBarcode,
                      child: const Text('打印条形码'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 功能按钮
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '其他功能',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _printReceipt,
                          child: const Text('打印小票'),
                        ),
                        ElevatedButton(
                          onPressed: _cutPaper,
                          child: const Text('切纸'),
                        ),
                        ElevatedButton(
                          onPressed: _openDrawer,
                          child: const Text('开钱箱'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _qrController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }
}
