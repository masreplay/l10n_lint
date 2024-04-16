import 'package:args/args.dart';

import 'l10n_init.dart';
import 'sort.dart';
import 'unused.dart';
import 'version.dart';

const String helpFlag = 'help';
const String sortFlag = 'sort';
const String unusedFlag = 'unusedFlag';
const String initFlag = 'init';
const String verboseFlag = 'verbose';
const String versionFlag = 'version';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      helpFlag,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      verboseFlag,
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      sortFlag,
      abbr: 's',
      negatable: false,
      help: 'Sort the output.',
    )
    ..addFlag(
      unusedFlag,
      abbr: 'u',
      negatable: false,
      help: 'Find unused translations.',
    )
    ..addFlag(
      initFlag,
      abbr: 'i',
      negatable: false,
      help: 'Initialize the l10n tool.',
    )
    ..addFlag(
      versionFlag,
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart l10n.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final results = argParser.parse(arguments);
    var verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    } else if (results.wasParsed(versionFlag)) {
      print('l10n version: $version');
      return;
    } else if (results.wasParsed(verboseFlag)) {
      verbose = true;
    } else if (results.wasParsed(sortFlag)) {
      sortArbFileAlphabetically();
    } else if (results.wasParsed(initFlag)) {
      initL10nCommand();
    } else if (results.wasParsed(unusedFlag)) {
      final delete = results['delete'] as bool;
      unusedTranslationsCommand(delete);
    }

    // // Act on the arguments provided.
    // print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
