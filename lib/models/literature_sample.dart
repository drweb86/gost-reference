import 'package:xml/xml.dart';

/// Represents a single bibliography category with its examples.
/// Equivalent to WPF's LiteratureSample class.
class LiteratureSample {
  /// Whether this is an independent publication (самостоятельное издание)
  final bool isIndependent;

  /// The category title displayed in the list
  final String title;

  /// List of bibliography format examples for this category
  final List<String> samples;

  const LiteratureSample({
    required this.isIndependent,
    required this.title,
    required this.samples,
  });

  /// Factory constructor to create from XML element
  factory LiteratureSample.fromXml(XmlElement element) {
    return LiteratureSample(
      isIndependent: element
              .findElements('IsIndependent')
              .first
              .innerText
              .toLowerCase() ==
          'true',
      title: element.findElements('Title').first.innerText,
      samples: element
          .findElements('Samples')
          .first
          .findElements('string')
          .map((e) => e.innerText)
          .toList(),
    );
  }
}
