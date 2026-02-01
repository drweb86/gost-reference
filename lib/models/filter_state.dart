/// Represents the current filter state for the category list.
class FilterState {
  /// Text to filter category titles (case-insensitive contains match)
  final String textFilter;

  /// Three-state filter for IsIndependent:
  /// - null: show all
  /// - true: show only independent publications
  /// - false: show only non-independent publications
  final bool? isIndependentFilter;

  const FilterState({
    this.textFilter = '',
    this.isIndependentFilter,
  });

  FilterState copyWith({
    String? textFilter,
    bool? isIndependentFilter,
    bool clearIsIndependent = false,
  }) {
    return FilterState(
      textFilter: textFilter ?? this.textFilter,
      isIndependentFilter:
          clearIsIndependent ? null : (isIndependentFilter ?? this.isIndependentFilter),
    );
  }
}
