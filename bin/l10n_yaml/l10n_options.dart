import 'dart:io';

import 'package:yaml/yaml.dart';

class LocalizationOptions {
  LocalizationOptions({
    required this.arbDir,
    this.outputDir,
    String? templateArbFile,
    String? outputLocalizationFile,
    this.untranslatedMessagesFile,
    String? outputClass,
    this.preferredSupportedLocales,
    this.header,
    this.headerFile,
    bool? useDeferredLoading,
    this.genInputsAndOutputsList,
    bool? syntheticPackage,
    this.projectDir,
    bool? requiredResourceAttributes,
    bool? nullableGetter,
    bool? format,
    bool? useEscaping,
    bool? suppressWarnings,
    bool? relaxSyntax,
    bool? useNamedParameters,
  })  : templateArbFile = templateArbFile ?? 'app_en.arb',
        outputLocalizationFile =
            outputLocalizationFile ?? 'app_localizations.dart',
        outputClass = outputClass ?? 'AppLocalizations',
        useDeferredLoading = useDeferredLoading ?? false,
        syntheticPackage = syntheticPackage ?? true,
        requiredResourceAttributes = requiredResourceAttributes ?? false,
        nullableGetter = nullableGetter ?? true,
        format = format ?? false,
        useEscaping = useEscaping ?? false,
        suppressWarnings = suppressWarnings ?? false,
        relaxSyntax = relaxSyntax ?? false,
        useNamedParameters = useNamedParameters ?? false;

  /// The `--arb-dir` argument.
  ///
  /// The directory where all input localization files should reside.
  final String arbDir;

  /// The `--output-dir` argument.
  ///
  /// The directory where all output localization files should be generated.
  final String? outputDir;

  /// The `--template-arb-file` argument.
  ///
  /// This path is relative to [arbDirectory].
  final String templateArbFile;

  /// The `--output-localization-file` argument.
  ///
  /// This path is relative to [arbDir].
  final String outputLocalizationFile;

  /// The `--untranslated-messages-file` argument.
  ///
  /// This path is relative to [arbDir].
  final String? untranslatedMessagesFile;

  /// The `--output-class` argument.
  final String outputClass;

  /// The `--preferred-supported-locales` argument.
  final List<String>? preferredSupportedLocales;

  /// The `--header` argument.
  ///
  /// The header to prepend to the generated Dart localizations.
  final String? header;

  /// The `--header-file` argument.
  ///
  /// A file containing the header to prepend to the generated
  /// Dart localizations.
  final String? headerFile;

  /// The `--use-deferred-loading` argument.
  ///
  /// Whether to generate the Dart localization file with locales imported
  /// as deferred.
  final bool useDeferredLoading;

  /// The `--gen-inputs-and-outputs-list` argument.
  ///
  /// This path is relative to [arbDir].
  final String? genInputsAndOutputsList;

  /// The `--synthetic-package` argument.
  ///
  /// Whether to generate the Dart localization files in a synthetic package
  /// or in a custom directory.
  final bool syntheticPackage;

  /// The `--project-dir` argument.
  ///
  /// This path is relative to [arbDir].
  final String? projectDir;

  /// The `required-resource-attributes` argument.
  ///
  /// Whether to require all resource ids to contain a corresponding
  /// resource attribute.
  final bool requiredResourceAttributes;

  /// The `nullable-getter` argument.
  ///
  /// Whether or not the localizations class getter is nullable.
  final bool nullableGetter;

  /// The `format` argument.
  ///
  /// Whether or not to format the generated files.
  final bool format;

  /// The `use-escaping` argument.
  ///
  /// Whether or not the ICU escaping syntax is used.
  final bool useEscaping;

  /// The `suppress-warnings` argument.
  ///
  /// Whether or not to suppress warnings.
  final bool suppressWarnings;

  /// The `relax-syntax` argument.
  ///
  /// Whether or not to relax the syntax. When specified, the syntax will be
  /// relaxed so that the special character "{" is treated as a string if it is
  /// not followed by a valid placeholder and "}" is treated as a string if it
  /// does not close any previous "{" that is treated as a special character.
  /// This was added in for backward compatibility and is not recommended
  /// as it may mask errors.
  final bool relaxSyntax;

  /// The `use-named-parameters` argument.
  ///
  /// Whether or not to use named parameters for the generated localization
  /// methods.
  ///
  /// Defaults to `false`.
  final bool useNamedParameters;

  static const String arbDirKey = 'arb-dir';
  static const String outputDirKey = 'output-dir';
  static const String templateArbFileKey = 'template-arb-file';
  static const String outputLocalizationFileKey = 'output-localization-file';
  static const String untranslatedMessagesFileKey =
      'untranslated-messages-file';
  static const String outputClassKey = 'output-class';
  static const String headerKey = 'header';
  static const String headerFileKey = 'header-file';
  static const String useDeferredLoadingKey = 'use-deferred-loading';
  static const String preferredSupportedLocalesKey =
      'preferred-supported-locales';
  static const String syntheticPackageKey = 'synthetic-package';
  static const String requiredResourceAttributesKey =
      'required-resource-attributes';
  static const String nullableGetterKey = 'nullable-getter';
  static const String formatKey = 'format';
  static const String useEscapingKey = 'use-escaping';
  static const String suppressWarningsKey = 'suppress-warnings';
  static const String relaxSyntaxKey = 'relax-syntax';
  static const String useNamedParametersKey = 'use-named-parameters';

