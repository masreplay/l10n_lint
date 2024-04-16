import 'dart:io';

import '../l10n_paths.dart';
import '../l10n_template.dart';
import '../pubspec_l10n_config.dart';

Future<void> configureL10n(L10nConfig config) async {
  if (!config.isFlutterProject) {
    print("This is not a Flutter project");
    return;
  }

  if (!config.intlPackageExists) {
    // add intl
    print("Adding intl package to the pubspec.yaml file");
    await _addIntlDependency();
    print("intl package added to the pubspec.yaml file");
  }

  if (config.generate == null) {
    // add flutter generate: true
    print("Adding flutter generate: true to the pubspec.yaml file");
    await _addFlutterGenerateTrue();
    print("flutter generate: true added to the pubspec.yaml file");
  }

  if (!config.l10nYamlFileExists) {
    print("Creating l10n.yaml file");
    await _createL10nYamlFile();
    print("l10n.yaml file created");
  }
}

Future<void> _createL10nYamlFile() async {
  final file = File(l10nYamlPath);
  await file.create();
  await file.writeAsString(l10nYamlTemplate);
}

Future<void> _addFlutterGenerateTrue() async {
  final pubspecFile = File(pubspecYamlPath);
  // write after ```\nflutter:```
  final pubspecContent = await pubspecFile.readAsString();
  final updatedPubspecContent = pubspecContent.replaceFirst(
    "\nflutter:",
    "\nflutter:\n  generate: true",
  );
  await pubspecFile.writeAsString(updatedPubspecContent);
}

Future<void> _addIntlDependency() async {
  final pubspecFile = File(pubspecYamlPath);
  // write after ```dependencies:```
  final pubspecContent = await pubspecFile.readAsString();
  final updatedPubspecContent = pubspecContent.replaceFirst(
    "dependencies:",
    "dependencies:\n  intl: any",
  );
  await pubspecFile.writeAsString(updatedPubspecContent);
}
