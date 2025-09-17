import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeightProgressChartWidget extends StatefulWidget {
  final String dateRange;

  const WeightProgressChartWidget({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  @override
  State<WeightProgressChartWidget> createState() =>
      _WeightProgressChartWidgetState();
}

class _WeightProgressChartWidgetState extends State<WeightProgressChartWidget> {
  int? touchedIndex;

  List<FlSpot> _getWeightData() {
    switch (widget.dateRange) {
      case 'week':
        return [
          FlSpot(0, 75.5),
          FlSpot(1, 75.2),
          FlSpot(2, 75.1),
          FlSpot(3, 74.9),
          FlSpot(4, 74.7),
          FlSpot(5, 74.5),
          FlSpot(6, 74.3),
        ];
      case 'month':
        return [
          FlSpot(0, 76.2),
          FlSpot(1, 75.8),
          FlSpot(2, 75.5),
          FlSpot(3, 75.1),
          FlSpot(4, 74.9),
          FlSpot(5, 74.6),
          FlSpot(6, 74.3),
        ];
      case '3months':
        return [
          FlSpot(0, 78.5),
          FlSpot(1, 77.2),
          FlSpot(2, 76.8),
          FlSpot(3, 76.1),
          FlSpot(4, 75.5),
          FlSpot(5, 74.9),
          FlSpot(6, 74.3),
        ];
      case 'year':
        return [
          FlSpot(0, 82.1),
          FlSpot(1, 80.5),
          FlSpot(2, 79.2),
          FlSpot(3, 78.1),
          FlSpot(4, 76.8),
          FlSpot(5, 75.5),
          FlSpot(6, 74.3),
        ];
      default:
        return [
          FlSpot(0, 75.5),
          FlSpot(1, 74.3),
        ];
    }
  }

  List<String> _getDateLabels() {
    switch (widget.dateRange) {
      case 'week':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'month':
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case '3months':
        return ['Jan', 'Feb', 'Mar'];
      case 'year':
        return ['Q1', 'Q2', 'Q3', 'Q4'];
      default:
        return ['Start', 'End'];
    }
  }

  double _getGoalWeight() {
    return 72.0; // Target weight
  }

  @override
  Widget build(BuildContext context) {
    final weightData = _getWeightData();
    final goalWeight = _getGoalWeight();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'monitor_weight',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Weight Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(26),
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  child: Text(
                    '${weightData.last.y.toStringAsFixed(1)} kg',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              height: 25.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(51),
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color:
                            Theme.of(context).colorScheme.outline.withAlpha(51),
                        strokeWidth: 1,
                      );
                    },
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
                        reservedSize: 30,
                        interval: 1,
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
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            '${value.toInt()}kg',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                  ),
                  minX: 0,
                  maxX: (weightData.length - 1).toDouble(),
                  minY: (weightData
                          .map((e) => e.y)
                          .reduce((a, b) => a < b ? a : b) -
                      2),
                  maxY: (weightData
                          .map((e) => e.y)
                          .reduce((a, b) => a > b ? a : b) +
                      2),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: goalWeight,
                        color: Theme.of(context).colorScheme.secondary,
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.only(right: 2.w),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                          labelResolver: (line) => 'Goal: ${goalWeight}kg',
                        ),
                      ),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            touchResponse == null ||
                            touchResponse.lineBarSpots == null) {
                          touchedIndex = null;
                          return;
                        }
                        touchedIndex = touchResponse.lineBarSpots![0].spotIndex;
                      });
                    },
                    getTouchedSpotIndicator:
                        (LineChartBarData barData, List<int> spotIndexes) {
                      return spotIndexes.map((spotIndex) {
                        return TouchedSpotIndicatorData(
                          FlLine(
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                          ),
                          FlDotData(
                            getDotPainter: (spot, percent, barData, index) =>
                                FlDotCirclePainter(
                              radius: 6,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Theme.of(context).colorScheme.surface,
                      tooltipBorder: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toStringAsFixed(1)} kg',
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ) ??
                                TextStyle(),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightData,
                      isCurved: true,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary.withAlpha(204),
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          if (index == touchedIndex) {
                            return FlDotCirclePainter(
                              radius: 8,
                              color: Theme.of(context).colorScheme.primary,
                              strokeWidth: 3,
                              strokeColor:
                                  Theme.of(context).colorScheme.surface,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: Theme.of(context).colorScheme.surface,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary.withAlpha(77),
                            Theme.of(context).colorScheme.primary.withAlpha(13),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProgressIndicator(
                  'Progress',
                  '${(weightData.first.y - weightData.last.y).toStringAsFixed(1)} kg',
                  '↓ Lost',
                  const Color(0xFF27AE60),
                ),
                _buildProgressIndicator(
                  'Remaining',
                  '${(weightData.last.y - goalWeight).toStringAsFixed(1)} kg',
                  '→ To Goal',
                  const Color(0xFF3498DB),
                ),
                _buildProgressIndicator(
                  'Rate',
                  '${((weightData.first.y - weightData.last.y) / weightData.length * 7).toStringAsFixed(1)} kg/week',
                  '📈 Average',
                  const Color(0xFFF39C12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    String label,
    String value,
    String subtitle,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          subtitle,
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