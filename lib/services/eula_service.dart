import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing End User License Agreement acceptance.
/// Equivalent to WPF's EndUserLicenseAgreementHelper.
class EulaService {
  static const String _eulaAcceptedKey = 'eula_accepted';
  static const String _licenseAssetPath = 'assets/license.txt';

  /// Checks if the user has already accepted the EULA.
  Future<bool> isEulaAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_eulaAcceptedKey) ?? false;
  }

  /// Saves that the user has accepted the EULA.
  Future<void> saveEulaAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_eulaAcceptedKey, true);
  }

  /// Loads the license text from assets.
  Future<String> loadLicenseText() async {
    return await rootBundle.loadString(_licenseAssetPath);
  }
}
