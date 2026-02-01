import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';
import '../models/literature_data.dart';

/// Service for loading and parsing literature data from XML asset.
/// Equivalent to WPF's LiteratureDataHelper.
class LiteratureDataService {
  static const String _assetPath = 'assets/data.xml';

  /// Loads and parses the literature data from the embedded XML asset.
  /// Throws [LiteratureDataException] if data is invalid.
  Future<LiteratureData> load() async {
    final xmlString = await rootBundle.loadString(_assetPath);
    final document = XmlDocument.parse(xmlString);
    final data = LiteratureData.fromXml(document);

    _verifyData(data);
    return data;
  }

  /// Validates the loaded data structure.
  void _verifyData(LiteratureData data) {
    if (data.literatureSamples.isEmpty) {
      throw LiteratureDataException('LiteratureSamples is empty.');
    }

    for (final sample in data.literatureSamples) {
      if (sample.title.trim().isEmpty) {
        throw LiteratureDataException("'Title' is empty or missing.");
      }
      if (sample.samples.isEmpty) {
        throw LiteratureDataException(
            "${sample.title}: 'Samples' does not contain samples.");
      }
    }
  }
}

class LiteratureDataException implements Exception {
  final String message;
  LiteratureDataException(this.message);

  @override
  String toString() => 'LiteratureDataException: $message';
}
