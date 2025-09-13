import 'package:flutter/material.dart';

class OutfitDetailScreen extends StatefulWidget {
  final Map<String, String> outfit;
  final bool isFavorite;
  final void Function(Map<String, String>) onToggleFavorite;

  const OutfitDetailScreen({
    super.key,
    required this.outfit,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<OutfitDetailScreen> createState() => _OutfitDetailScreenState();
}

class _OutfitDetailScreenState extends State<OutfitDetailScreen> {
  late bool _isFav;
  late final List<String> _images;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavorite;
    _images = (widget.outfit['imageUrl'] ?? "")
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  void _toggle() {
    widget.onToggleFavorite(widget.outfit);
    setState(() => _isFav = !_isFav);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.outfit['title'] ?? "Outfit";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border, color: _isFav ? Colors.red : null),
            onPressed: _toggle,
          )
        ],
      ),
      body: Column(
        children: [
          if (_images.isNotEmpty)
            SizedBox(
              height: 320,
              child: PageView.builder(
                itemCount: _images.length,
                controller: PageController(viewportFraction: 0.95),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image, size: 64))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Suggested outfit for the current weather. Tap the heart to save or remove from favorites.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _toggle,
                    icon: Icon(_isFav ? Icons.favorite : Icons.favorite_border),
                    label: Text(_isFav ? "Remove Favorite" : "Save Favorite"),
                    style: ElevatedButton.styleFrom(backgroundColor: _isFav ? Colors.red : null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
