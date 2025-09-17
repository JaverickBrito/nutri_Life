import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MealsSummaryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> todayMeals;
  final VoidCallback onAddMeal;

  const MealsSummaryWidget({
    Key? key,
    required this.todayMeals,
    required this.onAddMeal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Comidas de Hoy',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onAddMeal,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Agregar',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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
          SizedBox(height: 2.h),
          todayMeals.isEmpty ? _buildEmptyState() : _buildMealsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'restaurant',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 1.h),
          Text(
            'No has registrado comidas hoy',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Toca "Agregar" para comenzar',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList() {
    return Column(
      children: [
        ...todayMeals.take(3).map((meal) => _buildMealItem(meal)).toList(),
        if (todayMeals.length > 3)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              '+${todayMeals.length - 3} comidas más',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMealItem(Map<String, dynamic> meal) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getMealTypeColor(meal['type'] as String)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getMealTypeIcon(meal['type'] as String),
                color: _getMealTypeColor(meal['type'] as String),
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
                  meal['name'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${meal['calories']} kcal • ${meal['time']}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMealTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'desayuno':
        return Colors.orange;
      case 'almuerzo':
        return Colors.green;
      case 'cena':
        return Colors.blue;
      case 'snack':
        return Colors.purple;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getMealTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'desayuno':
        return 'free_breakfast';
      case 'almuerzo':
        return 'lunch_dining';
      case 'cena':
        return 'dinner_dining';
      case 'snack':
        return 'cookie';
      default:
        return 'restaurant';
    }
  }
}
