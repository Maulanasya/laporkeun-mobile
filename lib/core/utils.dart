import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const kategoriLabels = <String, String>{
  'bullying': 'Bullying/Perundungan',
  'kekerasan_verbal': 'Kekerasan Verbal',
  'kekerasan_fisik': 'Kekerasan Fisik',
  'pelecehan_lainnya': 'Pelecehan/Lainnya',
};

const statusLabels = <String, String>{
  'menunggu_ditinjau': 'Menunggu Ditinjau',
  'sedang_ditinjau': 'Sedang Ditinjau',
  'dalam_penanganan': 'Dalam Penanganan',
  'dialihkan_psikolog': 'Dialihkan ke Psikolog',
  'selesai': 'Selesai',
};

Color statusColor(String s) => switch (s) {
      'menunggu_ditinjau' => Colors.orange.shade800,
      'sedang_ditinjau' => Colors.blue.shade700,
      'dalam_penanganan' => Colors.indigo,
      'dialihkan_psikolog' => Colors.purple,
      'selesai' => Colors.green.shade700,
      _ => Colors.grey,
    };

String homeFor(String role) => switch (role) {
      'siswa' => '/siswa',
      'guru_bk' => '/bk',
      'psikolog' => '/psikolog',
      _ => '/',
    };

String fmtDate(DateTime d) => DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(d);

String errMsg(Object e) {
  if (e is AuthException) {
    return e.message.contains('Invalid login') ? 'Email atau kata sandi salah.' : e.message;
  }
  if (e is PostgrestException) return e.message;
  if (e is StorageException) return e.message;
  return 'Terjadi kesalahan: $e';
}

void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        border: Border.all(color: c),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusLabels[status] ?? status,
        style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}