import 'package:flutter/material.dart';

/// Header with instructions and external link.
/// Equivalent to WPF's Grid.Row="0".
class HeaderBar extends StatelessWidget {
  final VoidCallback onWebsiteTap;

  const HeaderBar({super.key, required this.onWebsiteTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Выберите категорию документа, на который нужно сослаться:',
            ),
          ),
          TextButton(
            onPressed: onWebsiteTap,
            child: const Text('https://github.com/drweb86/gost-reference'),
          ),
        ],
      ),
    );
  }
}
