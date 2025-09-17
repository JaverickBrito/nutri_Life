import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthMetricsSectionWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onEdit;

  const HealthMetricsSectionWidget({
    Key? key,
    required this.userData,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Métricas de Salud',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Edad',
                    '${userData['age']} años',
                    'cake',
                    AppTheme.lightTheme.colorScheme.secondary,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildMetricCard(
                    'Altura',
                    '${userData['height']} cm',
                    'height',
                    AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    'Peso',
                    '${userData['weight']} kg',
                    'monitor_weight',
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildMetricCard(
                    'Actividad',
                    userData['activityLevel'],
                    'fitness_center',
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // BMI calculation
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Índice de Masa Corporal (IMC)',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _calculateBMI().toStringAsFixed(1),
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _getBMICategory(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String iconName, Color color) {
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
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  double _calculateBMI() {
    final weight = userData['weight'] as int;
    final height = userData['height'] as int;
    return weight / ((height / 100) * (height / 100));
  }

  String _getBMICategory() {
    final bmi = _calculateBMI();
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Peso normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }
}
