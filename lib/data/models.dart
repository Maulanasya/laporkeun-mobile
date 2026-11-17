class Profile {
  final String id, nama, role;
  final String? nis, noTelepon;
  Profile.fromMap(Map<String, dynamic> m)
      : id = m['id'] as String,
        nama = m['nama'] as String,
        role = m['role'] as String,
        nis = m['nis'] as String?,
        noTelepon = m['no_telepon'] as String?;
}

/// Dipakai untuk tabel `reports` (siswa) dan view `staff_reports` (BK/psikolog).
class Report {
  final String id, kode, kategori, lokasi, kronologi, status;
  final DateTime waktuKejadian, createdAt;
  final bool? tampilkanNama; // hanya ada di sisi siswa
  final String? namaPelapor; // hanya ada di sisi BK/psikolog, null jika anonim

  Report.fromMap(Map<String, dynamic> m)
      : id = m['id'] as String,
        kode = m['kode_laporan'] as String,
        kategori = m['kategori'] as String,
        lokasi = m['lokasi'] as String,
        kronologi = m['kronologi'] as String,
        status = m['status'] as String,
        waktuKejadian = DateTime.parse(m['waktu_kejadian'] as String).toLocal(),
        createdAt = DateTime.parse(m['created_at'] as String).toLocal(),
        tampilkanNama = m['tampilkan_nama'] as bool?,
        namaPelapor = m['nama_pelapor'] as String?;

  String get identitas {
    if (tampilkanNama != null) return tampilkanNama! ? 'Nama ditampilkan' : 'Anonim';
    return namaPelapor ?? 'Anonim';
  }
}

class HistoryItem {
  final String statusBaru;
  final String? catatan;
  final DateTime createdAt;
  HistoryItem.fromMap(Map<String, dynamic> m)
      : statusBaru = m['status_baru'] as String,
        catatan = m['catatan'] as String?,
        createdAt = DateTime.parse(m['created_at'] as String).toLocal();
}

class ConsultSession {
  final String id, jenis;
  final String? psychologistPhone;
  ConsultSession.fromMap(Map<String, dynamic> m)
      : id = m['id'] as String,
        jenis = m['jenis_sesi'] as String,
        psychologistPhone = m['psychologist_phone'] as String?;
}

class Article {
  final String id, judul, isi, status;
  final String? ringkasan, cover;
  final DateTime tanggal;
  Article.fromMap(Map<String, dynamic> m)
      : id = m['id'] as String,
        judul = m['judul'] as String,
        isi = m['isi'] as String,
        status = m['status_publikasi'] as String,
        ringkasan = m['ringkasan'] as String?,
        cover = m['gambar_sampul'] as String?,
        tanggal = DateTime.parse(m['tanggal_publikasi'] as String).toLocal();
}