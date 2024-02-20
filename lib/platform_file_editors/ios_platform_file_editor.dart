import 'dart:io';

import '../enums.dart';
import 'abs_platform_file_editor.dart';

class IosPlatformFileEditor extends AbstractPlatformFileEditor {
  String iosInfoPlistPath = AbstractPlatformFileEditor.convertPath(
    ['ios', 'Runner', 'Info.plist'],
  );
  String iosProjectPbxprojPath = AbstractPlatformFileEditor.convertPath(
    ['ios', 'Runner.xcodeproj', 'project.pbxproj'],
  );

  String iosEnInfoPlistPath = AbstractPlatformFileEditor.convertPath(
    ['ios', 'Runner', 'en.lproj', 'InfoPlist.strings'],
  );

  String iosZhInfoPlistPath = AbstractPlatformFileEditor.convertPath(
    ['ios', 'Runner', 'zh-Hans.lproj', 'InfoPlist.strings'],
  );

  IosPlatformFileEditor({
    CyflPlatform platform = CyflPlatform.ios,
  }) : super(platform: platform);

  @override
  Future<String?> getAppName(String? path) async {
    final filePath = path ?? iosZhInfoPlistPath;
    var contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i]?.contains('CFBundleDisplayName') ?? false) {
        var match = RegExp(r'CFBundleDisplayName = "(.*?)";')
            .firstMatch(contentLineByLine[i]!);
        return match?.group(1)?.trim();
      }
    }
    return null;
  }

  @override
  Future<String?> getBundleId() async {
    final filePath = iosProjectPbxprojPath;
    var contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i]?.contains('PRODUCT_BUNDLE_IDENTIFIER') ??
          false) {
        return (contentLineByLine[i] as String).split('=').last.trim();
      }
    }
    return null;
  }

  @override
  Future<String?> setAppName({
    required String appName,
    String? path,
  }) async {
    final filePath = path ?? iosZhInfoPlistPath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('CFBundleDisplayName')) {
        contentLineByLine[i] = 'CFBundleDisplayName = "$appName";\r';
        break;
      }
    }

    final message = await super.setAppName(
      appName: appName,
      path: path,
    );
    await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i(message);
    return message;
  }

  @override
  Future<String?> setBundleId({required String bundleId}) async {
    final filePath = iosProjectPbxprojPath;
    List? contentLineByLine = await readFileAsLineByline(
      filePath: filePath,
    );
    for (var i = 0; i < contentLineByLine.length; i++) {
      if (contentLineByLine[i].contains('PRODUCT_BUNDLE_IDENTIFIER')) {
        contentLineByLine[i] = '				PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      }
    }
    final message = await super.setBundleId(bundleId: bundleId);
    await writeFile(
      filePath: filePath,
      content: contentLineByLine.join('\n'),
    );
    logger.i(message);
    return message;
  }

  replaceLogo(String appId) {
    Map mapObj = {
      "20": "20x20",
      "29 1": "29x29",
      "29": "29x29",
      "40 1": "40x40",
      "40 2": "80x80",
      "40": "40x40",
      "58 1": "58x58",
      "58": "58x58",
      "60": "60x60",
      "76": "76x76",
      "80 1": "80x80",
      "80": "80x80",
      "87": "87x87",
      "120 1": "120x120",
      "120": "120x120",
      "152": "152x152",
      "167": "167x167",
      "180": "180x180",
      "1024": "1024x1024",
    };

    mapObj.forEach((key, value) async {
      String path = AbstractPlatformFileEditor.convertPath(
          ['oem-datum', appId, 'logo', value + '.png']);
      String distPath = AbstractPlatformFileEditor.convertPath([
        'ios',
        'Runner',
        'Assets.xcassets',
        "AppIcon.appiconset",
        key + ".png",
      ]);
      await File(path).copy(distPath);
    });
    logger.i("replace logo has successfully");
  }

  @override
  replaceFile(String appId) async {
    logger.i("start replacing for ${platform.name} ");
    Map<String, String> obj = await getMetadata(appId);

    if (obj["APP_ID"] != null) {
      String appId = obj["APP_ID"]!;
      if (obj["APP_NAME_CN"] != null) {
        await setAppName(
          appName: obj["APP_NAME_CN"]!,
          path: iosZhInfoPlistPath,
        );
      }

      if (obj["APP_NAME_EN"] != null) {
        await setAppName(
          appName: obj["APP_NAME_EN"]!,
          path: iosEnInfoPlistPath,
        );
      }

      await setBundleId(bundleId: obj["APP_ID"]!);
      await replaceLogo(appId);
    }
  }
}
