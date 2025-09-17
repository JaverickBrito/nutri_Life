import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActivitySummaryWidget extends StatelessWidget {
  final int steps;
  final int targetSteps;
  final int exerciseMinutes;
  final int targetExerciseMinutes;
  final VoidCallback onTap;

  const ActivitySummaryWidget({
    Key? key,
    required this.steps,
    required this.targetSteps,
    required this.exerciseMinutes,
    required this.targetExerciseMinutes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double stepsProgress =
        targetSteps > 0 ? (steps / targetSteps).clamp(0.0, 1.0) : 0.0;
    final double exerciseProgress = targetExerciseMinutes > 0
        ? (exerciseMinutes / targetExerciseMinutes).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actividad de Hoy',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: _buildActivityItem(
                    icon: 'directions_walk',
                    title: 'Pasos',
                    value: '$steps',
                    target: '$targetSteps',
                    progress: stepsProgress,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildActivityItem(
                    icon: 'fitness_center',
                    title: 'Ejercicio',
                    value: '${exerciseMinutes}min',
                    target: '${targetExerciseMinutes}min',
                    progress: exerciseProgress,
                    color: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            _buildMotivationalMessage(stepsProgress, exerciseProgress),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String icon,
    required String title,
    required String value,
    required String target,
    required double progress,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'de $target',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withValues(alpha: 0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalMessage(
      double stepsProgress, double exerciseProgress) {
    String message;
    Color messageColor;
    String icon;

    if (stepsProgress >= 1.0 && exerciseProgress >= 1.0) {
      message = '¡Excelente! Has completado todas tus metas de actividad';
      messageColor = AppTheme.lightTheme.colorScheme.primary;
      icon = 'emoji_events';
    } else if (stepsProgress >= 0.8 || exerciseProgress >= 0.8) {
      message = '¡Muy bien! Estás cerca de completar tus metas';
      messageColor = AppTheme.lightTheme.colorScheme.secondary;
      icon = 'trending_up';
    } else if (stepsProgress >= 0.5 || exerciseProgress >= 0.5) {
      message = 'Buen progreso, ¡sigue así!';
      messageColor = AppTheme.lightTheme.primaryColor;
      icon = 'thumb_up';
    } else {
      message = 'Es un buen momento para moverte un poco';
      messageColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
      icon = 'directions_run';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: messageColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: messageColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              message,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: messageColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
