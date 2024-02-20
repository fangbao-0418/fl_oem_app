import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:cyfl_oem_app/platform_file_editors/abs_platform_file_editor.dart';
import '../cyfl_oem_app.dart';
import '../enums.dart';

class CyflCommandRunner extends CommandRunner<void> {
  CyflCommandRunner()
      : super(
          'cy_oem',
          'A CLI tool that helps for oem in Flutter projects.',
        ) {
    argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
    );

    addCommand(RunCommand());
  }
}

abstract class PlatformFileEditorCommand extends Command {
  PlatformFileEditorCommand(
    String executableName,
    String description,
  ) {
    argParser.addMultiOption(
      CyflOemOption.targets.name,
      help: 'Set which platforms to target.',
      abbr: CyflOemOption.targets.abbr,
      allowed: [
        CyflPlatform.ios.name,
        CyflPlatform.android.name,
      ],
      defaultsTo: [
        CyflPlatform.ios.name,
        CyflPlatform.android.name,
      ],
    );
  }
}

/// [SetPlatformFileEditorCommand] is an abstract class that extends the [PlatformFileEditorCommand] class.
/// It provides a base for all set platform file editor commands.
abstract class SetPlatformFileEditorCommand extends PlatformFileEditorCommand {
  /// Constructor for [SetPlatformFileEditorCommand].
  /// It initializes the command with its name and description.
  SetPlatformFileEditorCommand(
    String executableName,
    String description,
  ) : super(
          executableName,
          description,
        ) {
    argParser.addOption(
      CyflOemOption.value.name,
      abbr: CyflOemOption.value.abbr,
      help: 'Set value of the given command',
      mandatory: true,
    );
  }
}

/// [RunCommand] is a class that extends the [SetPlatformFileEditorCommand] class.
/// It is responsible for setting the app name for the targeted platforms.
class RunCommand extends SetPlatformFileEditorCommand {
  /// Constructor for [DefaultCommand].
  /// It initializes the command with its name and description.
  RunCommand()
      : super(
          'run',
          'oem app for the targeted platforms',
        );

  @override
  String get description => 'oem app for the targeted platforms';

  @override
  String get name => 'run';

  @override
  FutureOr? run() {
    final targets = argResults?[CyflOemOption.targets.name];

    String? appId = argResults?.arguments.last;

    if (targets == null || targets.isEmpty) {
      logger.i('No targets specified.');
      return null;
    }

    if (appId == null) {
      logger.i('No appId specified.');
      return null;
    }

    CyflOemApp.replace(
      platformNames: targets,
      appId: appId,
    );
  }
}
