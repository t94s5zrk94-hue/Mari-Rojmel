// ignore_for_file: avoid_print
import 'dart:io';

Future<void> main() async {
  print('==========================================');
  print(' Mari-Rojmel Localization Audit');
  print('==========================================');

  final lib = Directory('lib');

  if (!lib.existsSync()) {
    print('lib folder not found.');
    exit(1);
  }

  final dartFiles = lib
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));

  int totalIssues = 0;

  final textRegex = RegExp(r'''Text\(\s*["']''');
  final constTextRegex = RegExp(r'''const\s+Text\(\s*["']''');

  for (final file in dartFiles) {
    final lines = await file.readAsLines();

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Ignore empty lines
      if (line.isEmpty) continue;

      // Ignore comments
      if (line.startsWith('//')) continue;

      // Ignore already localized strings
      if (line.contains('AppLocalizations.of(') ||
          line.contains('l10n.') ||
          line.contains('AppLocalizations')) {
        continue;
      }

      // Detect hardcoded Text widgets
      if (textRegex.hasMatch(line) || constTextRegex.hasMatch(line)) {
        totalIssues++;

        print('');
        print('File : ${file.path}');
        print('Line : ${i + 1}');
        print(line);
      }
    }
  }

  print('');
  print('==========================================');
  print('Total Hardcoded Strings : $totalIssues');
  print('==========================================');
}
