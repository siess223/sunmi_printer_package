package com.shwethe.sunmi_printer.sunmi_printer;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

// 传统商米打印机 SDK 导入
import com.sunmi.peripheral.printer.InnerPrinterCallback;
import com.sunmi.peripheral.printer.InnerPrinterException;
import com.sunmi.peripheral.printer.InnerPrinterManager;
import com.sunmi.peripheral.printer.InnerResultCallback;
import com.sunmi.peripheral.printer.SunmiPrinterService;
import com.sunmi.peripheral.printer.WoyouConsts;

// LCD 客显功能 - 使用传统打印机服务的 LCD API
import com.sunmi.peripheral.printer.InnerLcdCallback;

import java.util.ArrayList;
import java.util.List;

public class SunmiPrinterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
    private static final String TAG = "SunmiPrinterPlugin";
    private static final String CHANNEL = "sunmi_printer";

    private MethodChannel channel;
    private Context context;
    private Activity activity;
    
    // 传统 SDK 对象
    private SunmiPrinterService sunmiPrinterService;
    private boolean isServiceConnected = false;
    
    // LCD 客显功能状态
    private boolean isLcdConnected = false;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        
        // 初始化双屏通信 SDK
        initLcdService();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "bindService":
                bindService(result);
                break;
            case "unBindService":
                unBindService(result);
                break;
            case "printText":
                printText(call, result);
                break;
            case "printImage":
                printImage(call, result);
                break;
            case "printQRCode":
                printQRCode(call, result);
                break;
            case "printBarcode":
                printBarcode(call, result);
                break;
            case "printTable":
                printTable(call, result);
                break;
            case "printReceipt":
                printReceipt(call, result);
                break;
            case "cutPaper":
                cutPaper(result);
                break;
            case "openDrawer":
                openDrawer(result);
                break;
            case "feedPaper":
                feedPaper(call, result);
                break;
            case "getPrinterStatus":
                getPrinterStatus(result);
                break;
            case "getPrinterInfo":
                getPrinterInfo(result);
                break;
            case "isPrinterConnected":
                isPrinterConnected(result);
                break;
            case "enterPrinterBuffer":
                enterPrinterBuffer(call, result);
                break;
            case "exitPrinterBuffer":
                exitPrinterBuffer(call, result);
                break;
            case "clearPrinterBuffer":
                clearPrinterBuffer(result);
                break;
            // LCD 客显功能
            case "lcdDisplayText":
                lcdDisplayText(call, result);
                break;
            case "lcdDisplayTexts":
                lcdDisplayTexts(call, result);
                break;
            case "lcdDisplayBitmap":
                lcdDisplayBitmap(call, result);
                break;
            case "lcdDisplayDigital":
                lcdDisplayDigital(call, result);
                break;
            case "lcdClear":
                lcdClear(result);
                break;
            case "lcdInit":
                lcdInit(result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void bindService(Result result) {
        try {
            InnerPrinterManager.getInstance().bindService(context, new InnerPrinterCallback() {
                @Override
                protected void onConnected(SunmiPrinterService service) {
                    sunmiPrinterService = service;
                    isServiceConnected = true;
                    Log.d(TAG, "商米打印机服务连接成功");
                    result.success(true);
                }

                @Override
                protected void onDisconnected() {
                    sunmiPrinterService = null;
                    isServiceConnected = false;
                    Log.d(TAG, "商米打印机服务断开连接");
                }
            });
        } catch (InnerPrinterException e) {
            Log.e(TAG, "绑定商米打印机服务失败: " + e.getMessage(), e);
            result.error("ERROR", "绑定打印机服务失败: " + e.getMessage(), null);
        }
    }

    private void unBindService(Result result) {
        try {
            if (isServiceConnected) {
                InnerPrinterManager.getInstance().unBindService(context, new InnerPrinterCallback() {
                    @Override
                    protected void onConnected(SunmiPrinterService service) {
                        // 不需要处理
                    }

                    @Override
                    protected void onDisconnected() {
                        sunmiPrinterService = null;
                        isServiceConnected = false;
                        Log.d(TAG, "商米打印机服务解绑成功");
                    }
                });
            }
            result.success(true);
        } catch (InnerPrinterException e) {
            Log.e(TAG, "解绑商米打印机服务失败: " + e.getMessage(), e);
            result.error("ERROR", "解绑打印机服务失败: " + e.getMessage(), null);
        }
    }

    private void printText(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            String text = call.argument("text");
            if (text == null) text = "";
            
            // 设置对齐方式
            String alignment = call.argument("alignment");
            if (alignment != null) {
                switch (alignment.toLowerCase()) {
                    case "center":
                        sunmiPrinterService.setAlignment(1, null);
                        break;
                    case "right":
                        sunmiPrinterService.setAlignment(2, null);
                        break;
                    default:
                        sunmiPrinterService.setAlignment(0, null);
                        break;
                }
            }
            
            // 设置字体大小
            Boolean isBold = call.argument("isBold");
            if (isBold != null && isBold) {
                sunmiPrinterService.sendRAWData(new byte[]{0x1B, 0x45, 0x01}, null);
            }
            
            String fontSize = call.argument("fontSize");
            if (fontSize != null) {
                switch (fontSize.toLowerCase()) {
                    case "large":
                        sunmiPrinterService.setFontSize(48, null);
                        break;
                    case "medium":
                        sunmiPrinterService.setFontSize(32, null);
                        break;
                    default:
                        sunmiPrinterService.setFontSize(24, null);
                        break;
                }
            }

            sunmiPrinterService.printText(text, null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "打印文本失败: " + e.getMessage(), e);
            result.error("ERROR", "打印文本失败: " + e.getMessage(), null);
        }
    }

    private void printImage(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            byte[] imageData = call.argument("imageData");
            if (imageData == null) {
                result.error("ERROR", "图片数据为空", null);
                return;
            }

            Bitmap bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
            if (bitmap == null) {
                result.error("ERROR", "无法解析图片数据", null);
                return;
            }

            String alignment = call.argument("alignment");
            if (alignment != null) {
                switch (alignment.toLowerCase()) {
                    case "center":
                        sunmiPrinterService.setAlignment(1, null);
                        break;
                    case "right":
                        sunmiPrinterService.setAlignment(2, null);
                        break;
                    default:
                        sunmiPrinterService.setAlignment(0, null);
                        break;
                }
            }

            sunmiPrinterService.printBitmap(bitmap, null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "打印图片失败: " + e.getMessage(), e);
            result.error("ERROR", "打印图片失败: " + e.getMessage(), null);
        }
    }

    private void printQRCode(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            String text = call.argument("text");
            if (text == null) text = "";
            
            Integer size = call.argument("size");
            if (size == null) size = 5;
            
            Integer errorLevel = call.argument("errorLevel");
            if (errorLevel == null) errorLevel = 0;

            String alignment = call.argument("alignment");
            if (alignment != null) {
                switch (alignment.toLowerCase()) {
                    case "center":
                        sunmiPrinterService.setAlignment(1, null);
                        break;
                    case "right":
                        sunmiPrinterService.setAlignment(2, null);
                        break;
                    default:
                        sunmiPrinterService.setAlignment(0, null);
                        break;
                }
            }

            sunmiPrinterService.printQRCode(text, size, errorLevel, null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "打印二维码失败: " + e.getMessage(), e);
            result.error("ERROR", "打印二维码失败: " + e.getMessage(), null);
        }
    }

    private void printBarcode(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            String text = call.argument("text");
            if (text == null) text = "";
            
            Integer symbology = call.argument("symbology");
            if (symbology == null) symbology = 8; // CODE128
            
            Integer width = call.argument("width");
            if (width == null) width = 2;
            
            Integer height = call.argument("height");
            if (height == null) height = 162;
            
            Integer textPosition = call.argument("textPosition");
            if (textPosition == null) textPosition = 0;

            String alignment = call.argument("alignment");
            if (alignment != null) {
                switch (alignment.toLowerCase()) {
                    case "center":
                        sunmiPrinterService.setAlignment(1, null);
                        break;
                    case "right":
                        sunmiPrinterService.setAlignment(2, null);
                        break;
                    default:
                        sunmiPrinterService.setAlignment(0, null);
                        break;
                }
            }

            sunmiPrinterService.printBarCode(text, symbology, height, width, textPosition, null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "打印条码失败: " + e.getMessage(), e);
            result.error("ERROR", "打印条码失败: " + e.getMessage(), null);
        }
    }

    private void printTable(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> tableData = call.argument("tableData");
            @SuppressWarnings("unchecked")
            List<Integer> columnWidths = call.argument("columnWidths");
            
            if (tableData == null || tableData.isEmpty()) {
                result.error("ERROR", "表格数据不能为空", null);
                return;
            }

            // 处理表格数据
            for (Map<String, Object> row : tableData) {
                @SuppressWarnings("unchecked")
                List<String> columns = (List<String>) row.get("columns");
                if (columns != null && !columns.isEmpty()) {
                    // 设置默认列宽和对齐方式
                    String[] textsArr = columns.toArray(new String[0]);
                    int[] widthsArr;
                    int[] alignsArr = new int[columns.size()];
                    
                    if (columnWidths != null && columnWidths.size() == columns.size()) {
                        widthsArr = columnWidths.stream().mapToInt(Integer::intValue).toArray();
                    } else {
                        // 默认等宽
                        widthsArr = new int[columns.size()];
                        for (int i = 0; i < columns.size(); i++) {
                            widthsArr[i] = 10; // 默认宽度
                        }
                    }
                    
                    // 默认左对齐
                    for (int i = 0; i < columns.size(); i++) {
                        alignsArr[i] = 0; // 0=左对齐, 1=居中, 2=右对齐
                    }
                    
                    sunmiPrinterService.printColumnsText(textsArr, widthsArr, alignsArr, null);
                }
            }
            
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "打印表格失败: " + e.getMessage(), e);
            result.error("ERROR", "打印表格失败: " + e.getMessage(), null);
        }
    }

    private void printReceipt(MethodCall call, Result result) {
        // 这个方法暂时不实现，因为需要具体的小票格式
        result.success(true);
    }

    private void cutPaper(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            sunmiPrinterService.cutPaper(null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "切纸失败: " + e.getMessage(), e);
            result.error("ERROR", "切纸失败: " + e.getMessage(), null);
        }
    }

    private void openDrawer(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            sunmiPrinterService.openDrawer(null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "开钱箱失败: " + e.getMessage(), e);
            result.error("ERROR", "开钱箱失败: " + e.getMessage(), null);
        }
    }

    private void feedPaper(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Integer lines = call.argument("lines");
            if (lines == null) lines = 1;
            
            sunmiPrinterService.lineWrap(lines, null);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "走纸失败: " + e.getMessage(), e);
            result.error("ERROR", "走纸失败: " + e.getMessage(), null);
        }
    }

    private void getPrinterStatus(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            sunmiPrinterService.updatePrinterState();
            Map<String, Object> status = new HashMap<>();
            status.put("status", 1); // 1=正常, 0=异常
            status.put("message", "打印机状态正常");
            result.success(status);
        } catch (Exception e) {
            Log.e(TAG, "获取打印机状态失败: " + e.getMessage(), e);
            result.error("ERROR", "获取打印机状态失败: " + e.getMessage(), null);
        }
    }

    private void getPrinterInfo(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Map<String, Object> info = new HashMap<>();
            info.put("printerModel", "Sunmi Printer");
            info.put("printerVersion", "1.0.0");
            info.put("paperSize", "80mm");
            result.success(info);
        } catch (Exception e) {
            Log.e(TAG, "获取打印机信息失败: " + e.getMessage(), e);
            result.error("ERROR", "获取打印机信息失败: " + e.getMessage(), null);
        }
    }

    private void isPrinterConnected(Result result) {
        result.success(isServiceConnected);
    }

    private void enterPrinterBuffer(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Boolean clear = call.argument("clear");
            if (clear != null && clear) {
                sunmiPrinterService.enterPrinterBuffer(true);
            } else {
                sunmiPrinterService.enterPrinterBuffer(false);
            }
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "进入打印缓冲区失败: " + e.getMessage(), e);
            result.error("ERROR", "进入打印缓冲区失败: " + e.getMessage(), null);
        }
    }

    private void exitPrinterBuffer(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Boolean commit = call.argument("commit");
            if (commit != null && commit) {
                sunmiPrinterService.exitPrinterBufferWithCallback(true, new InnerResultCallback() {
                    private boolean resultCalled = false;
                    
                    @Override
                    public void onRunResult(boolean isSuccess) {
                        if (!resultCalled) {
                            resultCalled = true;
                            if (isSuccess) {
                                result.success(true);
                            } else {
                                result.error("ERROR", "提交打印缓冲区失败", null);
                            }
                        }
                    }

                    @Override
                    public void onReturnString(String s) {
                        // 不需要处理
                    }

                    @Override
                    public void onRaiseException(int i, String s) {
                        if (!resultCalled) {
                            resultCalled = true;
                            result.error("ERROR", "提交打印缓冲区异常: " + s, null);
                        }
                    }

                    @Override
                    public void onPrintResult(int code, String msg) {
                        if (!resultCalled) {
                            resultCalled = true;
                            // 处理打印结果
                            if (code == 0) {
                                result.success(true);
                            } else {
                                result.error("ERROR", "打印失败: " + msg, null);
                            }
                        }
                    }
                });
            } else {
                sunmiPrinterService.exitPrinterBuffer(false);
                result.success(true);
            }
        } catch (Exception e) {
            Log.e(TAG, "退出打印缓冲区失败: " + e.getMessage(), e);
            result.error("ERROR", "退出打印缓冲区失败: " + e.getMessage(), null);
        }
    }

    private void clearPrinterBuffer(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            sunmiPrinterService.clearBuffer();
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "清除打印缓冲区失败: " + e.getMessage(), e);
            result.error("ERROR", "清除打印缓冲区失败: " + e.getMessage(), null);
        }
    }

    // LCD 客显功能 - 使用传统打印机服务的 LCD API
    private void initLcdService() {
        try {
            Log.d(TAG, "LCD 服务初始化中...");
            // LCD 功能通过 SunmiPrinterService 提供，无需单独初始化
            // 只需要检查打印机服务是否可用
            isLcdConnected = isServiceConnected;
            Log.d(TAG, "LCD 服务初始化完成，状态: " + isLcdConnected);
        } catch (Exception e) {
            Log.e(TAG, "LCD 服务初始化失败: " + e.getMessage(), e);
            isLcdConnected = false;
        }
    }

    private void lcdDisplayText(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            String text = call.argument("text");
            if (text == null) text = "";
            
            Integer size = call.argument("size");
            if (size == null) size = 16; // 默认字体大小
            
            Boolean bold = call.argument("bold");
            if (bold == null) bold = false; // 默认不加粗
            
            Log.d(TAG, "LCD 显示文本: " + text + ", 大小: " + size + ", 加粗: " + bold);
            
            // 使用官方 LCD API 显示文本
            sunmiPrinterService.sendLCDFillString(text, size, bold, new InnerLcdCallback() {
                @Override
                public void onRunResult(boolean show) throws android.os.RemoteException {
                    Log.d(TAG, "LCD 显示文本结果: " + show);
                    result.success(show);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "LCD 显示文本异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 显示文本异常: " + e.getMessage(), null);
        }
    }

    private void lcdDisplayTexts(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            @SuppressWarnings("unchecked")
            List<String> texts = call.argument("texts");
            @SuppressWarnings("unchecked")
            List<Integer> sizes = call.argument("sizes");
            
            if (texts == null || texts.isEmpty()) {
                result.error("ERROR", "文本列表不能为空", null);
                return;
            }
            
            Log.d(TAG, "LCD 显示文本列表: " + texts.toString());
            
            // 转换为数组格式，最多支持3行文本（根据官方示例）
            String[] textArray = new String[3];
            int[] alignArray = new int[3];
            
            for (int i = 0; i < 3; i++) {
                if (i < texts.size()) {
                    textArray[i] = texts.get(i);
                    alignArray[i] = 0; // 0=左对齐, 1=居中, 2=右对齐
                } else {
                    textArray[i] = null; // 空行
                    alignArray[i] = 1;
                }
            }
            
            // 使用官方 LCD API 显示多行文本
            sunmiPrinterService.sendLCDMultiString(textArray, alignArray, new InnerLcdCallback() {
                @Override
                public void onRunResult(boolean show) throws android.os.RemoteException {
                    Log.d(TAG, "LCD 显示文本列表结果: " + show);
                    result.success(show);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "LCD 显示文本列表异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 显示文本列表异常: " + e.getMessage(), null);
        }
    }

    private void lcdDisplayBitmap(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            byte[] imageData = call.argument("image");
            if (imageData == null || imageData.length == 0) {
                result.error("ERROR", "图片数据不能为空", null);
                return;
            }
            
            Log.d(TAG, "LCD 显示图片，数据大小: " + imageData.length);
            
            // 将字节数组转换为 Bitmap
            Bitmap bitmap = BitmapFactory.decodeByteArray(imageData, 0, imageData.length);
            if (bitmap == null) {
                result.error("ERROR", "无法解析图片数据", null);
                return;
            }
            
            // 使用官方 LCD API 显示图片
            sunmiPrinterService.sendLCDBitmap(bitmap, new InnerLcdCallback() {
                @Override
                public void onRunResult(boolean show) throws android.os.RemoteException {
                    Log.d(TAG, "LCD 显示图片结果: " + show);
                    result.success(show);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "LCD 显示图片异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 显示图片异常: " + e.getMessage(), null);
        }
    }

    private void lcdDisplayDigital(MethodCall call, Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            String digital = call.argument("digital");
            if (digital == null) {
                String price = call.argument("price");
                String currency = call.argument("currency");
                if (price == null) price = "0.00";
                if (currency == null) currency = "¥";
                digital = currency + price;
            }
            
            Log.d(TAG, "LCD 显示数字: " + digital);
            
            // 使用官方 LCD API 显示数字，字体稍大一些
            sunmiPrinterService.sendLCDFillString(digital, 24, true, new InnerLcdCallback() {
                @Override
                public void onRunResult(boolean show) throws android.os.RemoteException {
                    Log.d(TAG, "LCD 显示数字结果: " + show);
                    result.success(show);
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "LCD 显示数字异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 显示数字异常: " + e.getMessage(), null);
        }
    }

    private void lcdClear(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Log.d(TAG, "LCD 清屏");
            
            // 使用官方 LCD API 清除屏幕内容
            // 4 — 清除屏幕内容
            sunmiPrinterService.sendLCDCommand(4);
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "LCD 清屏异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 清屏异常: " + e.getMessage(), null);
        }
    }

    private void lcdInit(Result result) {
        if (!checkPrinterAvailable(result)) return;

        try {
            Log.d(TAG, "LCD 初始化");
            
            // 使用官方 LCD API 初始化 LCD
            // 1 — 初始化
            sunmiPrinterService.sendLCDCommand(1);
            
            // 点亮屏幕
            // 2 — 点亮屏幕
            sunmiPrinterService.sendLCDCommand(2);
            
            // 更新 LCD 连接状态
            initLcdService();
            result.success(true);
        } catch (Exception e) {
            Log.e(TAG, "LCD 初始化异常: " + e.getMessage(), e);
            result.error("ERROR", "LCD 初始化异常: " + e.getMessage(), null);
        }
    }

    private boolean checkLcdAvailable(Result result) {
        if (!isServiceConnected || sunmiPrinterService == null) {
            result.error("ERROR", "打印机服务未连接，LCD 功能不可用", null);
            return false;
        }
        return true;
    }

    private boolean checkPrinterAvailable(Result result) {
        if (!isServiceConnected || sunmiPrinterService == null) {
            result.error("ERROR", "打印机服务未连接", null);
            return false;
        }
        return true;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }
}
