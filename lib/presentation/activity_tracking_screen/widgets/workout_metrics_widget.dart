import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WorkoutMetricsWidget extends StatelessWidget {
  final Duration duration;
  final int heartRate;
  final double calories;
  final double distance;
  final String exerciseType;

  const WorkoutMetricsWidget({
    Key? key,
    required this.duration,
    required this.heartRate,
    required this.calories,
    required this.distance,
    required this.exerciseType,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  String _getDistanceUnit() {
    switch (exerciseType) {
      case 'running':
      case 'cycling':
        return 'km';
      case 'strength':
        return 'reps';
      case 'yoga':
        return 'poses';
      default:
        return 'km';
    }
  }

  IconData _getExerciseIcon() {
    switch (exerciseType) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.pedal_bike;
      case 'strength':
        return Icons.fitness_center;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(77),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Workout Status Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getExerciseIcon(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workout Active',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      exerciseType.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(179),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 12.sp,
                height: 12.sp,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(77),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 3.h,
            childAspectRatio: 1.3,
            children: [
              _buildMetricCard(
                context,
                title: 'Duration',
                value: _formatDuration(duration),
                icon: 'schedule',
                color: const Color(0xFF3498DB),
              ),
              _buildMetricCard(
                context,
                title: 'Heart Rate',
                value: heartRate > 0 ? '${heartRate} bpm' : '--',
                icon: 'favorite',
                color: const Color(0xFFE74C3C),
              ),
              _buildMetricCard(
                context,
                title: 'Calories',
                value: '${calories.toStringAsFixed(1)} cal',
                icon: 'local_fire_department',
                color: const Color(0xFFF39C12),
              ),
              _buildMetricCard(
                context,
                title: _getDistanceUnit() == 'km'
                    ? 'Distance'
                    : _getDistanceUnit() == 'reps'
                        ? 'Reps'
                        : 'Poses',
                value: exerciseType == 'strength'
                    ? '${(distance * 100).toInt()} reps'
                    : exerciseType == 'yoga'
                        ? '${(distance * 50).toInt()} poses'
                        : '${distance.toStringAsFixed(2)} km',
                icon: exerciseType == 'running' || exerciseType == 'cycling'
                    ? 'straighten'
                    : exerciseType == 'strength'
                        ? 'fitness_center'
                        : 'self_improvement',
                color: const Color(0xFF27AE60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(
          color: color.withAlpha(77),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: icon,
            size: 28.sp,
            color: color,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}