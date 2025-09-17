import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PermissionRequestWidget extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionRequestWidget({
    Key? key,
    required this.onPermissionsGranted,
  }) : super(key: key);

  @override
  State<PermissionRequestWidget> createState() =>
      _PermissionRequestWidgetState();
}

class _PermissionRequestWidgetState extends State<PermissionRequestWidget> {
  bool _cameraPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  bool _locationPermissionGranted = false;
  bool _isRequestingPermissions = false;

  final List<Map<String, dynamic>> _permissions = [
    {
      'title': 'Cámara',
      'description':
          'Para tomar fotos de tus comidas y registrar tu progreso nutricional',
      'icon': 'camera_alt',
      'permission': Permission.camera,
      'granted': false,
    },
    {
      'title': 'Notificaciones',
      'description':
          'Para recordatorios de comidas y consejos de salud personalizados',
      'icon': 'notifications',
      'permission': Permission.notification,
      'granted': false,
    },
    {
      'title': 'Ubicación (Opcional)',
      'description':
          'Para rastrear actividades físicas y encontrar opciones saludables cerca',
      'icon': 'location_on',
      'permission': Permission.locationWhenInUse,
      'granted': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        children: [
          // Header
          Text(
            'Permisos Necesarios',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Text(
            'Para brindarte la mejor experiencia, necesitamos algunos permisos:',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4.h),

          // Permission List
          Expanded(
            child: ListView.builder(
              itemCount: _permissions.length,
              itemBuilder: (context, index) {
                final permission = _permissions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 3.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: permission['icon'],
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              permission['title'],
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              permission['description'],
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Status
                      permission['granted']
                          ? CustomIconWidget(
                              iconName: 'check_circle',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 6.w,
                            )
                          : CustomIconWidget(
                              iconName: 'radio_button_unchecked',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 6.w,
                            ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Action Buttons
          Column(
            children: [
              // Grant Permissions Button
              Container(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed:
                      _isRequestingPermissions ? null : _requestPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: _isRequestingPermissions
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            strokeWidth: 2.0,
                          ),
                        )
                      : Text(
                          'Conceder Permisos',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 2.h),

              // Skip Button
              TextButton(
                onPressed: widget.onPermissionsGranted,
                child: Text(
                  'Omitir por ahora',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isRequestingPermissions = true;
    });

    try {
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      _cameraPermissionGranted = cameraStatus.isGranted;

      // Request notification permission
      final notificationStatus = await Permission.notification.request();
      _notificationPermissionGranted = notificationStatus.isGranted;

      // Request location permission (optional)
      final locationStatus = await Permission.locationWhenInUse.request();
      _locationPermissionGranted = locationStatus.isGranted;

      // Update permission status in the list
      setState(() {
        _permissions[0]['granted'] = _cameraPermissionGranted;
        _permissions[1]['granted'] = _notificationPermissionGranted;
        _permissions[2]['granted'] = _locationPermissionGranted;
      });

      // If essential permissions are granted, proceed
      if (_cameraPermissionGranted || _notificationPermissionGranted) {
        await Future.delayed(Duration(milliseconds: 500));
        widget.onPermissionsGranted();
      }
    } catch (e) {
      // Handle permission request errors gracefully
      widget.onPermissionsGranted();
    } finally {
      setState(() {
        _isRequestingPermissions = false;
      });
    }
  }
}
