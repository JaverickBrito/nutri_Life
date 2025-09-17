import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickAddMenuWidget extends StatelessWidget {
  final VoidCallback onAddMeal;
  final VoidCallback onAddWater;
  final VoidCallback onAddExercise;
  final VoidCallback onAddWeight;
  final VoidCallback onClose;

  const QuickAddMenuWidget({
    Key? key,
    required this.onAddMeal,
    required this.onAddWater,
    required this.onAddExercise,
    required this.onAddWeight,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 3.h),
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Agregar Rápido',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Quick action buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: 'camera_alt',
                  label: 'Foto de\nComida',
                  color: Colors.orange,
                  onTap: onAddMeal,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  icon: 'water_drop',
                  label: 'Agua',
                  color: Colors.blue,
                  onTap: onAddWater,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: 'fitness_center',
                  label: 'Ejercicio',
                  color: Colors.green,
                  onTap: onAddExercise,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  icon: 'monitor_weight',
                  label: 'Peso',
                  color: Colors.purple,
                  onTap: onAddWeight,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // Recent actions
          _buildRecentActions(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActions() {
    final List<Map<String, dynamic>> recentActions = [
      {
        'icon': 'restaurant',
        'label': 'Almuerzo de ayer',
        'subtitle': 'Pollo con arroz - 450 kcal',
        'color': Colors.orange,
      },
      {
        'icon': 'directions_run',
        'label': 'Correr 30 min',
        'subtitle': 'Actividad frecuente',
        'color': Colors.green,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones Recientes',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        ...recentActions
            .map((action) => _buildRecentActionItem(action))
            .toList(),
      ],
    );
  }

  Widget _buildRecentActionItem(Map<String, dynamic> action) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: (action['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: action['icon'] as String,
                color: action['color'] as Color,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action['label'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  action['subtitle'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'add_circle_outline',
            color: action['color'] as Color,
            size: 20,
          ),
        ],
      ),
    );
  }
}
