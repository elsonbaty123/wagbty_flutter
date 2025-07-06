import 'package:flutter/material.dart';
import '../../widgets/main_scaffold.dart';
import '../../sample_data.dart';
import '../../widgets/dish_card.dart';

class DishesListScreen extends StatelessWidget {
  const DishesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text('Dishes'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => DishCard(dish: sampleDishes[index]),
                  childCount: sampleDishes.length,
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
