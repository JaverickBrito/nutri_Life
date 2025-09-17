import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HealthMetricsStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final int selectedAge;
  final String selectedGender;
  final double selectedHeight;
  final double selectedWeight;
  final String selectedActivityLevel;
  final Function(int) onAgeChanged;
  final Function(String) onGenderChanged;
  final Function(double) onHeightChanged;
  final Function(double) onWeightChanged;
  final Function(String) onActivityLevelChanged;

  const HealthMetricsStep({
    Key? key,
    required this.formKey,
    required this.selectedAge,
    required this.selectedGender,
    required this.selectedHeight,
    required this.selectedWeight,
    required this.selectedActivityLevel,
    required this.onAgeChanged,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onActivityLevelChanged,
  }) : super(key: key);

  @override
  State<HealthMetricsStep> createState() => _HealthMetricsStepState();
}

class _HealthMetricsStepState extends State<HealthMetricsStep> {
  final List<Map<String, dynamic>> activityLevels = [
    {
      'id': 'sedentary',
      'title': 'Sedentario',
      'description': 'Poco o ningún ejercicio',
      'icon': 'chair',
    },
    {
      'id': 'light',
      'title': 'Ligero',
      'description': 'Ejercicio ligero 1-3 días/semana',
      'icon': 'directions_walk',
    },
    {
      'id': 'moderate',
      'title': 'Moderado',
      'description': 'Ejercicio moderado 3-5 días/semana',
      'icon': 'directions_run',
    },
    {
      'id': 'active',
      'title': 'Activo',
      'description': 'Ejercicio intenso 6-7 días/semana',
      'icon': 'fitness_center',
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
            'Métricas de Salud',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Ayúdanos a personalizar tu experiencia con información básica sobre tu salud',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),

          // Age and Gender Row
          Row(
            children: [
              // Age Selection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edad',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: widget.selectedAge > 0
                              ? widget.selectedAge
                              : null,
                          hint: Text('Seleccionar'),
                          isExpanded: true,
                          items: List.generate(83, (index) => index + 18)
                              .map((age) => DropdownMenuItem<int>(
                                    value: age,
                                    child: Text('$age años'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.onAgeChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),

              // Gender Selection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Género',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: widget.selectedGender.isNotEmpty
                              ? widget.selectedGender
                              : null,
                          hint: Text('Seleccionar'),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                                value: 'male', child: Text('Masculino')),
                            DropdownMenuItem(
                                value: 'female', child: Text('Femenino')),
                            DropdownMenuItem(
                                value: 'other', child: Text('Otro')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              widget.onGenderChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Height and Weight Row
          Row(
            children: [
              // Height Selection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Altura (cm)',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          value: widget.selectedHeight > 0
                              ? widget.selectedHeight
                              : null,
                          hint: Text('Seleccionar'),
                          isExpanded: true,
                          items: List.generate(
                                  101, (index) => (index + 140).toDouble())
                              .map((height) => DropdownMenuItem<double>(
                                    value: height,
                                    child: Text('${height.toInt()} cm'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.onHeightChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),

              // Weight Selection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peso (kg)',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<double>(
                          value: widget.selectedWeight > 0
                              ? widget.selectedWeight
                              : null,
                          hint: Text('Seleccionar'),
                          isExpanded: true,
                          items: List.generate(
                                  151, (index) => (index + 40).toDouble())
                              .map((weight) => DropdownMenuItem<double>(
                                    value: weight,
                                    child: Text('${weight.toInt()} kg'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              widget.onWeightChanged(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Activity Level Selection
          Text(
            'Nivel de Actividad',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),

          ...activityLevels
              .map((level) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: InkWell(
                      onTap: () => widget.onActivityLevelChanged(level['id']),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.selectedActivityLevel == level['id']
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: widget.selectedActivityLevel == level['id']
                                ? 2
                                : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: widget.selectedActivityLevel == level['id']
                              ? AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color:
                                    widget.selectedActivityLevel == level['id']
                                        ? AppTheme.lightTheme.primaryColor
                                        : AppTheme.lightTheme.colorScheme
                                            .surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: level['icon'],
                                color:
                                    widget.selectedActivityLevel == level['id']
                                        ? Colors.white
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level['title'],
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: widget.selectedActivityLevel ==
                                              level['id']
                                          ? AppTheme.lightTheme.primaryColor
                                          : AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                    ),
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    level['description'],
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
                            if (widget.selectedActivityLevel == level['id'])
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
        ],
      ),
    );
  }
}
