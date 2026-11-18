import 'package:flutter_test/flutter_test.dart';
import 'package:laporkeun/core/theme.dart';

void main() {
  group('LaporKeun Theme', () {
    test('buildTheme menggunakan Material 3', () {
      final theme = buildTheme();

      expect(theme.useMaterial3, isTrue);
    });
  });
}
