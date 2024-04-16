import 'dart:io';
import 'package:path/path.dart' as path;

import '../l10n_options.dart';
import '../l10n_template.dart';

// arbDir
// outputDir
// templateArbFile
// outputLocalizationFile
// untranslatedMessagesFile
// outputClass
// preferredSupportedLocales
// header
// headerFile
// useDeferredLoading
// genInputsAndOutputsList
// syntheticPackage
// projectDir
// requiredResourceAttributes
// nullableGetter
// format
// useEscaping
// suppressWarnings
// relaxSyntax
// useNamedParameters

Future<void> configureL10nOptions(LocalizationOptions options) async {
  final arbDir = Directory(options.arbDir);
  print("${LocalizationOptions.arbDirKey}: ${options.arbDir}");
  if (arbDir.existsSync()) {
    print("arb directory found");
  } else {
    print("arb directory not found");
    arbDir.createSync();
    print("arb directory created");
  }

  // relative to arbDir join
  final templateArbFile = File(path.join(arbDir.path, options.templateArbFile));
  print(
      "${LocalizationOptions.templateArbFileKey}: ${options.templateArbFile}");
  if (templateArbFile.existsSync()) {
    if ((await templateArbFile.length()) == 0) {
      print("template arb file is empty");
      templateArbFile.writeAsStringSync(l10nYamlTemplate);
    } else {
      print("template arb file found");
    }
  } else {
    print("template arb file not found");
    templateArbFile.createSync();
    templateArbFile.writeAsStringSync("{}");
    print("template arb file created");
  }
}
