//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <sunmi_printer/sunmi_printer_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) sunmi_printer_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "SunmiPrinterPlugin");
  sunmi_printer_plugin_register_with_registrar(sunmi_printer_registrar);
}
