import 'package:flutter/material.dart';
import '../models/filter_state.dart';
import '../models/literature_data.dart';
import '../models/literature_sample.dart';
import '../services/clipboard_service.dart';
import '../services/literature_data_service.dart';
import '../services/url_launcher_service.dart';
import '../widgets/category_list.dart';
import '../widgets/filter_bar.dart';
import '../widgets/header_bar.dart';
import '../widgets/sample_list.dart';

/// Main screen with master-detail layout.
/// Equivalent to WPF's MainWindow.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LiteratureDataService _dataService = LiteratureDataService();
  final ClipboardService _clipboardService = ClipboardService();
  final UrlLauncherService _urlLauncherService = UrlLauncherService();

  LiteratureData? _data;
  LiteratureSample? _selectedCategory;
  FilterState _filterState = const FilterState();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _dataService.load();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<LiteratureSample> get _filteredCategories {
    if (_data == null) return [];

    return _data!.literatureSamples.where((sample) {
      // Filter by IsIndependent
      if (_filterState.isIndependentFilter != null &&
          sample.isIndependent != _filterState.isIndependentFilter) {
        return false;
      }

      // Filter by text
      if (_filterState.textFilter.isNotEmpty &&
          !sample.title
              .toLowerCase()
              .contains(_filterState.textFilter.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }

  void _onCopyText(String text) async {
    final success = await _clipboardService.copyToClipboard(text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(success ? 'Скопировано в буфер обмена' : 'Ошибка копирования'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onWebsiteTap() {
    _urlLauncherService.openUrl('https://github.com/drweb86/gost-reference');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Ошибка: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Оформление ссылок по ГОСТ 7.1-2003'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeaderBar(onWebsiteTap: _onWebsiteTap),
            FilterBar(
              textFilter: _filterState.textFilter,
              isIndependentFilter: _filterState.isIndependentFilter,
              onTextChanged: (text) => setState(() {
                _filterState = _filterState.copyWith(textFilter: text);
                // Clear selection if it's no longer in filtered list
                if (_selectedCategory != null &&
                    !_filteredCategories.contains(_selectedCategory)) {
                  _selectedCategory = null;
                }
              }),
              onIsIndependentChanged: (value) => setState(() {
                _filterState = _filterState.copyWith(
                  isIndependentFilter: value,
                  clearIsIndependent: value == null,
                );
                // Clear selection if it's no longer in filtered list
                if (_selectedCategory != null &&
                    !_filteredCategories.contains(_selectedCategory)) {
                  _selectedCategory = null;
                }
              }),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: CategoryList(
                categories: _filteredCategories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) => setState(() {
                  _selectedCategory = category;
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Примеры:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SampleList(
                samples: _selectedCategory?.samples ?? [],
                onCopy: _onCopyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
