library cyfl_oem_app;

import 'enums.dart';

import 'platform_file_editors/android_platform_file_editor.dart';
import 'platform_file_editors/ios_platform_file_editor.dart';

class CyflOemApp {
  CyflOemApp();

  static replace({
    required List<String> platformNames,
    required String appId,
  }) async {
    var targets = platformNames.map((name) {
      return CyflPlatform.values.firstWhere(
        (e) => e.name == name,
        orElse: () => throw ArgumentError('Invalid platform name: $name'),
      );
    }).toList();

    for (var target in targets) {
      switch (target) {
        case CyflPlatform.android:
          AndroidPlatformFileEditor editor = AndroidPlatformFileEditor();
          await editor.replaceFile(appId);
          break;
        case CyflPlatform.ios:
          IosPlatformFileEditor editor = IosPlatformFileEditor();
          await editor.replaceFile(appId);
          break;
      }
    }
  }
}
