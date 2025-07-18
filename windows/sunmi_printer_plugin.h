#ifndef FLUTTER_PLUGIN_SUNMI_PRINTER_PLUGIN_H_
#define FLUTTER_PLUGIN_SUNMI_PRINTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace sunmi_printer {

class SunmiPrinterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SunmiPrinterPlugin();

  virtual ~SunmiPrinterPlugin();

  // Disallow copy and assign.
  SunmiPrinterPlugin(const SunmiPrinterPlugin&) = delete;
  SunmiPrinterPlugin& operator=(const SunmiPrinterPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace sunmi_printer

#endif  // FLUTTER_PLUGIN_SUNMI_PRINTER_PLUGIN_H_
