import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppPreferencesSectionWidget extends StatelessWidget {
  final Map<String, String> preferences;
  final Function(String, String) onPreferenceChange;

  const AppPreferencesSectionWidget({
    Key? key,
    required this.preferences,
    required this.onPreferenceChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferencias de la App',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Theme preference
            _buildPreferenceRow(
              'Tema',
              'palette',
              preferences['theme'] ?? 'light',
              ['light', 'dark', 'system'],
              ['Claro', 'Oscuro', 'Sistema'],
              'theme',
            ),

            // Language preference
            _buildPreferenceRow(
              'Idioma',
              'language',
              preferences['language'] ?? 'español',
              ['español', 'english'],
              ['Español', 'English'],
              'language',
            ),

            // Units preference
            _buildPreferenceRow(
              'Unidades',
              'straighten',
              preferences['units'] ?? 'metric',
              ['metric', 'imperial'],
              ['Métrico (kg, cm)', 'Imperial (lb, ft)'],
              'units',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(
    String title,
    String iconName,
    String currentValue,
    List<String> options,
    List<String> displayNames,
    String key,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Options
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final displayName = displayNames[index];
              final isSelected = currentValue == option;

              return GestureDetector(
                onTap: () => onPreferenceChange(key, option),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    displayName,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
