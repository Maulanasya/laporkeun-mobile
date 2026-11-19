import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ReportSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ReportSearchField({super.key, required this.onChanged});

  @override
  State<ReportSearchField> createState() => _ReportSearchFieldState();
}

class _ReportSearchFieldState extends State<ReportSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _controller.clear();
    });

    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {});
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            hintText: 'Cari kode, identitas, atau kategori...',
            hintStyle: TextStyle(
              color: AppColors.ink.withValues(alpha: 0.45),
              fontSize: 13,
            ),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
            ),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Hapus pencarian',
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.ink.withValues(alpha: 0.55),
                    onPressed: _clear,
                  ),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
