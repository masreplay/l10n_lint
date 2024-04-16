import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

import '../l10n_yaml/l10n_paths.dart';

printVersionCommand() async {
  final pubspecFile = File(pubspecYamlPath);

  if (pubspecFile.existsSync()) {
    final pubspec = Pubspec.parse(await pubspecFile.readAsString());
    print(pubspec.version);
  } else {
    print('pubspec.yaml not found');
  }
}
