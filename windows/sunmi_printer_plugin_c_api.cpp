#include "include/sunmi_printer/sunmi_printer_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "sunmi_printer_plugin.h"

void SunmiPrinterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  sunmi_printer::SunmiPrinterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
