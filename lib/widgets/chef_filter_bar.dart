import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChefFilterBar extends StatefulWidget {
  final Function(String) onCuisineSelected;
  final Function(double) onRatingSelected;
  final bool isRTL;

  const ChefFilterBar({
    super.key,
    required this.onCuisineSelected,
    required this.onRatingSelected,
    required this.isRTL,
  });

  @override
  State<ChefFilterBar> createState() => _ChefFilterBarState();
}

class _ChefFilterBarState extends State<ChefFilterBar> {
  String? _selectedCuisine;
  double? _selectedRating;

  final List<String> cuisines = [
    'الكل',
    'مطبخ مصري',
    'مطبخ سوري',
    'مطبخ سعودي',
    'مأكولات بحرية',
    'حلويات',
    'مشويات',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cuisine Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'نوع المطبخ',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: cuisines.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedCuisine == cuisines[index] || 
                    (_selectedCuisine == null && index == 0);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(cuisines[index]),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCuisine = selected ? cuisines[index] : null;
                        if (selected) {
                          widget.onCuisineSelected(cuisines[index]);
                        } else {
                          widget.onCuisineSelected('الكل');
                        }
                      });
                    },
                    backgroundColor: colorScheme.surfaceVariant,
                    selectedColor: colorScheme.primary.withOpacity(0.2),
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected 
                            ? colorScheme.primary 
                            : colorScheme.surfaceVariant,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Rating Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'التقييم',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_selectedRating != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedRating = null;
                        widget.onRatingSelected(0);
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 24),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'إعادة تعيين',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 5,
              itemBuilder: (context, index) {
                final rating = 5 - index; // 5 to 1 stars
                final isSelected = _selectedRating == rating.toDouble();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          rating.toString(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isSelected 
                                ? colorScheme.onPrimary 
                                : colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: isSelected 
                              ? colorScheme.onPrimary 
                              : colorScheme.primary,
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRating = selected ? rating.toDouble() : null;
                        if (selected) {
                          widget.onRatingSelected(rating.toDouble());
                        } else {
                          widget.onRatingSelected(0);
                        }
                      });
                    },
                    backgroundColor: colorScheme.surfaceVariant,
                    selectedColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected 
                            ? colorScheme.primary 
                            : colorScheme.surfaceVariant,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(
      begin: 0.1,
      end: 0,
      curve: Curves.easeOutCubic,
    );
  }
}
