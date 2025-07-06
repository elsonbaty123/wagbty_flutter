import 'package:flutter/material.dart';
import '../../sample_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';

class DishDetailsScreen extends ConsumerWidget {
  final String id;
  const DishDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dish = sampleDishes.firstWhere((d) => d.id == id);
    final isFav = ref.watch(favoritesProvider).contains(dish.id);
    void toggle() => ref.read(favoritesProvider.notifier).toggle(dish.id);
    return Scaffold(
      appBar: AppBar(title: Text(dish.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(dish.image, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dish.name, style: Theme.of(context).textTheme.headlineSmall),
                    IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.redAccent),
                      onPressed: toggle,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('\$${dish.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eu dolor velit.'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add to Order'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
