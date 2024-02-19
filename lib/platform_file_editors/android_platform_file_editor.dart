import '../enums.dart';
import 'abs_platform_file_editor.dart';

class AndroidPlatformFileEditor extends AbstractPlatformFileEditor {
  final String androidManifestPath = AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'main', 'AndroidManifest.xml'],
  );

  final String androidAppBuildGradlePath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'build.gradle'],
  );

  AndroidPlatformFileEditor({
    CyflPlatform platform = CyflPlatform.android,
  }) : super(platform: platform);

  /// Fetches the bundle ID from the Android App Build Gradle file.
  /// Returns: Future<String?>, the Bundle ID of the application.
  @override
  Future<String?> getBundleId() async {
    final filePath = androidAppBuildGradlePath;
    var contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i]?.contains('applicationId') ?? false) {
        return (contentLineByLine[i] as String).split('"')[1].trim();
      }
    }
    return null;
  }

  /// Changes the app name in the Android Manifest file to the provided [appName].
  /// Parameters:
  /// - `appName`: The new name to be set for the application.
  /// Returns: Future<String?>, a success message indicating the change in application name.
  @override
  Future<String?> setAppName({required String appName}) async {
    final filePath = androidManifestPath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('android:label=')) {
        contentLineByLine[i] = contentLineByLine[i].toString().replaceFirst(
            RegExp(r'android:label="(.*?)"'), 'android:label="$appName"');
        break;
      }
    }
    final message = await super.setAppName(appName: appName);
    var writtenFile = await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    return message;
  }

  @override
  Future<String?> getAppName() async {
    final filePath = androidManifestPath;
    var contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i]?.contains('android:label=') ?? false) {
        return (contentLineByLine[i] as String).split('"')[1].trim();
      }
    }
    return null;
  }

  /// Changes the Bundle ID in the Android App Build Gradle file to the provided [bundleId].
  /// Parameters:
  /// - `bundleId`: The new Bundle ID to be set for the application.
  /// Returns: Future<String?>, a success message indicating the change in Bundle ID.
  @override
  Future<String?> setBundleId({required String bundleId}) async {
    final filePath = androidAppBuildGradlePath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        contentLineByLine[i] = '        applicationId \"$bundleId\"';
        break;
      }
    }
    final message = await super.setBundleId(bundleId: bundleId);
    var writtenFile = await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    return message;
  }
}
