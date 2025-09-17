import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DateRangeSelectorWidget extends StatelessWidget {
  final String selectedRange;
  final Function(String) onRangeChanged;

  const DateRangeSelectorWidget({
    Key? key,
    required this.selectedRange,
    required this.onRangeChanged,
  }) : super(key: key);

  final List<Map<String, String>> _dateRanges = const [
    {'id': 'week', 'label': '7D'},
    {'id': 'month', 'label': '1M'},
    {'id': '3months', 'label': '3M'},
    {'id': 'year', 'label': '1Y'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: _dateRanges.map((range) {
          final isSelected = selectedRange == range['id'];

          return Expanded(
            child: GestureDetector(
              onTap: () => onRangeChanged(range['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                child: Text(
                  range['label']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
