enum CyflPlatform {
  android,
  ios,
}

enum CyflOemOption {
  targets,
  value,
}

/// [CyflCommand] is an enum representing different commands for renaming.
enum CyflCommand {
  help,
}

/// Extension on [CyflOemOption] to provide additional functionalities.
extension CyflOemOptionExtension on CyflOemOption {
  /// Returns the name of the rename option.
  String get name {
    switch (this) {
      case CyflOemOption.targets:
        return 'targets';
      case CyflOemOption.value:
        return 'value';
      default:
        return '';
    }
  }

  /// Returns the abbreviation of the rename option.
  String get abbr {
    switch (this) {
      case CyflOemOption.targets:
        return 't';
      case CyflOemOption.value:
        return 'v';
      default:
        return '';
    }
  }
}
