library cyfl_oem_app;

import 'enums.dart';
import 'platform_file_editors/android_platform_file_editor.dart';

/// A Calculator.
class CyflOemApp {
  /// Creates a new instance of [Rename].
  ///
  /// Parameters:
  /// - `platformFileEditors`: Map of platforms to their respective file editors.
  CyflOemApp();

  /// Creates a new instance of [Rename] from a list of targets.
  ///
  /// Parameters:
  /// - `targets`: List of platforms to generate file editors for.
  factory CyflOemApp.fromPlatformNames({required List<String> platformNames}) {
    // var platformFileEditors = _generatePlatformFileEditors(targets: targets);
    var targets = platformNames.map((name) {
      return CyflPlatform.values.firstWhere(
        (e) => e.name == name,
        orElse: () => throw ArgumentError('Invalid platform name: $name'),
      );
    }).toList();
    // var platformFileEditors = _generatePlatformFileEditors(targets: targets);
    // return Rename(platformFileEditors: platformFileEditors);

    for (var target in targets) {
      switch (target) {
        case CyflPlatform.android:
          AndroidPlatformFileEditor editor = AndroidPlatformFileEditor();
          editor.setAppName(appName: "");
          break;
        case CyflPlatform.ios:
          // editors[target] = IosPlatformFileEditor();
          break;
      }
    }

    return CyflOemApp(
        // platformFileEditors: platformFileEditors
        );
  }
}
