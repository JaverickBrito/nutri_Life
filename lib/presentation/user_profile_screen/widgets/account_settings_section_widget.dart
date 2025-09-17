import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountSettingsSectionWidget extends StatelessWidget {
  final Map<String, bool> notificationSettings;
  final Function(String, bool) onNotificationChange;
  final VoidCallback onChangePassword;
  final VoidCallback onPrivacySettings;
  final VoidCallback onExportData;

  const AccountSettingsSectionWidget({
    Key? key,
    required this.notificationSettings,
    required this.onNotificationChange,
    required this.onChangePassword,
    required this.onPrivacySettings,
    required this.onExportData,
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
              'Configuración de Cuenta',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Password change
            _buildSettingsRow(
              'Cambiar contraseña',
              'security',
              onTap: onChangePassword,
              showArrow: true,
            ),

            SizedBox(height: 2.h),

            // Privacy settings
            _buildSettingsRow(
              'Configuración de privacidad',
              'privacy_tip',
              onTap: onPrivacySettings,
              showArrow: true,
            ),

            SizedBox(height: 2.h),

            // Data export
            _buildSettingsRow(
              'Exportar mis datos',
              'file_download',
              onTap: onExportData,
              showArrow: true,
            ),

            SizedBox(height: 3.h),
            Divider(color: AppTheme.lightTheme.dividerColor),
            SizedBox(height: 2.h),

            // Notification settings
            Text(
              'Notificaciones',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            _buildNotificationSwitch(
              'Recordatorios de comidas',
              'mealReminders',
              'restaurant',
            ),
            _buildNotificationSwitch(
              'Recordatorios de agua',
              'waterReminders',
              'water_drop',
            ),
            _buildNotificationSwitch(
              'Recordatorios de ejercicio',
              'exerciseReminders',
              'fitness_center',
            ),
            _buildNotificationSwitch(
              'Actualizaciones de progreso',
              'progressUpdates',
              'trending_up',
            ),
            _buildNotificationSwitch(
              'Actualizaciones sociales',
              'socialUpdates',
              'people',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsRow(
    String title,
    String iconName, {
    VoidCallback? onTap,
    bool showArrow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showArrow)
              CustomIconWidget(
                iconName: 'arrow_forward_ios',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    String key,
    String iconName,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.secondary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: notificationSettings[key] ?? false,
            onChanged: (value) => onNotificationChange(key, value),
          ),
        ],
      ),
    );
  }
}
