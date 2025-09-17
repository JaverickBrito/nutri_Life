import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GoalAchievementWidget extends StatelessWidget {
  final String dateRange;

  const GoalAchievementWidget({
    Key? key,
    required this.dateRange,
  }) : super(key: key);

  List<Map<String, dynamic>> _getGoalData() {
    return [
      {
        'id': 'weight_loss',
        'title': 'Weight Loss Goal',
        'target': 75.0,
        'current': 74.3,
        'unit': 'kg',
        'progress': 0.87,
        'icon': 'monitor_weight',
        'color': const Color(0xFF27AE60),
        'isCompleted': false,
        'timeframe': '3 months',
      },
      {
        'id': 'daily_steps',
        'title': 'Daily Steps',
        'target': 10000.0,
        'current': 8247.0,
        'unit': 'steps',
        'progress': 0.82,
        'icon': 'directions_walk',
        'color': const Color(0xFF3498DB),
        'isCompleted': false,
        'timeframe': 'Daily',
      },
      {
        'id': 'workout_frequency',
        'title': 'Weekly Workouts',
        'target': 4.0,
        'current': 5.0,
        'unit': 'sessions',
        'progress': 1.0,
        'icon': 'fitness_center',
        'color': const Color(0xFFE74C3C),
        'isCompleted': true,
        'timeframe': 'Weekly',
      },
      {
        'id': 'water_intake',
        'title': 'Daily Water Intake',
        'target': 2.5,
        'current': 2.1,
        'unit': 'liters',
        'progress': 0.84,
        'icon': 'water_drop',
        'color': const Color(0xFF1ABC9C),
        'isCompleted': false,
        'timeframe': 'Daily',
      },
      {
        'id': 'sleep_duration',
        'title': 'Sleep Goal',
        'target': 8.0,
        'current': 7.5,
        'unit': 'hours',
        'progress': 0.94,
        'icon': 'bedtime',
        'color': const Color(0xFF9B59B6),
        'isCompleted': false,
        'timeframe': 'Nightly',
      },
    ];
  }

  double _getOverallProgress() {
    final goals = _getGoalData();
    double totalProgress = 0;

    for (final goal in goals) {
      totalProgress += (goal['progress'] as double).clamp(0.0, 1.0);
    }

    return totalProgress / goals.length;
  }

  @override
  Widget build(BuildContext context) {
    final goals = _getGoalData();
    final overallProgress = _getOverallProgress();
    final completedGoals =
        goals.where((goal) => goal['isCompleted'] == true).length;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'target',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Goal Achievement',
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
                    '${(overallProgress * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            // Overall progress indicator
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withAlpha(26),
                    Theme.of(context).colorScheme.primary.withAlpha(13),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.sp),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overall Progress',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '$completedGoals of ${goals.length} goals completed',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(179),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20.w,
                        height: 20.w,
                        child: Stack(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                value: overallProgress,
                                strokeWidth: 1.5.h,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withAlpha(51),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                '${(overallProgress * 100).toStringAsFixed(0)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            // Individual goals
            Text(
              'Individual Goals',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 2.h),
            Column(
              children:
                  goals.map((goal) => _buildGoalItem(context, goal)).toList(),
            ),
            SizedBox(height: 2.h),
            // Achievement stats
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12.sp),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Completed',
                    completedGoals.toString(),
                    'goals',
                    const Color(0xFF27AE60),
                  ),
                  _buildStatItem(
                    context,
                    'In Progress',
                    (goals.length - completedGoals).toString(),
                    'goals',
                    const Color(0xFF3498DB),
                  ),
                  _buildStatItem(
                    context,
                    'Avg Progress',
                    '${(overallProgress * 100).toStringAsFixed(0)}%',
                    'completion',
                    const Color(0xFFF39C12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, Map<String, dynamic> goal) {
    final progress = (goal['progress'] as double).clamp(0.0, 1.0);
    final isCompleted = goal['isCompleted'] as bool;
    final color = goal['color'] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? color.withAlpha(26)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(
          color: isCompleted
              ? color.withAlpha(77)
              : Theme.of(context).colorScheme.outline.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: CustomIconWidget(
                  iconName: goal['icon'],
                  size: 20.sp,
                  color: color,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            goal['title'],
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted ? color : null,
                                ),
                          ),
                        ),
                        if (isCompleted)
                          CustomIconWidget(
                            iconName: 'check_circle',
                            size: 20.sp,
                            color: color,
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${goal['current']} / ${goal['target']} ${goal['unit']} • ${goal['timeframe']}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(179),
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withAlpha(51),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 1.h,
          ),
        ],
      ),
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
          value,
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