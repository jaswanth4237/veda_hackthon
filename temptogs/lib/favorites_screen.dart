import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;
  final void Function(Map<String, String>) onRemove;
  final VoidCallback onClearAll;
  final void Function(Map<String, String>) onOpen;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onRemove,
    required this.onClearAll,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(child: Text("No favorites yet!", style: TextStyle(fontSize: 16, color: Colors.grey)));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: onClearAll,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Clear All"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final outfit = favorites[index];
              final images = (outfit['imageUrl'] ?? "").split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent]),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(outfit['title'] ?? "Outfit", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Remove favorite?"),
                                  content: Text('Remove "${outfit['title']}" from favorites?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                                    TextButton(
                                      onPressed: () {
                                        onRemove(outfit);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text("Remove", style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 0.95),
                        itemCount: images.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(images[i], fit: BoxFit.cover, width: double.infinity, errorBuilder: (c,e,s) => const Icon(Icons.broken_image)),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => onOpen(outfit),
                            icon: const Icon(Icons.open_in_full),
                            label: const Text("Open"),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: () => onRemove(outfit),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text("Remove"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
