import 'dart:typed_data';

import 'package:flutter/material.dart';

enum ReportCategory {
  bullying(
    label: 'Perundungan',
    description: 'Diejek, dijauhi, atau dikucilkan',
    icon: Icons.sentiment_dissatisfied_rounded,
    color: Color(0xFFFFDCC8),
  ),
  verbal(
    label: 'Kekerasan verbal',
    description: 'Dibentak, dihina, atau diancam lewat kata-kata',
    icon: Icons.chat_bubble_rounded,
    color: Color(0xFFCDEBE6),
  ),
  fisik(
    label: 'Kekerasan fisik',
    description: 'Dipukul, didorong, atau disakiti secara fisik',
    icon: Icons.front_hand_rounded,
    color: Color(0xFFFFE9AE),
  ),
  pelecehan(
    label: 'Pelecehan / lainnya',
    description: 'Pelecehan atau kejadian lain yang membuatmu tidak nyaman',
    icon: Icons.shield_rounded,
    color: Color(0xFFF2D1DB),
  );

  const ReportCategory({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color color;
}

enum IdentityChoice { anonim, nama }

class EvidenceFile {
  const EvidenceFile({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;

  int get sizeBytes => bytes.length;
}

class ReportDraft {
  const ReportDraft({
    required this.category,
    required this.location,
    required this.occurredAt,
    required this.chronology,
    required this.evidence,
    required this.identity,
  });

  final ReportCategory category;
  final String location;
  final DateTime occurredAt;
  final String chronology;
  final List<EvidenceFile> evidence;
  final IdentityChoice identity;
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Contoh: `19 Nov 2026, 09:30`
String formatDateTime(DateTime d) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${d.day} ${_months[d.month - 1]} ${d.year}, ${two(d.hour)}:${two(d.minute)}';
}