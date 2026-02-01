import 'package:flutter/material.dart';

/// Individual sample item with copy button.
/// Equivalent to WPF's SamplesListBoxDataTemplate.
class SampleTile extends StatelessWidget {
  final String sample;
  final VoidCallback onCopy;

  const SampleTile({
    super.key,
    required this.sample,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SelectableText(
                sample,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Скопировать в буфер обмена',
              onPressed: onCopy,
            ),
          ],
        ),
      ),
    );
  }
}
