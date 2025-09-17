import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MealSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedFoods;
  final Function(int) onRemoveFood;
  final VoidCallback onSaveMeal;

  const MealSummaryWidget({
    Key? key,
    required this.selectedFoods,
    required this.onRemoveFood,
    required this.onSaveMeal,
  }) : super(key: key);

  double get totalCalories {
    return selectedFoods.fold(
        0.0, (sum, food) => sum + (food['calories'] as double));
  }

  double get totalProtein {
    return selectedFoods.fold(
        0.0, (sum, food) => sum + (food['protein'] as double));
  }

  double get totalCarbs {
    return selectedFoods.fold(
        0.0, (sum, food) => sum + (food['carbs'] as double));
  }

  double get totalFats {
    return selectedFoods.fold(
        0.0, (sum, food) => sum + (food['fats'] as double));
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFoods.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resumen de la comida',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${selectedFoods.length} ${selectedFoods.length == 1 ? 'alimento' : 'alimentos'}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Nutritional Summary Cards
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildNutrientCard(
                    'Calorías',
                    '${totalCalories.toStringAsFixed(0)}',
                    'kcal',
                    'local_fire_department',
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildNutrientCard(
                    'Proteína',
                    '${totalProtein.toStringAsFixed(1)}',
                    'g',
                    'fitness_center',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildNutrientCard(
                    'Carbos',
                    '${totalCarbs.toStringAsFixed(1)}',
                    'g',
                    'grain',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildNutrientCard(
                    'Grasas',
                    '${totalFats.toStringAsFixed(1)}',
                    'g',
                    'opacity',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Food Items List
          Text(
            'Alimentos seleccionados',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          Container(
            constraints: BoxConstraints(maxHeight: 25.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: selectedFoods.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final food = selectedFoods[index];
                return Dismissible(
                  key: Key('${food['name']}_$index'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => onRemoveFood(index),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'delete',
                      color: AppTheme.lightTheme.colorScheme.onError,
                      size: 24,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'restaurant',
                              color: AppTheme.lightTheme.colorScheme.primary,
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
                                food['name'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                '${food['quantity']} ${food['unit']}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${(food['calories'] as double).toStringAsFixed(0)} kcal',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              'P: ${(food['protein'] as double).toStringAsFixed(1)}g',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 2.w),
                        GestureDetector(
                          onTap: () => onRemoveFood(index),
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 4.h),

          // Save Meal Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSaveMeal,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'save',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Guardar Comida',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(
      String label, String value, String unit, String iconName, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            unit,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: color,
              fontSize: 8.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontSize: 9.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
