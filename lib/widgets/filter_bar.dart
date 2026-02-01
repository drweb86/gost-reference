import 'package:flutter/material.dart';

/// Filter bar with text input and three-state checkbox.
/// Equivalent to WPF's filter section in Grid.Row="1".
class FilterBar extends StatelessWidget {
  final String textFilter;
  final bool? isIndependentFilter;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<bool?> onIsIndependentChanged;

  const FilterBar({
    super.key,
    required this.textFilter,
    required this.isIndependentFilter,
    required this.onTextChanged,
    required this.onIsIndependentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('Фильтр (введите фрагменты категории):'),
          SizedBox(
            width: 250,
            child: TextField(
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: OutlineInputBorder(),
              ),
              onChanged: onTextChanged,
            ),
          ),
          _ThreeStateCheckbox(
            value: isIndependentFilter,
            onChanged: onIsIndependentChanged,
            label: 'Самостоятельное издание',
          ),
        ],
      ),
    );
  }
}

/// Custom three-state checkbox widget.
class _ThreeStateCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const _ThreeStateCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          tristate: true,
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
