import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PopulationHealthWidget extends StatelessWidget {
  final List<Map<String, dynamic>> outcomeStats;
  final double adherenceRate;

  const PopulationHealthWidget({
    Key? key,
    required this.outcomeStats,
    required this.adherenceRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Salud Poblacional',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Outcome trends chart
            Container(
              height: 25.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < outcomeStats.length) {
                            return Text(
                              outcomeStats[value.toInt()]['month'],
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (outcomeStats.length - 1).toDouble(),
                  minY: 0,
                  maxY: 50,
                  lineBarsData: [
                    // Improved line
                    LineChartBarData(
                      spots: outcomeStats.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            entry.value['improved'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                    ),
                    // Stable line
                    LineChartBarData(
                      spots: outcomeStats.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            entry.value['stable'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                    // Declined line
                    LineChartBarData(
                      spots: outcomeStats.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(),
                            entry.value['declined'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('Mejorados', Colors.green),
                _buildLegendItem('Estables', Colors.blue),
                _buildLegendItem('Empeorados', Colors.red),
              ],
            ),

            SizedBox(height: 3.h),

            // Key statistics
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tasa de Adherencia',
                    '${(adherenceRate * 100).round()}%',
                    Colors.purple,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildStatCard(
                    'Tendencia Mes Actual',
                    '+${outcomeStats.last['improved']}',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
