// sort l10n file

// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import '../l10n_yaml/l10n_options.dart';

sortArbFileAlphabeticallyCommand() async {
  final l10nYamlFile = File('l10n.yaml');

  if (!l10nYamlFile.existsSync()) {
    print('l10n.yaml not found');
    return;
  }

  final options = LocalizationOptions.parseFromYAML(file: l10nYamlFile);

  final arbDir = options.arbDir;

  final dir = Directory(arbDir);

  if (!dir.existsSync()) {
    print('arb-dir: missing');
    return;
  }

  final arbFiles = dir.listSync().whereType<File>().where((file) {
    final ext = file.path.split('.').last;
    return ext == 'arb';
  });

  for (final file in arbFiles) {
    await _sortFile(file.path);
  }
}

/// Sort "key" then it's placeholder "@key"
/// put key with @@ at the start of the file
/// {
///   "@@locale": "en",
///   "key": "Hello World {name}",
///   "@key": {
///      "description": "A simple hello world function",
///   }
/// }
Future<void> _sortFile(String path) async {
  final content = File(path);

  final Map<String, dynamic> oldMap = json.decode(await content.readAsString());

  final sortedMap = <String, dynamic>{};

  final sortedEntries = oldMap.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  // add only @@ keys
  for (final entry in sortedEntries) {
    if (entry.key.startsWith('@@')) {
      sortedMap[entry.key] = entry.value;
    }
  }

  for (final entry in sortedEntries) {
    if (entry.key.startsWith("@")) {
      continue;
    } else {
      final key = entry.key;
      final value = entry.value;
      final placeholderKey = '@$key';
      final placeholderValue = oldMap[placeholderKey];

      sortedMap[key] = value;
      if (placeholderValue != null) {
        sortedMap[placeholderKey] = placeholderValue;
      }
    }
  }

  final sortedJson = const JsonEncoder.withIndent('  ').convert(sortedMap);

  await content.writeAsString(sortedJson);
}
