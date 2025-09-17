import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoalsPreferencesStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String selectedWeightGoal;
  final List<String> selectedDietaryPreferences;
  final Map<String, bool> notificationPreferences;
  final Function(String) onWeightGoalChanged;
  final Function(String) onDietaryPreferenceToggled;
  final Function(String, bool) onNotificationPreferenceChanged;

  const GoalsPreferencesStep({
    Key? key,
    required this.formKey,
    required this.selectedWeightGoal,
    required this.selectedDietaryPreferences,
    required this.notificationPreferences,
    required this.onWeightGoalChanged,
    required this.onDietaryPreferenceToggled,
    required this.onNotificationPreferenceChanged,
  }) : super(key: key);

  @override
  State<GoalsPreferencesStep> createState() => _GoalsPreferencesStepState();
}

class _GoalsPreferencesStepState extends State<GoalsPreferencesStep> {
  final List<Map<String, dynamic>> weightGoals = [
    {
      'id': 'lose',
      'title': 'Perder Peso',
      'description': 'Reducir peso de forma saludable',
      'icon': 'trending_down',
      'color': Colors.red,
    },
    {
      'id': 'maintain',
      'title': 'Mantener Peso',
      'description': 'Conservar peso actual',
      'icon': 'trending_flat',
      'color': Colors.blue,
    },
    {
      'id': 'gain',
      'title': 'Ganar Peso',
      'description': 'Aumentar peso de forma saludable',
      'icon': 'trending_up',
      'color': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> dietaryPreferences = [
    {
      'id': 'vegetarian',
      'title': 'Vegetariano',
      'icon': 'eco',
      'color': Colors.green,
    },
    {
      'id': 'vegan',
      'title': 'Vegano',
      'icon': 'nature',
      'color': Colors.lightGreen,
    },
    {
      'id': 'keto',
      'title': 'Cetogénica',
      'icon': 'local_fire_department',
      'color': Colors.orange,
    },
    {
      'id': 'paleo',
      'title': 'Paleo',
      'icon': 'restaurant',
      'color': Colors.brown,
    },
    {
      'id': 'mediterranean',
      'title': 'Mediterránea',
      'icon': 'water_drop',
      'color': Colors.blue,
    },
    {
      'id': 'gluten_free',
      'title': 'Sin Gluten',
      'icon': 'no_food',
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> notificationTypes = [
    {
      'id': 'meal_reminders',
      'title': 'Recordatorios de Comidas',
      'description': 'Te recordaremos cuando sea hora de comer',
      'icon': 'restaurant_menu',
    },
    {
      'id': 'water_reminders',
      'title': 'Recordatorios de Hidratación',
      'description': 'Mantente hidratado durante el día',
      'icon': 'local_drink',
    },
    {
      'id': 'exercise_reminders',
      'title': 'Recordatorios de Ejercicio',
      'description': 'Motivación para mantenerte activo',
      'icon': 'fitness_center',
    },
    {
      'id': 'health_tips',
      'title': 'Consejos de Salud',
      'description': 'Tips diarios para una vida más saludable',
      'icon': 'lightbulb',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Objetivos y Preferencias',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Personaliza tu experiencia según tus objetivos y preferencias',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Weight Goal Selection
          Text(
            'Objetivo de Peso',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),

          ...weightGoals
              .map((goal) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () => widget.onWeightGoalChanged(goal['id']),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.selectedWeightGoal == goal['id']
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.outline,
                            width:
                                widget.selectedWeightGoal == goal['id'] ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: widget.selectedWeightGoal == goal['id']
                              ? AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: widget.selectedWeightGoal == goal['id']
                                    ? goal['color']
                                    : AppTheme.lightTheme.colorScheme
                                        .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: goal['icon'],
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal['title'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: widget.selectedWeightGoal ==
                                              goal['id']
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    goal['description'],
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (widget.selectedWeightGoal == goal['id'])
                              CustomIconWidget(
                                iconName: 'check_circle',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),

          SizedBox(height: 3.h),

          // Dietary Preferences
          Text(
            'Preferencias Dietéticas',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Selecciona todas las que apliquen',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: dietaryPreferences.map((preference) {
              final isSelected =
                  widget.selectedDietaryPreferences.contains(preference['id']);
              return InkWell(
                onTap: () =>
                    widget.onDietaryPreferenceToggled(preference['id']),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme
                            .lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: preference['icon'],
                        color: isSelected ? Colors.white : preference['color'],
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        preference['title'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Notification Preferences
          Text(
            'Preferencias de Notificaciones',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),

          ...notificationTypes
              .map((notification) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.lightTheme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: notification['icon'],
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification['title'],
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                notification['description'],
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: widget.notificationPreferences[
                                  notification['id']] ??
                              false,
                          onChanged: (value) {
                            widget.onNotificationPreferenceChanged(
                                notification['id'], value);
                          },
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
