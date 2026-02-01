import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/eula_dialog.dart';
import 'services/eula_service.dart';

void main() {
  runApp(const GostBibliographyApp());
}

class GostBibliographyApp extends StatelessWidget {
  const GostBibliographyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Оформление ссылок по ГОСТ 7.1-2003',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EulaGate(),
    );
  }
}

/// Widget that gates access to the app behind EULA acceptance.
class EulaGate extends StatefulWidget {
  const EulaGate({super.key});

  @override
  State<EulaGate> createState() => _EulaGateState();
}

class _EulaGateState extends State<EulaGate> {
  final EulaService _eulaService = EulaService();
  bool? _eulaAccepted;
  String? _licenseText;

  @override
  void initState() {
    super.initState();
    _checkEula();
  }

  Future<void> _checkEula() async {
    final accepted = await _eulaService.isEulaAccepted();
    if (accepted) {
      setState(() => _eulaAccepted = true);
    } else {
      final licenseText = await _eulaService.loadLicenseText();
      setState(() {
        _eulaAccepted = false;
        _licenseText = licenseText;
      });
    }
  }

  void _onAccept() async {
    await _eulaService.saveEulaAccepted();
    setState(() => _eulaAccepted = true);
  }

  void _onDecline() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Text(
          'Для использования приложения необходимо принять лицензионное соглашение.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_eulaAccepted == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_eulaAccepted == true) {
      return const HomeScreen();
    }

    return Scaffold(
      body: Center(
        child: EulaDialog(
          licenseText: _licenseText ?? '',
          onAccept: _onAccept,
          onDecline: _onDecline,
        ),
      ),
    );
  }
}
