import 'package:url_launcher/url_launcher.dart' as launcher;

/// Service for launching external URLs in browser.
/// Equivalent to WPF's ExternalBrowserHyperlink.
class UrlLauncherService {
  /// Opens the given URL in the default browser.
  Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      return await launcher.launchUrl(uri,
          mode: launcher.LaunchMode.externalApplication);
    }
    return false;
  }
}
