import 'package:flutter/material.dart';

import '../../../shared/widgets/app_glass_card.dart';

class ReportEvidenceSection extends StatelessWidget {
  final List<String> urls;

  const ReportEvidenceSection({super.key, required this.urls});

  void _showImage(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (_) =>
          Dialog(child: InteractiveViewer(child: Image.network(url))),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    return AppGlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (final url in urls)
            GestureDetector(
              onTap: () => _showImage(context, url),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  url,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.black12,
                    child: const Icon(Icons.broken_image_outlined),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
