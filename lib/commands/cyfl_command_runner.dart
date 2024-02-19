import 'dart:async';

import 'package:args/command_runner.dart';
import '../cyfl_oem_app.dart';
import '../enums.dart';

/// [CyflCommandRunner] is responsible for running the rename command in the CLI tool.
/// It extends the CommandRunner class and overrides some of its methods.
class CyflCommandRunner extends CommandRunner<void> {
  /// Constructor for [CyflCommandRunner].
  /// It initializes the super class with the name of the command and its description.
  CyflCommandRunner()
      : super(
          'oem',
          'A CLI tool that helps for renaming in Flutter projects.',
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
          'Set app name for the targeted platforms',
        );

  @override
  String get description => 'Set app name for the targeted platforms';

  @override
  String get name => 'run';

  @override
  FutureOr? run() {
    final targets = argResults?[CyflOemOption.targets.name];
    // final value = argResults?[CyflOemOption.value.name];
    if (targets == null || targets.isEmpty) {
      print('No targets specified.');
      return null;
    }
    // if (value == null || value.isEmpty) {
    //   print('value required for $name command.');
    //   return null;
    // }

    print('Targets: $targets');
    // print('Value: $value');
    final rename = CyflOemApp.fromPlatformNames(
      platformNames: targets,
    );
    // return rename.applyWithCommandName(
    //   commandName: name,
    //   value: value,
    // );
  }
}
