import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExerciseHeatmapWidget extends StatelessWidget {
  final String dateRange;

  const ExerciseHeatmapWidget({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  List<List<int>> _getHeatmapData() {
    // Generate mock heatmap data for the past 7 weeks
    return [
      [0, 1, 2, 1, 3, 0, 2], // Week 1
      [2, 1, 0, 2, 1, 3, 1], // Week 2
      [1, 3, 1, 0, 2, 1, 2], // Week 3
      [0, 2, 3, 1, 1, 2, 0], // Week 4
      [3, 1, 2, 2, 0, 1, 3], // Week 5
      [1, 2, 1, 3, 2, 0, 1], // Week 6
      [2, 0, 1, 1, 3, 2, 1], // Week 7
    ];
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 0:
        return const Color(0xFFE8F5E8);
      case 1:
        return const Color(0xFF98D982);
      case 2:
        return const Color(0xFF52C234);
      case 3:
        return const Color(0xFF0F7B0F);
      default:
        return const Color(0xFFE8F5E8);
    }
  }

  String _getIntensityLabel(int intensity) {
    switch (intensity) {
      case 0:
        return 'No activity';
      case 1:
        return 'Light activity';
      case 2:
        return 'Moderate activity';
      case 3:
        return 'Intense activity';
      default:
        return 'No activity';
    }
  }

  @override
  Widget build(BuildContext context) {
    final heatmapData = _getHeatmapData();
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_view_week',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Activity Heatmap',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Spacer(),
                Text(
                  'Last 7 weeks',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Day labels
            Row(
              children: [
                SizedBox(width: 8.w), // Space for week labels
                ...weekDays.map((day) => Expanded(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
            SizedBox(height: 1.h),
            // Heatmap grid
            Column(
              children: heatmapData.asMap().entries.map((weekEntry) {
                final weekIndex = weekEntry.key;
                final weekData = weekEntry.value;

                return Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      // Week label
                      SizedBox(
                        width: 8.w,
                        child: Text(
                          'W${weekIndex + 1}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(153),
                                  ),
                        ),
                      ),
                      // Heatmap cells
                      ...weekData.map((intensity) => Expanded(
                            child: GestureDetector(
                              onTap: () => _showDayDetail(context, weekIndex,
                                  weekData.indexOf(intensity), intensity),
                              child: Container(
                                height: 6.w,
                                margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                                decoration: BoxDecoration(
                                  color: _getIntensityColor(intensity),
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outline
                                        .withAlpha(51),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
            // Legend
            Row(
              children: [
                Text(
                  'Less',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
                SizedBox(width: 2.w),
                ...List.generate(
                    4,
                    (index) => Container(
                          width: 4.w,
                          height: 4.w,
                          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                          decoration: BoxDecoration(
                            color: _getIntensityColor(index),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        )),
                SizedBox(width: 2.w),
                Text(
                  'More',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Active Days',
                  '${heatmapData.expand((week) => week).where((day) => day > 0).length}',
                  'out of ${heatmapData.length * 7}',
                ),
                _buildStatItem(
                  context,
                  'Current Streak',
                  '5',
                  'days',
                ),
                _buildStatItem(
                  context,
                  'Best Week',
                  'Week 3',
                  '18 points',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String subtitle,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
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

  void _showDayDetail(BuildContext context, int week, int day, int intensity) {
    final weekDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.sp),
        ),
        title: Text('Week ${week + 1} - ${weekDays[day]}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: _getIntensityColor(intensity),
                borderRadius: BorderRadius.circular(8.sp),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: _getIntensityColor(intensity),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withAlpha(128),
                        width: 1,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    _getIntensityLabel(intensity),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            if (intensity > 0) ...[
              SizedBox(height: 2.h),
              Text(
                'Activities:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 1.h),
              ...List.generate(
                  intensity,
                  (index) => Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Text(
                          '• ${[
                            "Morning run",
                            "Evening yoga",
                            "Strength training"
                          ][index]}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}