import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WaterIntakeWidget extends StatelessWidget {
  final int currentIntake;
  final int targetIntake;
  final VoidCallback onIncrement;

  const WaterIntakeWidget({
    Key? key,
    required this.currentIntake,
    required this.targetIntake,
    required this.onIncrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progress =
        targetIntake > 0 ? (currentIntake / targetIntake).clamp(0.0, 1.0) : 0.0;
    final int remainingGlasses =
        (targetIntake - currentIntake).clamp(0, targetIntake);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hidratación',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: AppTheme.lightTheme.colorScheme.onSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$currentIntake',
                          style: AppTheme.lightTheme.textTheme.headlineLarge
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: Text(
                            '/ $targetIntake vasos',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.secondary),
                      minHeight: 6,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      remainingGlasses > 0
                          ? 'Faltan $remainingGlasses vasos'
                          : '¡Meta completada!',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: remainingGlasses > 0
                            ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            : AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: remainingGlasses > 0
                            ? FontWeight.w400
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 1,
                child: _buildWaterGlassVisualization(progress),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildWaterGlassVisualization(double progress) {
    return Container(
      height: 20.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Glass outline
          Container(
            width: 15.w,
            height: 18.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.3),
                width: 2,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ),
          // Water fill
          AnimatedContainer(
            duration: Duration(milliseconds: 500),
            width: 13.w,
            height: (16.h * progress),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
                topLeft: progress > 0.9 ? Radius.circular(2) : Radius.zero,
                topRight: progress > 0.9 ? Radius.circular(2) : Radius.zero,
              ),
            ),
          ),
          // Water icon
          Positioned(
            top: 0,
            child: CustomIconWidget(
              iconName: 'water_drop',
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            label: '+1 Vaso',
            icon: 'local_drink',
            onTap: onIncrement,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: _buildQuickActionButton(
            label: '+250ml',
            icon: 'opacity',
            onTap: onIncrement,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
