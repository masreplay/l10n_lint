const String l10nYamlTemplate = """arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
""";

String arbFileTemplate(String locale) => """{
  "@@locale": "$locale"
}""";
