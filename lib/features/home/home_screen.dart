import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/main_scaffold.dart';
import '../../widgets/section_title.dart';
import '../../sample_data.dart';
import '../../widgets/chef_card.dart';
import '../../widgets/dish_card.dart';
import '../../widgets/chef_filter_bar.dart';

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
                  Theme.of(context).colorScheme.primary.withAlpha((255 * 0.05).round()),
                  Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.05).round()),
                  Theme.of(context).colorScheme.tertiary.withAlpha((255 * 0.05).round()),
                ],
              ),
            ),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true)),
        ),

        // Floating food icons
        ...List.generate(
          10,
          (index) => Positioned(
            left: Random().nextDouble() * MediaQuery.of(context).size.width,
            top: Random().nextDouble() * MediaQuery.of(context).size.height,
            child:
                Transform.rotate(
                      angle: Random().nextDouble() * 2 * pi,
                      child: Icon(
                        _getRandomFoodIcon(),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha((255 * 0.1).round()),
                        size: Random().nextDouble() * 40 + 20,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .move(
                      begin: const Offset(0, 0),
                      end: Offset(
                        (Random().nextDouble() - 0.5) * 20,
                        (Random().nextDouble() - 0.5) * 20,
                      ),
                      duration: Duration(seconds: 3 + Random().nextInt(5)),
                      curve: Curves.easeInOut,
                    ),
          ),
        ),
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).round()),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCuisine = 'الكل';
  double _minRating = 0;

  void _handleCuisineSelected(String cuisine) {
    setState(() {
      _selectedCuisine = cuisine;
      // In a real app, you would filter the chefs list here
    });
  }

  void _handleRatingSelected(double rating) {
    setState(() {
      _minRating = rating;
      // In a real app, you would filter the chefs list here
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return MainScaffold(
      currentIndex: 0,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          // Animated background
          const AnimatedBackground(),

          // Main content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  'وجبتي',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Badge(
                      backgroundColor: colorScheme.primary,
                      child: const Icon(Icons.notifications_outlined),
                    ),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                ],
              ),

              // Main content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  child:
                      Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting with animation
                              _buildGreetingSection(theme, colorScheme),

                              const SizedBox(height: 16),

                              // Animated search bar
                              const AnimatedSearchBar(),

                              const SizedBox(height: 24),

                              // Categories with smooth scroll
                              _buildCategoriesSection(theme, colorScheme),

                              const SizedBox(height: 24),

                              // Special offers banner
                              _buildSpecialOfferBanner(
                                context,
                                theme,
                                colorScheme,
                              ),

                              const SizedBox(height: 24),
                            ],
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            curve: Curves.easeOutCubic,
                          ),
                ),
              ),
              // Chef Filters
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'استكشف أفضل الطهاة',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ChefFilterBar(
                  onCuisineSelected: _handleCuisineSelected,
                  onRatingSelected: _handleRatingSelected,
                  isRTL: isRTL,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => context.push('/chefs'),
                        child: Text(
                          'عرض الكل',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        'أفضل الطهاة',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildChefsList(),
              _buildSectionHeader(
                title: 'أطباق موصى بها',
                onSeeAll: () => context.push('/dishes'),
              ),

              // Dishes Grid
              _buildDishesGrid(),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً بك في وجبتي',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 8),
        Text(
          'اكتشف أفضل الأطباق والطهاة',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withAlpha((255 * 0.8).round()),
          ),
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildCategoriesSection(ThemeData theme, ColorScheme colorScheme) {
    final categories = [
      {'name': 'الكل', 'icon': Icons.all_inclusive},
      {'name': 'وجبات سريعة', 'icon': Icons.fastfood},
      {'name': 'حلويات', 'icon': Icons.cake},
      {'name': 'مشويات', 'icon': Icons.outdoor_grill},
      {'name': 'مشروبات', 'icon': Icons.local_bar},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return _buildCategoryItem(
            context: context,
            name: categories[index]['name'] as String,
            icon: categories[index]['icon'] as IconData,
            isSelected: isSelected,
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required String name,
    required IconData icon,
    required bool isSelected,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        // Handle category selection
      },
      child:
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: colorScheme.primary.withAlpha((255 * 0.3).round()),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ).animate().slideX(
            begin: 0.5,
            end: 0,
            duration: 300.ms,
            delay: (index * 50).ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }

  Widget _buildSpecialOfferBanner(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to special offers
      },
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withAlpha((255 * 0.3).round()),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative elements
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha((255 * 0.1).round()),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'خصم 30%',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'على جميع الوجبات',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onPrimary.withAlpha((255 * 0.9).round()),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'اطلب الآن',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Food image
                  Transform.rotate(
                    angle: -0.1,
                    child:
                        Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/special_offer.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha((255 * 0.2).round()),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .move(
                              begin: const Offset(0, 0),
                              end: const Offset(0, -10),
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required VoidCallback onSeeAll,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 24.0,
          top: 16,
          bottom: 16,
          left: 24,
        ),
        child: SectionTitle(title, showSeeAll: true, onSeeAll: onSeeAll),
      ),
    );
  }

  Widget _buildChefsList() {
    // In a real app, you would filter the chefs based on the selected filters
    final filteredChefs = sampleChefs.where((chef) {
      final matchesCuisine =
          _selectedCuisine == 'الكل' || chef.cuisine == _selectedCuisine;
      final matchesRating = chef.rating >= _minRating;
      return matchesCuisine && matchesRating;
    }).toList();

    if (filteredChefs.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 180,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.restaurant_menu, // Using a different icon that exists
                size: 48,
                color: Colors.grey, // Using a fixed color
              ),
              const SizedBox(height: 12),
              Text(
                'لا توجد نتائج',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCuisine = 'الكل';
                    _minRating = 0;
                  });
                },
                child: const Text('إعادة تعيين الفلاتر'),
              ),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200, // Slightly taller to accommodate the rating
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredChefs.length,
          itemBuilder: (context, index) {
            return Animate(
              delay: Duration(milliseconds: index * 50),
              effects: [FadeEffect()],
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: 16,
                ),
                child: ChefCard(chef: filteredChefs[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDishesGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final dish = sampleDishes[index % sampleDishes.length];
          return DishCard(dish: dish).animate().fadeIn(
            delay: Duration(milliseconds: index * 50),
            duration: 300.ms,
          );
        }, childCount: sampleDishes.length > 4 ? 4 : sampleDishes.length),
      ),
    );
  }
}
