// ignore_for_file: depend_on_referenced_packages

import "dart:convert";
import "dart:io";

import "package:glob/glob.dart";
import "package:glob/list_local_fs.dart";

Future<void> unusedTranslationsCommand(bool delete) async {
  final root = Directory.current.path;
  final rootPosix = root.replaceAll("\\", "/");

  final stringKeys = await _getStringKeys(rootPosix);
  final dartFiles = await _getDartFiles(rootPosix);

  final unusedStringKeys = await _findUnusedStringKeys(stringKeys, dartFiles);

  await _writeUnusedKeysAsFile(unusedStringKeys);

  if (delete) {
    print("Deleting unused string keys...");
    await _deleteUnusedStringKeys(unusedStringKeys, rootPosix);
  }
}

Future<void> _deleteUnusedStringKeys(
  Set<String> unusedStringKeys,
  String rootPosix,
) async {
  final arbFilesGlob = Glob("$rootPosix/**.arb");

  await for (var entity in arbFilesGlob.list(followLinks: false)) {
    final arbFile = entity.path;
    final content = await File(arbFile).readAsString();
    final map = jsonDecode(content) as Map<String, dynamic>;
    for (final stringKey in unusedStringKeys) {
      map.remove(stringKey);
    }

    final sink = File(arbFile).openWrite();
    sink.write(JsonEncoder.withIndent("  ").convert(map));
    await sink.flush();
    await sink.close();
  }
}

Future<Set<String>> _getStringKeys(String path) async {
  final arbFilesGlob = Glob("$path/**.arb");

  final arbFiles = <String>[];
  await for (var entity in arbFilesGlob.list(followLinks: false)) {
    arbFiles.add(entity.path);
  }

  final stringKeys = <String>{};
  for (final file in arbFiles) {
    final content = await File(file).readAsString();
    final map = jsonDecode(content) as Map<String, dynamic>;
    for (final entry in map.entries) {
      if (!entry.key.startsWith("@")) {
        stringKeys.add(entry.key);
      }
    }
  }

  return stringKeys;
}

Future<List<String>> _getDartFiles(String path) async {
  final dartFilesGlob = Glob("$path/lib/**.dart");
  final dartFilesExcludeGlob = Glob("$path/lib/generated/**.dart");

  final dartFilesExclude = <String>[];
  await for (var entity in dartFilesExcludeGlob.list(followLinks: false)) {
    dartFilesExclude.add(entity.path);
  }

  final dartFiles = <String>[];
  await for (var entity in dartFilesGlob.list(followLinks: false)) {
    if (!dartFilesExclude.contains(entity.path)) {
      dartFiles.add(entity.path);
    }
  }

  return dartFiles;
}

Future<Set<String>> _findUnusedStringKeys(
  Set<String> stringKeys,
  List<String> files,
) async {
  final unusedStringKeys = stringKeys.toSet();

  for (final file in files) {
    final content = await File(file).readAsString();
    for (final stringKey in stringKeys) {
      if (content.contains(".$stringKey")) {
        unusedStringKeys.remove(stringKey);
      }
    }
  }

  return unusedStringKeys;
}

/// unused-messages-file.json
/// {
///   [
///    "stringKey1",
///    "stringKey2",
///   ]
/// }
///
Future<void> _writeUnusedKeysAsFile(Set<String> unusedStringKeys) async {
  final file = File("unused-messages-file.json");
  final sink = file.openWrite();
  sink.write(JsonEncoder.withIndent("  ").convert(unusedStringKeys.toList()));
  await sink.flush();
  await sink.close();
}
