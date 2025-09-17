import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalsRemindersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final List<Map<String, dynamic>> reminders;
  final Function(String) onGoalTap;
  final Function(String) onReminderTap;

  const GoalsRemindersWidget({
    Key? key,
    required this.goals,
    required this.reminders,
    required this.onGoalTap,
    required this.onReminderTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> upcomingGoals =
        goals.where((goal) => !(goal['completed'] as bool)).take(2).toList();
    final List<Map<String, dynamic>> todayReminders = reminders
        .where((reminder) => _isToday(reminder['scheduledTime'] as DateTime))
        .take(3)
        .toList();

    return Container(
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
            'Metas y Recordatorios',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          if (upcomingGoals.isNotEmpty) ...[
            _buildSectionHeader('Metas Activas', 'flag'),
            SizedBox(height: 1.h),
            ...upcomingGoals.map((goal) => _buildGoalItem(goal)).toList(),
            SizedBox(height: 2.h),
          ],
          if (todayReminders.isNotEmpty) ...[
            _buildSectionHeader('Recordatorios de Hoy', 'notifications'),
            SizedBox(height: 1.h),
            ...todayReminders
                .map((reminder) => _buildReminderItem(reminder))
                .toList(),
          ],
          if (upcomingGoals.isEmpty && todayReminders.isEmpty)
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String icon) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.primaryColor,
          size: 18,
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalItem(Map<String, dynamic> goal) {
    final double progress = (goal['progress'] as double).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => onGoalTap(goal['id'] as String),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: _getGoalCategoryColor(goal['category'] as String)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName:
                          _getGoalCategoryIcon(goal['category'] as String),
                      color: _getGoalCategoryColor(goal['category'] as String),
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal['title'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Vence: ${_formatDate(goal['dueDate'] as DateTime)}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            LinearProgressIndicator(
              value: progress,
              backgroundColor:
                  AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor),
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(Map<String, dynamic> reminder) {
    final DateTime scheduledTime = reminder['scheduledTime'] as DateTime;
    final bool isPast = DateTime.now().isAfter(scheduledTime);

    return GestureDetector(
      onTap: () => onReminderTap(reminder['id'] as String),
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isPast
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.05)
              : AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPast
                ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: isPast
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getReminderTypeIcon(reminder['type'] as String),
                  color: isPast
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.secondary,
                  size: 16,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder['title'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _formatTime(scheduledTime),
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isPast
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isPast)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Perdido',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'track_changes',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No tienes metas o recordatorios activos',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Configura tus objetivos de salud para mantenerte motivado',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getGoalCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'peso':
        return Colors.orange;
      case 'ejercicio':
        return Colors.green;
      case 'nutricion':
        return Colors.blue;
      case 'hidratacion':
        return Colors.cyan;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getGoalCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'peso':
        return 'monitor_weight';
      case 'ejercicio':
        return 'fitness_center';
      case 'nutricion':
        return 'restaurant';
      case 'hidratacion':
        return 'water_drop';
      default:
        return 'flag';
    }
  }

  String _getReminderTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'comida':
        return 'restaurant';
      case 'agua':
        return 'water_drop';
      case 'ejercicio':
        return 'fitness_center';
      case 'medicamento':
        return 'medication';
      default:
        return 'notifications';
    }
  }

  bool _isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    final int difference = date.difference(now).inDays;

    if (difference == 0) return 'Hoy';
    if (difference == 1) return 'Mañana';
    if (difference < 7) return '${difference} días';

    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
