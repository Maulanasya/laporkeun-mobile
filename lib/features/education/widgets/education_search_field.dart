import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'education_glass.dart';

class EduSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const EduSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: eduGlass(radius: 29),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.ink.withValues(alpha: 0.55)),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari artikel',
              ),
            ),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (_, __) => controller.text.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close_rounded, size: 20),
                  ),
          ),
        ],
      ),
    );
  }
}