import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:pub_update_checker/pub_update_checker.dart';

final magentaPen = AnsiPen()..magenta();
final greenPen = AnsiPen()..green();
final yellowPen = AnsiPen()..yellow();
final redPen = AnsiPen()..red();

void main() async {
  final newVersion = await PubUpdateChecker.check();
  if (newVersion != null) {
    print(
      yellowPen(
        'There is an update available: $newVersion. Run `dart pub global activate one_password_dart` to update.',
      ),
    );
  }

  final files = Directory.current.listSync(recursive: true).whereType<File>();
  final secrets = files.where((e) => e.path.contains('.ops.'));
  final references = files.where((e) => e.path.contains('.opr.'));

  // Delete old secrets
  for (final secret in secrets) {
    secret.deleteSync();
  }

  for (final secret in references) {
    final result = Process.runSync('op', [
      'inject',
      '-f',
      '-i',
      secret.path,
      '-o',
      secret.path.replaceFirst('.opr.', '.ops.'),
    ]);

    if (result.exitCode != 0) {
      print(redPen(result.stderr));
      exit(result.exitCode);
    }
  }

  print(greenPen('Secrets injected!'));
  print(yellowPen('Make sure you have the following in your .gitignore:'));
  print(yellowPen('*.ops.*'));

  exit(0);
}
