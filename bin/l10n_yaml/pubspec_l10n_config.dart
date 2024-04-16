// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:pubspec_parse/pubspec_parse.dart';

import 'l10n_paths.dart';

class L10nConfig {
  /// Generate flag value ```flutter:\tgenerate: true```
  final bool? generate;

  /// Is intl package existed ```dependencies:\tintl: any```
  final bool intlPackageExists;

  /// Flutter section in the pubspec file ```flutter:```
  final bool isFlutterProject;

  /// l10n.yaml file exists in the project root directory
  final bool l10nYamlFileExists;

  const L10nConfig({
    required this.isFlutterProject,
    required this.generate,
    required this.intlPackageExists,
    required this.l10nYamlFileExists,
  });

  factory L10nConfig.parse(Pubspec pubspec) {
    final generate = pubspec.flutter!['generate'];
    final intlPackageExists = pubspec.dependencies.containsKey('intl');
    final l10nYamlFileExists = File(l10nYamlPath).existsSync();

    return L10nConfig(
      isFlutterProject: pubspec.flutter != null,
      generate: generate,
      intlPackageExists: intlPackageExists,
      l10nYamlFileExists: l10nYamlFileExists,
    );
  }

  bool get isConfigured {
    return isFlutterProject &&
        generate != null &&
        intlPackageExists &&
        l10nYamlFileExists;
  }

  @override
  String toString() {
    return """is flutter project: ${isFlutterProject ? 'yes' : 'no'}
generate: $generate
intl: ${intlPackageExists ? 'exists' : 'missing'}
l10n.yaml file: ${l10nYamlFileExists ? 'exists' : 'missing'}
""";
  }
}
