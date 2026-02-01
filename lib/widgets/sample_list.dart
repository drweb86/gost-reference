import 'package:flutter/material.dart';
import 'sample_tile.dart';

/// List of samples for the selected category.
/// Equivalent to WPF's Grid.Row="4" ListBox.
class SampleList extends StatelessWidget {
  final List<String> samples;
  final Function(String) onCopy;

  const SampleList({
    super.key,
    required this.samples,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return const Center(
        child: Text('Выберите категорию для просмотра примеров'),
      );
    }

    return ListView.builder(
      itemCount: samples.length,
      itemBuilder: (context, index) {
        return SampleTile(
          sample: samples[index],
          onCopy: () => onCopy(samples[index]),
        );
      },
    );
  }
}
