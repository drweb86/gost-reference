import 'package:flutter/material.dart';

/// EULA acceptance dialog shown on first launch.
class EulaDialog extends StatelessWidget {
  final String licenseText;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const EulaDialog({
    super.key,
    required this.licenseText,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Лицензионное соглашение'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Text(licenseText),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onDecline,
          child: const Text('Нет'),
        ),
        ElevatedButton(
          onPressed: onAccept,
          child: const Text('Да'),
        ),
      ],
    );
  }
}
