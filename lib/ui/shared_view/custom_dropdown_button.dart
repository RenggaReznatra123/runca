import 'package:flutter/material.dart';

/// Labeled dropdown button used across forms.
class CustomDropdownButton<T> extends StatelessWidget {
  const CustomDropdownButton({
    super.key,
    this.label,
    this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.itemLabel,
    this.validator,
  });

  final String? label;
  final String? hint;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String Function(T item)? itemLabel;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel?.call(item) ?? item.toString()),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
