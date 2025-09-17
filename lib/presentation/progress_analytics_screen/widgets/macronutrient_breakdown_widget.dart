import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MacronutrientBreakdownWidget extends StatefulWidget {
  final String dateRange;

  const MacronutrientBreakdownWidget({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  @override
  State<MacronutrientBreakdownWidget> createState() =>
      _MacronutrientBreakdownWidgetState();
}

class _MacronutrientBreakdownWidgetState
    extends State<MacronutrientBreakdownWidget> {
  int touchedIndex = -1;

  Map<String, double> _getMacroData() {
    // Mock data based on date range
    switch (widget.dateRange) {
      case 'week':
        return {
          'protein': 112.5,
          'carbs': 185.3,
          'fat': 68.2,
          'fiber': 28.5,
        };
      case 'month':
        return {
          'protein': 108.7,
          'carbs': 192.1,
          'fat': 71.3,
          'fiber': 26.8,
        };
      case '3months':
        return {
          'protein': 105.2,
          'carbs': 198.7,
          'fat': 74.1,
          'fiber': 25.3,
        };
      case 'year':
        return {
          'protein': 102.8,
          'carbs': 205.2,
          'fat': 76.8,
          'fiber': 24.1,
        };
      default:
        return {
          'protein': 112.5,
          'carbs': 185.3,
          'fat': 68.2,
          'fiber': 28.5,
        };
    }
  }

  Map<String, Color> _getMacroColors() {
    return {
      'protein': const Color(0xFFE74C3C),
      'carbs': const Color(0xFF3498DB),
      'fat': const Color(0xFFF39C12),
      'fiber': const Color(0xFF27AE60),
    };
  }

  Map<String, String> _getMacroLabels() {
    return {
      'protein': 'Protein',
      'carbs': 'Carbs',
      'fat': 'Fat',
      'fiber': 'Fiber',
    };
  }

  Map<String, double> _getMacroGoals() {
    return {
      'protein': 120.0,
      'carbs': 200.0,
      'fat': 65.0,
      'fiber': 30.0,
    };
  }

  List<PieChartSectionData> _getPieChartSections() {
    final macroData = _getMacroData();
    final macroColors = _getMacroColors();
    final macroLabels = _getMacroLabels();

    // Calculate total calories
    final totalCalories = macroData['protein']! * 4 +
        macroData['carbs']! * 4 +
        macroData['fat']! * 9;

    List<PieChartSectionData> sections = [];
    int index = 0;

    macroData.forEach((key, value) {
      if (key == 'fiber') return; // Skip fiber for pie chart

      double calories = key == 'fat' ? value * 9 : value * 4;
      double percentage = (calories / totalCalories) * 100;

      final isTouched = index == touchedIndex;
      final radius = isTouched ? 15.w : 12.w;

      sections.add(
        PieChartSectionData(
          color: macroColors[key]!,
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isTouched ? 12.sp : 10.sp,
              ),
          badgeWidget: isTouched
              ? Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    border: Border.all(color: macroColors[key]!, width: 2),
                  ),
                  child: Text(
                    '${value.toStringAsFixed(1)}g',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: macroColors[key]!,
                        ),
                  ),
                )
              : null,
          badgePositionPercentageOffset: 1.3,
        ),
      );
      index++;
    });

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final macroData = _getMacroData();
    final macroColors = _getMacroColors();
    final macroLabels = _getMacroLabels();
    final macroGoals = _getMacroGoals();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'pie_chart',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Macronutrient Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                // Pie Chart
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 25.h,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 8.w,
                        sections: _getPieChartSections(),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                // Legend and Values
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: macroData.entries.map((entry) {
                      if (entry.key == 'fiber') {
                        return _buildFiberIndicator(
                          context,
                          entry.value,
                          macroGoals[entry.key]!,
                          macroColors[entry.key]!,
                        );
                      }

                      return _buildMacroLegendItem(
                        context,
                        macroLabels[entry.key]!,
                        entry.value,
                        macroGoals[entry.key]!,
                        macroColors[entry.key]!,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Weekly Average Progress Bars
            Text(
              'Weekly Averages',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 1.h),
            ...macroData.entries.map(
              (entry) => _buildProgressBar(
                context,
                macroLabels[entry.key]!,
                entry.value,
                macroGoals[entry.key]!,
                macroColors[entry.key]!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroLegendItem(
    BuildContext context,
    String label,
    double value,
    double goal,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${value.toStringAsFixed(1)}g',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiberIndicator(
    BuildContext context,
    double value,
    double goal,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(2.w),
      margin: EdgeInsets.only(top: 2.h),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(8.sp),
        border: Border.all(color: color.withAlpha(77)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'grass',
                size: 16.sp,
                color: color,
              ),
              SizedBox(width: 2.w),
              Text(
                'Fiber',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${value.toStringAsFixed(1)}g / ${goal.toStringAsFixed(0)}g',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    double value,
    double goal,
    Color color,
  ) {
    final percentage = (value / goal).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${value.toStringAsFixed(1)}g / ${goal.toStringAsFixed(0)}g',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 0.5.h),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withAlpha(51),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 1.h,
          ),
        ],
      ),
    );
  }
}