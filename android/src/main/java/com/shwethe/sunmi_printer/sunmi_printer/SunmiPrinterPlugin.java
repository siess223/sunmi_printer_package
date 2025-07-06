package com.shwethe.sunmi_printer.sunmi_printer;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.sunmi.peripheral.printer.InnerPrinterManager;
import com.sunmi.peripheral.printer.InnerPrinterCallback;
import com.sunmi.peripheral.printer.InnerPrinterException;
import com.sunmi.peripheral.printer.InnerResultCallback;
import com.sunmi.peripheral.printer.SunmiPrinterService;

/** SunmiPrinterPlugin */
public class SunmiPrinterPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String TAG = "SunmiPrinterPlugin";
  private MethodChannel channel;
  private Context context;
  private SunmiPrinterService sunmiPrinterService;
  private boolean isConnected = false;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "sunmi_printer");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    
    // 初始化Sunmi打印服务
    initPrinterService();
  }

  private void initPrinterService() {
    try {
      InnerPrinterManager.getInstance().bindService(context, new InnerPrinterCallback() {
        @Override
        protected void onConnected(SunmiPrinterService service) {
          sunmiPrinterService = service;
          isConnected = true;
          Log.d(TAG, "Sunmi printer service connected");
        }

        @Override
        protected void onDisconnected() {
          isConnected = false;
          Log.d(TAG, "Sunmi printer service disconnected");
        }
      });
    } catch (InnerPrinterException e) {
      Log.e(TAG, "Error initializing printer service", e);
    }
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (!isConnected && !call.method.equals("getPlatformVersion")) {
      result.error("PRINTER_NOT_CONNECTED", "打印机服务未连接", null);
      return;
    }

    try {
      switch (call.method) {
        case "getPlatformVersion":
          result.success("Android " + android.os.Build.VERSION.RELEASE);
          break;
        case "getPrinterStatus":
          getPrinterStatus(result);
          break;
        case "initPrinter":
          initPrinter(result);
          break;
        case "printText":
          printText(call, result);
          break;
        case "printNewLine":
          printNewLine(call, result);
          break;
        case "printQRCode":
          printQRCode(call, result);
          break;
        case "printBarcode":
          printBarcode(call, result);
          break;
        case "printBitmap":
          printBitmap(call, result);
          break;
        case "setAlignment":
          setAlignment(call, result);
          break;
        case "setTextSize":
          setTextSize(call, result);
          break;
        case "setTextStyle":
          setTextStyle(call, result);
          break;
        case "cutPaper":
          cutPaper(result);
          break;
        case "openDrawer":
          openDrawer(result);
          break;
        case "getPrinterSerialNumber":
          getPrinterSerialNumber(result);
          break;
        case "getPrinterVersion":
          getPrinterVersion(result);
          break;
        case "printTable":
          printTable(call, result);
          break;
        case "printDivider":
          printDivider(call, result);
          break;
        case "feedPaper":
          feedPaper(call, result);
          break;
        default:
          result.notImplemented();
      }
    } catch (Exception e) {
      Log.e(TAG, "Error executing method: " + call.method, e);
      result.error("EXECUTION_ERROR", "执行方法时出错: " + e.getMessage(), null);
    }
  }

  private void getPrinterStatus(Result result) {
    try {
      sunmiPrinterService.updatePrinterState();
      result.success(1); // 返回状态码
    } catch (RemoteException e) {
      Log.e(TAG, "Error getting printer status", e);
      result.error("STATUS_ERROR", "获取打印机状态失败", null);
    }
  }

  private void initPrinter(Result result) {
    try {
      sunmiPrinterService.printerInit(new InnerResultCallback() {
        @Override
        public void onRunResult(boolean isSuccess) {
          result.success(isSuccess);
        }

        @Override
        public void onReturnString(String value) {
          result.success(true);
        }

        @Override
        public void onRaiseException(int code, String msg) {
          result.error("INIT_ERROR", "初始化打印机失败: " + msg, null);
        }

        @Override
        public void onPrintResult(int code, String msg) {
          if (code == 0) {
            result.success(true);
          } else {
            result.error("INIT_ERROR", "初始化打印机失败: " + msg, null);
          }
        }
      });
    } catch (RemoteException e) {
      Log.e(TAG, "Error initializing printer", e);
      result.error("INIT_ERROR", "初始化打印机失败", null);
    }
  }

  private void printText(MethodCall call, Result result) {
    try {
      String text = call.argument("text");
      Integer textSize = call.argument("textSize");
      Boolean bold = call.argument("bold");
      Boolean underline = call.argument("underline");
      Integer alignment = call.argument("alignment");

      if (text == null || TextUtils.isEmpty(text)) {
        result.error("INVALID_TEXT", "文本不能为空", null);
        return;
      }

      // 设置文本样式
      if (textSize != null) {
        sunmiPrinterService.setFontSize(textSize.floatValue(), null);
      }
      if (alignment != null) {
        sunmiPrinterService.setAlignment(alignment, null);
      }
      
      // 打印文本
      sunmiPrinterService.printText(text, null);
      
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing text", e);
      result.error("PRINT_ERROR", "打印文本失败", null);
    }
  }

  private void printNewLine(MethodCall call, Result result) {
    try {
      Integer lines = call.argument("lines");
      int lineCount = lines != null ? lines : 1;
      
      sunmiPrinterService.lineWrap(lineCount, null);
      
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing new line", e);
      result.error("PRINT_ERROR", "打印换行失败", null);
    }
  }

  private void printQRCode(MethodCall call, Result result) {
    try {
      String data = call.argument("data");
      Integer size = call.argument("size");
      Integer errorLevel = call.argument("errorLevel");
      
      if (data == null || TextUtils.isEmpty(data)) {
        result.error("INVALID_DATA", "二维码数据不能为空", null);
        return;
      }

      int qrSize = size != null ? size : 8;
      int qrErrorLevel = errorLevel != null ? errorLevel : 0;
      
      sunmiPrinterService.printQRCode(data, qrSize, qrErrorLevel, null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing QR code", e);
      result.error("PRINT_ERROR", "打印二维码失败", null);
    }
  }

  private void printBarcode(MethodCall call, Result result) {
    try {
      String data = call.argument("data");
      Integer barcodeType = call.argument("barcodeType");
      Integer height = call.argument("height");
      Integer width = call.argument("width");
      Integer textPosition = call.argument("textPosition");
      
      if (data == null || TextUtils.isEmpty(data)) {
        result.error("INVALID_DATA", "条形码数据不能为空", null);
        return;
      }

      int type = barcodeType != null ? barcodeType : 8; // CODE128
      int barcodeHeight = height != null ? height : 162;
      int barcodeWidth = width != null ? width : 2;
      int textPos = textPosition != null ? textPosition : 0;
      
      sunmiPrinterService.printBarCode(data, type, barcodeHeight, barcodeWidth, textPos, null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing barcode", e);
      result.error("PRINT_ERROR", "打印条形码失败", null);
    }
  }

  private void printBitmap(MethodCall call, Result result) {
    try {
      String imagePath = call.argument("imagePath");
      Integer width = call.argument("width");
      Integer height = call.argument("height");
      
      if (imagePath == null || TextUtils.isEmpty(imagePath)) {
        result.error("INVALID_PATH", "图片路径不能为空", null);
        return;
      }

      // 从assets加载图片
      InputStream inputStream = context.getAssets().open(imagePath);
      Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
      
      if (bitmap == null) {
        result.error("INVALID_IMAGE", "无法加载图片", null);
        return;
      }

      // 调整图片大小
      if (width != null && height != null) {
        bitmap = Bitmap.createScaledBitmap(bitmap, width, height, false);
      }

      sunmiPrinterService.printBitmap(bitmap, null);
      result.success(null);
    } catch (IOException e) {
      Log.e(TAG, "Error loading image", e);
      result.error("IMAGE_ERROR", "加载图片失败", null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing bitmap", e);
      result.error("PRINT_ERROR", "打印图片失败", null);
    }
  }

  private void setAlignment(MethodCall call, Result result) {
    try {
      Integer alignment = call.argument("alignment");
      if (alignment == null) {
        result.error("INVALID_ALIGNMENT", "对齐方式不能为空", null);
        return;
      }
      
      sunmiPrinterService.setAlignment(alignment, null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error setting alignment", e);
      result.error("ALIGNMENT_ERROR", "设置对齐方式失败", null);
    }
  }

  private void setTextSize(MethodCall call, Result result) {
    try {
      Integer size = call.argument("size");
      if (size == null) {
        result.error("INVALID_SIZE", "字体大小不能为空", null);
        return;
      }
      
      sunmiPrinterService.setFontSize(size.floatValue(), null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error setting text size", e);
      result.error("SIZE_ERROR", "设置字体大小失败", null);
    }
  }

  private void setTextStyle(MethodCall call, Result result) {
    try {
      Boolean bold = call.argument("bold");
      Boolean underline = call.argument("underline");
      
      // Sunmi打印机的文本样式设置
      // 这里可以根据需要实现更多样式
      result.success(null);
    } catch (Exception e) {
      Log.e(TAG, "Error setting text style", e);
      result.error("STYLE_ERROR", "设置文本样式失败", null);
    }
  }

  private void cutPaper(Result result) {
    try {
      sunmiPrinterService.cutPaper(null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error cutting paper", e);
      result.error("CUT_ERROR", "切纸失败", null);
    }
  }

  private void openDrawer(Result result) {
    try {
      sunmiPrinterService.openDrawer(null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error opening drawer", e);
      result.error("DRAWER_ERROR", "开启钱箱失败", null);
    }
  }

  private void getPrinterSerialNumber(Result result) {
    try {
      String serialNumber = sunmiPrinterService.getPrinterSerialNo();
      result.success(serialNumber);
    } catch (RemoteException e) {
      Log.e(TAG, "Error getting printer serial number", e);
      result.error("SERIAL_ERROR", "获取序列号失败", null);
    }
  }

  private void getPrinterVersion(Result result) {
    try {
      String version = sunmiPrinterService.getPrinterVersion();
      result.success(version);
    } catch (RemoteException e) {
      Log.e(TAG, "Error getting printer version", e);
      result.error("VERSION_ERROR", "获取版本失败", null);
    }
  }

  private void printTable(MethodCall call, Result result) {
    try {
      List<String> texts = call.argument("texts");
      List<Integer> widths = call.argument("widths");
      List<Integer> alignments = call.argument("alignments");
      
      if (texts == null || widths == null || alignments == null) {
        result.error("INVALID_TABLE", "表格参数不能为空", null);
        return;
      }

      String[] textsArray = texts.toArray(new String[0]);
      int[] widthsArray = widths.stream().mapToInt(Integer::intValue).toArray();
      int[] alignmentsArray = alignments.stream().mapToInt(Integer::intValue).toArray();
      
      sunmiPrinterService.printColumnsString(textsArray, widthsArray, alignmentsArray, null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing table", e);
      result.error("TABLE_ERROR", "打印表格失败", null);
    }
  }

  private void printDivider(MethodCall call, Result result) {
    try {
      String character = call.argument("char");
      Integer length = call.argument("length");
      
      String dividerChar = character != null ? character : "-";
      int dividerLength = length != null ? length : 32;
      
      StringBuilder divider = new StringBuilder();
      for (int i = 0; i < dividerLength; i++) {
        divider.append(dividerChar);
      }
      
      sunmiPrinterService.printText(divider.toString(), null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error printing divider", e);
      result.error("DIVIDER_ERROR", "打印分割线失败", null);
    }
  }

  private void feedPaper(MethodCall call, Result result) {
    try {
      Integer lines = call.argument("lines");
      int feedLines = lines != null ? lines : 1;
      
      sunmiPrinterService.lineWrap(feedLines, null);
      result.success(null);
    } catch (RemoteException e) {
      Log.e(TAG, "Error feeding paper", e);
      result.error("FEED_ERROR", "进纸失败", null);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    
    // 断开打印服务连接
    if (isConnected) {
      try {
        InnerPrinterManager.getInstance().unBindService(context, new InnerPrinterCallback() {
          @Override
          protected void onConnected(SunmiPrinterService service) {
            // 不需要处理
          }

          @Override
          protected void onDisconnected() {
            isConnected = false;
            Log.d(TAG, "Sunmi printer service disconnected");
          }
        });
      } catch (InnerPrinterException e) {
        Log.e(TAG, "Error disconnecting printer service", e);
      }
    }
  }
}
