import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CalorieComparisonChartWidget extends StatelessWidget {
  final String dateRange;

  const CalorieComparisonChartWidget({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  List<BarChartGroupData> _getCalorieData() {
    final List<Map<String, double>> data = _getMockData();

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final values = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values['intake']!,
            color: const Color(0xFF3498DB),
            width: 12,
            borderRadius: BorderRadius.circular(6),
          ),
          BarChartRodData(
            toY: values['burned']!,
            color: const Color(0xFFE74C3C),
            width: 12,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  List<Map<String, double>> _getMockData() {
    switch (dateRange) {
      case 'week':
        return [
          {'intake': 1850, 'burned': 2100},
          {'intake': 1920, 'burned': 2050},
          {'intake': 1780, 'burned': 2200},
          {'intake': 1950, 'burned': 1950},
          {'intake': 1830, 'burned': 2150},
          {'intake': 2100, 'burned': 1800},
          {'intake': 1900, 'burned': 2000},
        ];
      case 'month':
        return [
          {'intake': 1875, 'burned': 2075},
          {'intake': 1825, 'burned': 2125},
          {'intake': 1900, 'burned': 2000},
          {'intake': 1850, 'burned': 2100},
        ];
      case '3months':
        return [
          {'intake': 1900, 'burned': 2050},
          {'intake': 1850, 'burned': 2100},
          {'intake': 1825, 'burned': 2125},
        ];
      case 'year':
        return [
          {'intake': 1950, 'burned': 2000},
          {'intake': 1875, 'burned': 2075},
          {'intake': 1825, 'burned': 2125},
          {'intake': 1800, 'burned': 2150},
        ];
      default:
        return [
          {'intake': 1850, 'burned': 2100},
        ];
    }
  }

  List<String> _getDateLabels() {
    switch (dateRange) {
      case 'week':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'month':
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case '3months':
        return ['Month 1', 'Month 2', 'Month 3'];
      case 'year':
        return ['Q1', 'Q2', 'Q3', 'Q4'];
      default:
        return ['Current'];
    }
  }

  double _getAverageDeficit() {
    final data = _getMockData();
    double totalDeficit = 0;

    for (final entry in data) {
      totalDeficit += (entry['burned']! - entry['intake']!);
    }

    return totalDeficit / data.length;
  }

  @override
  Widget build(BuildContext context) {
    final calorieData = _getCalorieData();
    final averageDeficit = _getAverageDeficit();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Calorie Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: averageDeficit > 0
                        ? const Color(0xFF27AE60).withAlpha(26)
                        : const Color(0xFFF39C12).withAlpha(26),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Text(
                    '${averageDeficit > 0 ? "-" : "+"}${averageDeficit.abs().toStringAsFixed(0)} cal/day',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: averageDeficit > 0
                              ? const Color(0xFF27AE60)
                              : const Color(0xFFF39C12),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  context,
                  color: const Color(0xFF3498DB),
                  label: 'Intake',
                ),
                SizedBox(width: 4.w),
                _buildLegendItem(
                  context,
                  color: const Color(0xFFE74C3C),
                  label: 'Burned',
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              height: 25.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 2500,
                  minY: 0,
                  groupsSpace: 3.w,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Theme.of(context).colorScheme.surface,
                      tooltipBorder: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final isIntake = rodIndex == 0;
                        final label = isIntake ? 'Intake' : 'Burned';
                        return BarTooltipItem(
                          '$label\n${rod.toY.toInt()} cal',
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: rod.color,
                                    fontWeight: FontWeight.bold,
                                  ) ??
                              TextStyle(),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final labels = _getDateLabels();
                          final index = value.toInt();
                          if (index >= 0 && index < labels.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                labels[index],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          }
                          return Container();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 500,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(1)}k',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(51),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(77),
                      ),
                      left: BorderSide(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(77),
                      ),
                    ),
                  ),
                  barGroups: calorieData,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Summary Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Avg Intake',
                  '${_getMockData().map((e) => e['intake']!).reduce((a, b) => a + b) / _getMockData().length}',
                  'cal/day',
                  const Color(0xFF3498DB),
                ),
                _buildStatItem(
                  context,
                  'Avg Burned',
                  '${_getMockData().map((e) => e['burned']!).reduce((a, b) => a + b) / _getMockData().length}',
                  'cal/day',
                  const Color(0xFFE74C3C),
                ),
                _buildStatItem(
                  context,
                  'Net Balance',
                  '${averageDeficit.abs()}',
                  averageDeficit > 0 ? 'deficit' : 'surplus',
                  averageDeficit > 0
                      ? const Color(0xFF27AE60)
                      : const Color(0xFFF39C12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          double.parse(value).toStringAsFixed(0),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
        ),
      ],
    );
  }
}