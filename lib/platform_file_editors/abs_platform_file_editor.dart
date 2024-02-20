import 'dart:io';

import 'package:path/path.dart';
import 'package:logger/logger.dart';
import '../custom_exceptions.dart';
import '../enums.dart';

final Logger logger = Logger(
  filter: ProductionFilter(),
);

abstract class AbstractPlatformFileEditor {
  final CyflPlatform platform;
  AbstractPlatformFileEditor({required this.platform});

  Future<List<String?>> readFileAsLineByline({
    required String filePath,
  }) async {
    try {
      var fileAsString = await File(filePath).readAsString();
      var fileContent = fileAsString.split('\n');
      _checkFileExists(
        fileContent: fileContent,
        filePath: filePath,
      );
      return fileContent;
    } catch (e) {
      throw FileReadException(
        filePath: filePath,
        platform: platform,
        details: e.toString(),
      );
    }
  }

  /// Writes the provided [content] to a file at the specified [filePath].
  /// Parameters:
  /// - `filePath`: The path of the file to be written to.
  /// - `content`: The content to be written to the file.
  /// Returns: Future<File>, the file with the written content.
  /// Throws [FileWriteException] if there is an error writing to the file.
  Future<File> writeFile({
    required String filePath,
    required String content,
  }) async {
    try {
      return await File(filePath).writeAsString(content);
    } catch (e) {
      throw FileWriteException(
        filePath: filePath,
        platform: platform,
        details: e.toString(),
      );
    }
  }

  /// Checks if a file exists by verifying that its content is not null or empty.
  /// Parameters:
  /// - `fileContent`: The content of the file.
  /// - `filePath`: The path of the file.
  /// Returns: bool, true if the file exists, false otherwise.
  /// Throws [FileNotExistException] if the file does not exist.
  bool _checkFileExists({
    required List? fileContent,
    required String filePath,
  }) {
    if (fileContent == null || fileContent.isEmpty) {
      throw FileNotExistException(
        filePath: filePath,
        platform: platform,
        details: 'File content is null or empty',
      );
    }
    return true;
  }

  Future<Map<String, String>> getMetadata(String appId) async {
    String configFilePath = AbstractPlatformFileEditor.convertPath(
        ['oem-datum', appId, 'config.ini']);
    List<String?> content =
        await readFileAsLineByline(filePath: configFilePath);
    Map<String, String> obj = {};
    if (content.isNotEmpty) {
      for (String? e in content) {
        List<String>? rows = e?.split("=");
        if ((rows?.length ?? 0) == 2) {
          obj[rows![0]] = rows[1];
        }
      }
    }
    return obj;
  }

  /// Converts a list of path segments into a platform-specific file path.
  /// Parameters:
  /// - `paths`: A list of path segments.
  /// Returns: String, the platform-specific file path.
  static String convertPath(List<String> paths) {
    return joinAll(paths);
  }

  /// Fetches the Bundle ID of the application.
  /// Returns: Future<String?>, the Bundle ID of the application.
  Future<String?> getBundleId();

  /// Fetches the name of the application.
  /// Returns: Future<String?>, the name of the application.
  Future<String?> getAppName(String? path);

  /// Changes the Bundle ID of the application to the provided [bundleId].
  /// Parameters:
  /// - `bundleId`: The new Bundle ID to be set for the application.
  /// Returns: Future<String?>, a success message indicating the change in Bundle ID.
  Future<String?> setBundleId({required String bundleId}) async {
    var old = await getBundleId();
    return 'replace bundleId has successfuly\n$old -> $bundleId';
  }

  /// Changes the name of the application to the provided [appName].
  /// Parameters:
  /// - `appName`: The new name to be set for the application.
  /// Returns: Future<String?>, a success message indicating the change in application name.
  Future<String?> setAppName({
    required String appName,
    String? path,
  }) async {
    var old = await getAppName(path);
    return 'rename has successfuly\n$old -> $appName';
  }

  replaceFile(String appId);
}
