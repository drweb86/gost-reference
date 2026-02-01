import 'package:xml/xml.dart';
import 'literature_sample.dart';

/// Container for all literature samples.
/// Equivalent to WPF's LiteratureData class.
class LiteratureData {
  final List<LiteratureSample> literatureSamples;

  const LiteratureData({required this.literatureSamples});

  /// Factory constructor to create from XML document
  factory LiteratureData.fromXml(XmlDocument document) {
    final samples = document
        .findAllElements('LiteratureSample')
        .map((e) => LiteratureSample.fromXml(e))
        .toList();
    return LiteratureData(literatureSamples: samples);
  }
}
