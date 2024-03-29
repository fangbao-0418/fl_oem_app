// import 'package:rename/commands/rename_command_runner.dart';
// import 'package:rename/custom_exceptions.dart';
// import 'package:rename/platform_file_editors/abs_platform_file_editor.dart';
import 'dart:async';
import 'dart:io';

import 'package:cyfl_oem_app/commands/cyfl_command_runner.dart';
import 'package:cyfl_oem_app/custom_exceptions.dart';
import 'package:cyfl_oem_app/platform_file_editors/abs_platform_file_editor.dart';

Future<void> main(List<String> arguments) async {
  try {
    final cyflCommandRunner = CyflCommandRunner();
    await cyflCommandRunner.run(arguments);
  } on CustomException catch (err) {
    logger.e(err.toString());
    exitCode = 1;
  } catch (e) {
    logger.e(e);
    exitCode = 64; // command line usage error
  }
}
