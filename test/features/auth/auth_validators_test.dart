import 'package:flutter_test/flutter_test.dart';
import 'package:laporkeun/features/auth/validators/auth_validators.dart';

void main() {
  group('Auth Validators', () {
    group('requiredValidator', () {
      test('menolak nilai kosong', () {
        expect(requiredValidator(null), 'Wajib diisi');
        expect(requiredValidator(''), 'Wajib diisi');
        expect(requiredValidator('   '), 'Wajib diisi');
      });

      test('menerima nilai yang terisi', () {
        expect(requiredValidator('Kelompok10'), isNull);
      });
    });

    group('emailValidator', () {
      test('menolak email kosong', () {
        expect(emailValidator(null), 'Email wajib diisi');
        expect(emailValidator(''), 'Email wajib diisi');
      });

      test('menolak format email tidak valid', () {
        expect(emailValidator('kelompok10'), 'Format email tidak valid');
        expect(emailValidator('kelompok10@gmail'), 'Format email tidak valid');
      });

      test('menerima format email valid', () {
        expect(emailValidator('kelompok10@gmail.com'), isNull);
      });
    });
  });
}
