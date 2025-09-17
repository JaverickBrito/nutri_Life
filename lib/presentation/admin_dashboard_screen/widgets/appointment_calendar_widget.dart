import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppointmentCalendarWidget extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(String) onAppointmentTap;
  final Function(DateTime) onDateSelected;

  const AppointmentCalendarWidget({
    Key? key,
    required this.appointments,
    required this.onAppointmentTap,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<AppointmentCalendarWidget> createState() =>
      _AppointmentCalendarWidgetState();
}

class _AppointmentCalendarWidgetState extends State<AppointmentCalendarWidget> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendario de Citas',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Simple calendar header
            Container(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month - 1,
                          _focusedDate.day,
                        );
                      });
                    },
                    child: CustomIconWidget(
                      iconName: 'arrow_back_ios',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  Text(
                    _getMonthYearText(_focusedDate),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _focusedDate = DateTime(
                          _focusedDate.year,
                          _focusedDate.month + 1,
                          _focusedDate.day,
                        );
                      });
                    },
                    child: CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Appointments for selected date
            SizedBox(height: 2.h),
            Text(
              'Citas para ${_getSelectedDateText()}',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            // Appointment list
            ...(_getAppointmentsForDate(_selectedDate)
                    .map((appointment) => _buildAppointmentCard(appointment)))
                .toList(),

            if (_getAppointmentsForDate(_selectedDate).isEmpty)
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Center(
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'event_available',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No hay citas programadas',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        color: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1,
        child: InkWell(
          onTap: () => widget.onAppointmentTap(appointment['id']),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Time indicator
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getTimeFromDateTime(appointment['dateTime']),
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),

                // Appointment details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['patientName'],
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        appointment['type'],
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Duración: ${appointment['duration']} min',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status indicator
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Programada',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getAppointmentsForDate(DateTime date) {
    return widget.appointments.where((appointment) {
      final appointmentDate = appointment['dateTime'] as DateTime;
      return appointmentDate.year == date.year &&
          appointmentDate.month == date.month &&
          appointmentDate.day == date.day;
    }).toList();
  }

  String _getMonthYearText(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getSelectedDateText() {
    final now = DateTime.now();
    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      return 'hoy';
    }
    return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  String _getTimeFromDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
