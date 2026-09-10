import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

/// Maintains `.generated_manifest.json`, a committed manifest of hash digests
/// for every generated output file.
///
/// Generated code itself is gitignored (see AGENTS.md), so a tracked-only diff
/// (the old `generate:check`) cannot detect field-level drift in models or
/// endpoints: a model column renamed in `serverpod` or a Freezed field added in
/// `build_runner` changes only gitignored bytes. The manifest closes that gap by
/// giving the gitignored output a tracked, comparable fingerprint.
///
/// Usage (via melos, from the repository root):
///   fvm dart run tool/update_generated_manifest.dart            # (re)write the manifest
///   fvm dart run tool/update_generated_manifest.dart check      # fail if output drifted
///
/// `check` exits non-zero when the current generated output no longer matches
/// the committed manifest, listing the drifted files. Run the write form after
/// any *legitimate* model/endpoint change (see `melos run generate:manifest`).
void main(List<String> args) {
  final root = Directory.current.absolute;
  final manifestPath = File(
    '${root.path}${Platform.pathSeparator}.generated_manifest.json',
  );

  final generated = collectGeneratedFiles(root);
  final current = <String, String>{};
  for (final file in generated) {
    final relative = file.path
        .substring(root.path.length + 1)
        .split(Platform.pathSeparator)
        .join('/');
    final digest = sha256.convert(file.readAsBytesSync()).toString();
    current[relative] = digest;
  }

  final check = args.contains('check');
  if (check) {
    if (!manifestPath.existsSync()) {
      stderr.writeln(
        'error: missing .generated_manifest.json. Run "melos run generate" then '
        '"fvm dart run tool/update_generated_manifest.dart" to create it.',
      );
      exit(1);
    }
    final committed =
        jsonDecode(manifestPath.readAsStringSync()) as Map<String, dynamic>;
    exit(_reportDrift(committed, current));
  }

  manifestPath.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(current)}\n',
  );
  stdout.writeln('Wrote .generated_manifest.json (${current.length} files).');
}

/// Digests of generated output. Paths are relative to the repository root and
/// sorted so the manifest is deterministic across runs and hosts.
List<File> collectGeneratedFiles(Directory root) {
  final all = <File>{};

  void walk(Directory directory) {
    for (final entity in directory.listSync(followLinks: false)) {
      final name = entity.path.split(Platform.pathSeparator).last;
      if (entity is Directory) {
        if (const {
          'build',
          '.dart_tool',
          '.melos',
          '.fvm',
          '.git',
        }.contains(name))
          continue;
        walk(entity);
      } else if (entity is File) {
        all.add(entity);
      }
    }
  }

  walk(root);
  final generated = <File>{};

  // Serverpod outputs (gitignored dirs mirrored as a whole).
  for (final dir in const [
    'apps/server/lib/src/generated',
    'packages/app_client/lib/src/protocol',
  ]) {
    final directory = Directory('${root.path}${Platform.pathSeparator}$dir');
    if (directory.existsSync()) {
      for (final file in all.where(
        (f) => f.path.startsWith('${directory.path}${Platform.pathSeparator}'),
      )) {
        generated.add(file);
      }
    }
  }

  // Freezed / json_serializable outputs (gitignored, whichever tree they live in).
  for (final file in all) {
    final name = file.path.split(Platform.pathSeparator).last;
    if (name.endsWith('.freezed.dart') || name.endsWith('.g.dart')) {
      generated.add(file);
    }
  }

  // Tracked mirror of the generated serverpod test tools.
  for (final file in all.where(
    (f) => f.path.endsWith('serverpod_test_tools.dart'),
  )) {
    generated.add(file);
  }

  final sorted = generated.toList()..sort((a, b) => a.path.compareTo(b.path));
  return sorted;
}

int _reportDrift(Map<String, dynamic> committed, Map<String, String> current) {
  final added = current.keys.where((k) => !committed.containsKey(k)).toList()
    ..sort();
  final removed = committed.keys.where((k) => !current.containsKey(k)).toList()
    ..sort();
  final changed = current.keys.where((k) {
    final other = committed[k];
    return other is String && other != current[k];
  }).toList()..sort();

  if (added.isEmpty && removed.isEmpty && changed.isEmpty) {
    stdout.writeln('Generated output matches .generated_manifest.json.');
    return 0;
  }

  stderr.writeln(
    'error: generated output drifted from .generated_manifest.json.',
  );
  stderr.writeln(
    'Model/endpoint changes must be regenerated and re-manifested via "melos run generate:manifest".',
  );
  for (final file in changed) {
    stderr.writeln('  changed: $file');
  }
  for (final file in added) {
    stderr.writeln('  added:   $file');
  }
  for (final file in removed) {
    stderr.writeln('  removed: $file');
  }
  return 1;
}
