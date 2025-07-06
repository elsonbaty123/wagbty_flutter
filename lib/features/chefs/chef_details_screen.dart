import 'package:flutter/material.dart';
import '../../sample_data.dart';

class ChefDetailsScreen extends StatelessWidget {
  final String id;
  const ChefDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final chef = sampleChefs.firstWhere((c) => c.id == id);
    return Scaffold(
      appBar: AppBar(title: Text(chef.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(chef.avatar, width: 160, height: 160, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 16),
            Text(chef.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Experienced chef specializing in gourmet dishes and creative cuisine.'),
            const SizedBox(height: 24),
            const Text('Popular Dishes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Coming soon...'),
          ],
        ),
      ),
    );

  }
}
