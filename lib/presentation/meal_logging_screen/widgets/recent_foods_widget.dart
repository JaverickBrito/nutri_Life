import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentFoodsWidget extends StatelessWidget {
  final Function(String) onFoodSelected;

  const RecentFoodsWidget({
    Key? key,
    required this.onFoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentFoods = [
      {
        "name": "Café con leche",
        "calories": 90,
        "icon": "local_cafe",
        "lastUsed": "Ayer"
      },
      {
        "name": "Pan tostado",
        "calories": 120,
        "icon": "bakery_dining",
        "lastUsed": "Hace 2 días"
      },
      {
        "name": "Plátano",
        "calories": 105,
        "icon": "eco",
        "lastUsed": "Hace 3 días"
      },
      {
        "name": "Yogur griego",
        "calories": 150,
        "icon": "icecream",
        "lastUsed": "Hace 1 semana"
      },
      {
        "name": "Almendras",
        "calories": 160,
        "icon": "grain",
        "lastUsed": "Hace 1 semana"
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
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
                'Alimentos Recientes',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to full recent foods list
                },
                child: Text(
                  'Ver todos',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recentFoods.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final food = recentFoods[index];
                return GestureDetector(
                  onTap: () => onFoodSelected(food["name"] as String),
                  child: Container(
                    width: 20.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: food["icon"] as String,
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          food["name"] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${food["calories"]} kcal',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
