import 'package:flutter/material.dart';
import '../models/literature_sample.dart';

/// List of filtered literature categories.
/// Equivalent to WPF's _literatureSamples ListBox.
class CategoryList extends StatelessWidget {
  final List<LiteratureSample> categories;
  final LiteratureSample? selectedCategory;
  final ValueChanged<LiteratureSample> onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text('Нет категорий, соответствующих фильтру'),
      );
    }

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;

        return ListTile(
          title: Text(category.title),
          selected: isSelected,
          selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
          onTap: () => onCategorySelected(category),
        );
      },
    );
  }
}