  /// Parse the localizations configuration options from [file].
  ///
  /// Throws [Exception] if any of the contents are invalid. Returns a
  /// [LocalizationOptions] with all fields as `null` if the config file exists
  /// but is empty.
  factory LocalizationOptions.parseFromYAML({
    required File file,
    required String defaultArbDir,
  }) {
    final String contents = file.readAsStringSync();
    if (contents.trim().isEmpty) {
      return LocalizationOptions(arbDir: defaultArbDir);
    }
    final YamlNode yamlNode;
    try {
      yamlNode = loadYamlNode(file.readAsStringSync());
    } on YamlException catch (err) {
      print(err.message);
      throw Exception();
    }

    if (yamlNode is! YamlMap) {
      print('Expected ${file.path} to contain a map, instead was $yamlNode');
      throw Exception();
    }
    return LocalizationOptions(
      arbDir: _tryReadUri(yamlNode, arbDirKey)?.path ?? defaultArbDir,
      outputDir: _tryReadUri(yamlNode, outputDirKey)?.path,
      templateArbFile: _tryReadUri(yamlNode, templateArbFileKey)?.path,
      outputLocalizationFile:
          _tryReadUri(yamlNode, outputLocalizationFileKey)?.path,
      untranslatedMessagesFile:
          _tryReadUri(yamlNode, untranslatedMessagesFileKey)?.path,
      outputClass: _tryReadString(yamlNode, outputClassKey),
      header: _tryReadString(yamlNode, headerKey),
      headerFile: _tryReadUri(yamlNode, headerFileKey)?.path,
      useDeferredLoading: _tryReadBool(yamlNode, useDeferredLoadingKey),
      preferredSupportedLocales:
          _tryReadStringList(yamlNode, preferredSupportedLocalesKey),
      syntheticPackage: _tryReadBool(yamlNode, syntheticPackageKey),
      requiredResourceAttributes:
          _tryReadBool(yamlNode, requiredResourceAttributesKey),
      nullableGetter: _tryReadBool(yamlNode, nullableGetterKey),
      format: _tryReadBool(yamlNode, formatKey),
      useEscaping: _tryReadBool(yamlNode, useEscapingKey),
      suppressWarnings: _tryReadBool(yamlNode, suppressWarningsKey),
      relaxSyntax: _tryReadBool(yamlNode, relaxSyntaxKey),
      useNamedParameters: _tryReadBool(yamlNode, useNamedParametersKey),
    );
  }

  @override
  String toString() {
    return '''
$arbDirKey: $arbDir
$outputDirKey: $outputDir
$templateArbFileKey: $templateArbFile
$outputLocalizationFileKey: $outputLocalizationFile
$untranslatedMessagesFileKey: $untranslatedMessagesFile
$outputClassKey: $outputClass
$preferredSupportedLocalesKey: $preferredSupportedLocales
$headerKey: $header
$headerFileKey: $headerFile
$useDeferredLoadingKey: $useDeferredLoading
$syntheticPackageKey: $syntheticPackage
$requiredResourceAttributesKey: $requiredResourceAttributes
$nullableGetterKey: $nullableGetter
$formatKey: $format
$useEscapingKey: $useEscaping
$suppressWarningsKey: $suppressWarnings
$relaxSyntaxKey: $relaxSyntax
$useNamedParametersKey: $useNamedParameters''';
  }
}

// Try to read a `bool` value or null from `yamlMap`, otherwise throw.
bool? _tryReadBool(YamlMap yamlMap, String key) {
  final Object? value = yamlMap[key];
  if (value == null) {
    return null;
  }
  if (value is! bool) {
    print('Expected "$key" to have a bool value, instead was "$value"');
    throw Exception();
  }
  return value;
}

// Try to read a `String` value or null from `yamlMap`, otherwise throw.
String? _tryReadString(YamlMap yamlMap, String key) {
  final Object? value = yamlMap[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    print('Expected "$key" to have a String value, instead was "$value"');
    throw Exception();
  }
  return value;
}

List<String>? _tryReadStringList(YamlMap yamlMap, String key) {
  final Object? value = yamlMap[key];
  if (value == null) {
    return null;
  }
  if (value is String) {
    return <String>[value];
  }
  if (value is Iterable) {
    return value.map((dynamic e) => e.toString()).toList();
  }
  print('"$value" must be String or List.');
  throw Exception();
}

// Try to read a valid `Uri` or null from `yamlMap`, otherwise throw.
Uri? _tryReadUri(YamlMap yamlMap, String key) {
  final String? value = _tryReadString(yamlMap, key);
  if (value == null) {
    return null;
  }
  final Uri? uri = Uri.tryParse(value);
  if (uri == null) {
    print('"$value" must be a relative file URI');
  }
  return uri;
}
