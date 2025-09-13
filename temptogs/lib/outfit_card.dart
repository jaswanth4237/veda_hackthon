import 'package:flutter/material.dart';
import 'outfit_detail.dart';

class OutfitCard extends StatelessWidget {
  final Map<String, String> outfit;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenDetail;

  const OutfitCard({
    super.key,
    required this.outfit,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onOpenDetail,
  });

  List<String> _images() {
    final raw = outfit['imageUrl'] ?? "";
    return raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images();
    final preview = images.isNotEmpty ? images[0] : null;
    final title = outfit['title'] ?? "Outfit";

    return GestureDetector(
      onTap: onOpenDetail,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(2, 6))],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: preview != null
                        ? Image.network(preview, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c,e,s) => const Icon(Icons.broken_image, size: 48))
                        : const SizedBox.shrink(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(colors: [Colors.black54, Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        onToggleFavorite();
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(isFavorite),
                            color: isFavorite ? Colors.red : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
