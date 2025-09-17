import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConnectedServicesWidget extends StatelessWidget {
  final Map<String, bool> connectedServices;
  final Function(String, bool) onServiceToggle;

  const ConnectedServicesWidget({
    Key? key,
    required this.connectedServices,
    required this.onServiceToggle,
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
              'Servicios Conectados',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Conecta con aplicaciones de salud y fitness',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
            _buildServiceRow(
              'Google Fit',
              'Sincroniza actividad y pasos',
              'googleFit',
              Colors.green,
            ),
            _buildServiceRow(
              'Apple Health',
              'Datos de salud de iOS',
              'appleHealth',
              Colors.red,
            ),
            _buildServiceRow(
              'Fitbit',
              'Rastreador de actividad',
              'fitbit',
              Colors.blue,
            ),
            _buildServiceRow(
              'Strava',
              'Ejercicios y entrenamientos',
              'strava',
              Colors.orange,
            ),
            _buildServiceRow(
              'MyFitnessPal',
              'Base de datos de alimentos',
              'myFitnessPal',
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceRow(
    String serviceName,
    String description,
    String key,
    Color color,
  ) {
    final isConnected = connectedServices[key] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isConnected
            ? color.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected
              ? color.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getServiceIcon(key),
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isConnected
                        ? color
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isConnected,
            onChanged: (value) => onServiceToggle(key, value),
            activeColor: color,
          ),
        ],
      ),
    );
  }

  String _getServiceIcon(String service) {
    switch (service) {
      case 'googleFit':
        return 'fitness_center';
      case 'appleHealth':
        return 'favorite';
      case 'fitbit':
        return 'watch';
      case 'strava':
        return 'directions_run';
      case 'myFitnessPal':
        return 'restaurant';
      default:
        return 'link';
    }
  }
}
