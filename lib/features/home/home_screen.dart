import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../widgets/main_scaffold.dart';
import '../../widgets/section_title.dart';
import '../../sample_data.dart';
import '../../widgets/chef_card.dart';
import '../../widgets/dish_card.dart';
import '../../theme/app_theme.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated gradient background
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  Theme.of(context).colorScheme.secondary.withOpacity(0.05),
                  Theme.of(context).colorScheme.tertiary.withOpacity(0.05),
                ],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)),
        ),
        
        // Floating food icons
        ...List.generate(10, (index) => Positioned(
          left: Random().nextDouble() * MediaQuery.of(context).size.width,
          top: Random().nextDouble() * MediaQuery.of(context).size.height,
          child: Transform.rotate(
            angle: Random().nextDouble() * 2 * pi,
            child: Icon(
              _getRandomFoodIcon(),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              size: Random().nextDouble() * 40 + 20,
            ),
          ).animate(
            onPlay: (controller) => controller.repeat(reverse: true)
          ).move(
            begin: const Offset(0, 0),
            end: Offset(
              (Random().nextDouble() - 0.5) * 20,
              (Random().nextDouble() - 0.5) * 20,
            ),
            duration: Duration(seconds: 3 + Random().nextInt(5)),
            curve: Curves.easeInOut,
          ),
        )),
      ],
    );
  }
  
  IconData _getRandomFoodIcon() {
    final icons = [
      Icons.restaurant,
      Icons.local_pizza,
      Icons.cake,
      Icons.emoji_food_beverage,
      Icons.icecream,
      Icons.local_dining,
      Icons.kitchen,
      Icons.fastfood,
    ];
    return icons[Random().nextInt(icons.length)];
  }
}

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({super.key});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _isExpanded = false;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textAlign: TextAlign.right,
              onTap: () {
                setState(() => _isExpanded = true);
              },
              onSubmitted: (_) {
                setState(() => _isExpanded = false);
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن الأطباق أو الطهاة...',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: _isExpanded 
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() => _isExpanded = false);
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (!_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return MainScaffold(
      currentIndex: 0,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            title: Text('وجبتي', 
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            centerTitle: true,
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting and search
                  Text('مرحباً بك في وجبتي', 
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('اكتشف أفضل الأطباق والطهاة',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن الأطباق أو الطهاة...',
                        hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
            ),
          ),
          
          // Featured Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 130,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final categories = ['الكل', 'وجبات سريعة', 'حلويات', 'مشويات', 'مشروبات'];
                  return Chip(
                    label: Text(categories[index]),
                    backgroundColor: index == 0 ? colorScheme.primary : colorScheme.surfaceVariant,
                    labelStyle: TextStyle(
                      color: index == 0 ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: index == 0 ? Colors.transparent : colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                  ).animate().slideX(
                    begin: 0.5,
                    end: 0,
                    duration: 300.ms,
                    delay: (index * 50).ms,
                    curve: Curves.easeOutCubic,
                  );
                },
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, top: 32, bottom: 16, left: 24),
              child: SectionTitle(
                'أفضل الطهاة',
                showSeeAll: true,
                onSeeAll: () {
                  // Navigate to chefs list
                  context.push('/chefs');
                },
              ),
            ),
          ),
            // Top Chefs Section
            SliverToBoxAdapter(
              child: SizedBox(
                height: 240,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: sampleChefs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final chef = sampleChefs[index];
                    return ChefCard(chef: chef).animate().slideX(
                      begin: 0.3,
                      end: 0,
                      duration: 300.ms,
                      delay: (index * 50).ms,
                      curve: Curves.easeOutCubic,
                    );
                  },
                ),
              ),
            ),
            
            // Recommended Dishes Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 32, bottom: 16, left: 24),
                child: SectionTitle(
                  'أطباق موصى بها',
                  showSeeAll: true,
                  onSeeAll: () {
                    // Navigate to all dishes
                    context.push('/dishes');
                  },
                ),
              ),
            ),
            
            // Dishes Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final dish = sampleDishes[index % sampleDishes.length];
                    return DishCard(dish: dish).animate().fadeIn(
                      delay: (index * 50).ms,
                      duration: 300.ms,
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
