import 'dart:io';

import '../enums.dart';
import 'abs_platform_file_editor.dart';

class AndroidPlatformFileEditor extends AbstractPlatformFileEditor {
  final String androidManifestPath = AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'main', 'AndroidManifest.xml'],
  );

  final String pubspecPath = AbstractPlatformFileEditor.convertPath(
    ['pubspec.yaml'],
  );

  final String androidDebugManifestPath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'debug', 'AndroidManifest.xml'],
  );

  final String androidProfileManifestPath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'profile', 'AndroidManifest.xml'],
  );

  final String androidValuesStringsPath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'main', 'res', 'values', 'strings.xml'],
  );

  final String androidValuesEnStringsPath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'src', 'main', 'res', 'values-en', 'strings.xml'],
  );

  final String androidMainActivityPath = AbstractPlatformFileEditor.convertPath(
    [
      'android',
      'app',
      'src',
      'main',
      'kotlin',
      'com',
      'example',
      'app',
      'MainActivity.kt'
    ],
  );

  final String androidAppBuildGradlePath =
      AbstractPlatformFileEditor.convertPath(
    ['android', 'app', 'build.gradle'],
  );

  AndroidPlatformFileEditor({
    CyflPlatform platform = CyflPlatform.android,
  }) : super(platform: platform);

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

  @override
  Future<String?> setAppName({
    required String appName,
    String? path,
  }) async {
    final filePath = path ?? androidValuesStringsPath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('app_name')) {
        contentLineByLine[i] = contentLineByLine[i].toString().replaceFirst(
            RegExp(r'app_name">(.*?)</string>'), 'app_name">$appName</string>');
        break;
      }
    }
    final message = await super.setAppName(appName: appName, path: filePath);
    await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i(message);
    return message;
  }

  @override
  Future<String?> getAppName(String? path) async {
    final filePath = path ?? androidValuesStringsPath;
    var contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i]!.contains('app_name')) {
        return RegExp(r'app_name">(.*?)</string>')
                .firstMatch(contentLineByLine[i] as String)
                ?.group(1) ??
            "";
      }
    }
    return null;
  }

  @override
  Future<String?> setBundleId({required String bundleId}) async {
    String? oldBuildId = await getBundleId();

    final filePath = androidAppBuildGradlePath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('applicationId')) {
        contentLineByLine[i] = '        applicationId "$bundleId"';
        break;
      }
    }
    final message = await super.setBundleId(bundleId: bundleId);

    await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );

    List? mainActivityContentLineByLine = await readFileAsLineByline(
      filePath: androidMainActivityPath,
    );
    for (var i = 0; i < mainActivityContentLineByLine.length; i++) {
      if (oldBuildId != null &&
          mainActivityContentLineByLine[i].contains("package $oldBuildId")) {
        mainActivityContentLineByLine[i] = 'package $bundleId';
        break;
      }
    }
    await writeFile(
      filePath: androidMainActivityPath,
      content: mainActivityContentLineByLine.join('\n'),
    );

    await writeManifestBundleId(androidManifestPath, bundleId);
    await writeManifestBundleId(androidDebugManifestPath, bundleId);
    await writeManifestBundleId(androidProfileManifestPath, bundleId);

    logger.i(message);
    return message;
  }

  Future<void> writeManifestBundleId(String filePath, String bundleId) async {
    List? androidManifestContentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < androidManifestContentLineByLine.length; i++) {
      if (androidManifestContentLineByLine[i].contains('package="')) {
        androidManifestContentLineByLine[i] =
            androidManifestContentLineByLine[i].toString().replaceFirst(
                RegExp(r'package="(.*?)">'), 'package="$bundleId">');
        break;
      }
    }
    await writeFile(
      filePath: filePath,
      content: androidManifestContentLineByLine.join('\n'),
    );
  }

  Future<String?> setSingature({
    required String appId,
    String? keyAlias,
    String? keyPassword,
    String? storePassword,
  }) async {
    final filePath = androidAppBuildGradlePath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );

    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('keyAlias')) {
        // contentLineByLine[i] = "keyAlias '$keyAlias'";
        contentLineByLine[i] = contentLineByLine[i]
            .toString()
            .replaceFirst(RegExp(r"keyAlias '(.*?)'"), "keyAlias '$keyAlias'");
      }

      if (contentLineByLine[i].contains('keyPassword')) {
        contentLineByLine[i] = contentLineByLine[i].toString().replaceFirst(
            RegExp(r"keyPassword '(.*?)'"), "keyPassword '$keyPassword'");
      }

      if (contentLineByLine[i].contains('storePassword')) {
        contentLineByLine[i] = contentLineByLine[i].toString().replaceFirst(
            RegExp(r"storePassword '(.*?)'"), "storePassword '$storePassword'");
      }

      if (contentLineByLine[i].contains('storeFile')) {
        contentLineByLine[i] = contentLineByLine[i].toString().replaceFirst(
            RegExp(r"storeFile file\((.*?)\)"),
            "storeFile file('../../oem-datum/$appId/signature/upload-keystore.jks')");
      }
    }

    await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i("succeeded in replacing signature");
    return "";
  }

  replaceAppMainAndroidMainfest(String key) async {
    List? androidManifestContentLineByLine = await readFileAsLineByline(
      filePath: androidManifestPath,
    );
    for (var i = 0; i < androidManifestContentLineByLine.length; i++) {
      if (androidManifestContentLineByLine[i]
          .contains('com.google.android.geo.API_KEY')) {
        androidManifestContentLineByLine[i + 1] =
            androidManifestContentLineByLine[i + 1].toString().replaceFirst(
                RegExp(r'android:value="(.*?)"'), 'android:value="$key"');
        break;
      }
    }
    await writeFile(
      filePath: androidManifestPath,
      content: androidManifestContentLineByLine.join('\n'),
    );
    logger.i("replace google map has successfully");
  }

  replaceLogo(String appId) {
    Map mapObj = {
      "mipmap-hdpi": "72x72",
      "mipmap-mdpi": "48x48",
      "mipmap-xhdpi": "96x96",
      "mipmap-xxhdpi": "144x144",
      "mipmap-xxxhdpi": "192x192"
    };

    mapObj.forEach((key, value) async {
      String path = AbstractPlatformFileEditor.convertPath(
          ['oem-datum', appId, 'logo', value + '.png']);
      String distPath = AbstractPlatformFileEditor.convertPath([
        'android',
        'app',
        'src',
        "main",
        "res",
        key,
        "ic_launcher.png",
      ]);
      await File(path).copy(distPath);
    });
    logger.i("replace logo has successfully");
  }

  replaceLaunchImage(String appId) async {
    String path = AbstractPlatformFileEditor.convertPath(
        ['oem-datum', appId, 'launch_image.png']);
    String distPath = AbstractPlatformFileEditor.convertPath([
      'assets',
      'images',
      'boot_page',
      "launch_image.png",
    ]);
    await File(path).copy(distPath);
    logger.i("replace launch image has successfully");
  }

  replaceVersion(String version) async {
    List? pubspecContentLineByLine = await readFileAsLineByline(
      filePath: pubspecPath,
    );
    for (var i = 0; i < pubspecContentLineByLine.length; i++) {
      if (pubspecContentLineByLine[i].contains('version: ')) {
        pubspecContentLineByLine[i] = "version: $version";

        break;
      }
    }
    await writeFile(
      filePath: pubspecPath,
      content: pubspecContentLineByLine.join('\n'),
    );
    logger.i("replace version has successfully");
  }

  @override
  replaceFile(String appId) async {
    logger.i("start replacing for ${platform.name} ");
    Map<String, String> obj = await getMetadata(appId);

    if (obj["APP_ID"] != null) {
      String appId = obj["APP_ID"]!;
      if (obj["APP_NAME_CN"] != null) {
        await setAppName(
            appName: obj["APP_NAME_CN"]!, path: androidValuesStringsPath);
      }

      if (obj["APP_NAME_EN"] != null) {
        await setAppName(
            appName: obj["APP_NAME_EN"]!, path: androidValuesEnStringsPath);
      }

      await setBundleId(bundleId: obj["APP_ID"]!);
      await replaceVersion(obj["APP_VERSION"]!);
      await replaceAppMainAndroidMainfest(obj["GOOGLE_GEO_API_KEY"]!);
      await replaceLogo(appId);
      await setSingature(
        appId: appId,
        keyAlias: obj["KEY_ALIAS"],
        keyPassword: obj["KEY_PASSWORD"],
        storePassword: obj["STORE_PASSWORD"],
      );
      await replaceLaunchImage(appId);
    }
  }
}
