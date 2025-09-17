import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DailyCalorieProgressWidget extends StatelessWidget {
  final int consumedCalories;
  final int targetCalories;
  final VoidCallback onTap;

  const DailyCalorieProgressWidget({
    Key? key,
    required this.consumedCalories,
    required this.targetCalories,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress = targetCalories > 0
        ? (consumedCalories / targetCalories).clamp(0.0, 1.0)
        : 0.0;
    final int remainingCalories =
        (targetCalories - consumedCalories).clamp(0, targetCalories);

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
          children: [
            Text(
              'Calorías Diarias',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$consumedCalories',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'de $targetCalories',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Restantes',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '$remainingCalories kcal',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: progress >= 1.0
                        ? AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    progress >= 1.0
                        ? 'Excedido'
                        : '${(progress * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: progress >= 1.0
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
