import 'package:flutter/material.dart';
import '../../widgets/main_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../../sample_data.dart';
import '../../widgets/dish_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final favDishes = sampleDishes.where((d) => favIds.contains(d.id)).toList();

    return MainScaffold(
      currentIndex: 3,
      body: favDishes.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: const Text('Favorites'),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => DishCard(dish: favDishes[index]),
                        childCount: favDishes.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
