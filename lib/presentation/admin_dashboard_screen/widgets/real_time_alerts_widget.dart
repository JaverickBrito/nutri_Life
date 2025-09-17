import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RealTimeAlertsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;
  final Function(String) onAlertTap;
  final Function(String) onAcknowledge;

  const RealTimeAlertsWidget({
    Key? key,
    required this.alerts,
    required this.onAlertTap,
    required this.onAcknowledge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final unacknowledgedAlerts =
        alerts.where((alert) => !alert['acknowledged']).toList();

    if (unacknowledgedAlerts.isEmpty) return Container();

    return Container(
      margin: EdgeInsets.all(4.w),
      child: Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Alertas en Tiempo Real',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unacknowledgedAlerts.length.toString(),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              ...unacknowledgedAlerts
                  .take(3)
                  .map((alert) => _buildAlertCard(alert))
                  .toList(),
              if (unacknowledgedAlerts.length > 3)
                Container(
                  margin: EdgeInsets.only(top: 2.h),
                  child: Text(
                    'Y ${unacknowledgedAlerts.length - 3} alertas más...',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final alertColor = _getAlertColor(alert['type']);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: alertColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => onAlertTap(alert['id']),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              // Alert type indicator
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: alertColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: _getAlertIcon(alert['type']),
                  color: alertColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),

              // Alert details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert['patientName'],
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      alert['message'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _getTimeAgo(alert['timestamp']),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              // Acknowledge button
              GestureDetector(
                onTap: () => onAcknowledge(alert['id']),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: alertColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: alertColor,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlertColor(String type) {
    switch (type) {
      case 'critical':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getAlertIcon(String type) {
    switch (type) {
      case 'critical':
        return 'error';
      case 'warning':
        return 'warning';
      case 'info':
        return 'info';
      default:
        return 'notifications';
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora mismo';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else {
      return 'Hace ${difference.inDays}d';
    }
  }
}
