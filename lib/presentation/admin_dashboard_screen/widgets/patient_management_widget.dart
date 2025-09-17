import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PatientManagementWidget extends StatefulWidget {
  final List<Map<String, dynamic>> patients;
  final String searchQuery;
  final String selectedFilter;
  final Function(String) onPatientTap;
  final Function(String) onFilterChanged;
  final Function(String, List<String>) onBulkAction;

  const PatientManagementWidget({
    Key? key,
    required this.patients,
    required this.searchQuery,
    required this.selectedFilter,
    required this.onPatientTap,
    required this.onFilterChanged,
    required this.onBulkAction,
  }) : super(key: key);

  @override
  State<PatientManagementWidget> createState() =>
      _PatientManagementWidgetState();
}

class _PatientManagementWidgetState extends State<PatientManagementWidget> {
  Set<String> _selectedPatients = {};
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Container(
          height: 6.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFilterChip('Todos', 'all'),
              _buildFilterChip('Estable', 'stable'),
              _buildFilterChip('Atención', 'attention'),
              _buildFilterChip('Crítico', 'critical'),
            ],
          ),
        ),

        // Bulk actions bar
        if (_selectedPatients.isNotEmpty)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  '${_selectedPatients.length} seleccionados',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                _buildBulkActionButton('Mensaje', 'message', 'message'),
                SizedBox(width: 2.w),
                _buildBulkActionButton('Reporte', 'assessment', 'report'),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPatients.clear();
                    });
                  },
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

        // Patient list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: widget.patients.length,
            itemBuilder: (context, index) {
              final patient = widget.patients[index];
              final isSelected = _selectedPatients.contains(patient['id']);

              return _buildPatientCard(patient, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = widget.selectedFilter == value;

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => widget.onFilterChanged(value),
        selectedColor: AppTheme.lightTheme.colorScheme.primary,
        checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
        labelStyle: TextStyle(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.onPrimary
              : AppTheme.lightTheme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildBulkActionButton(String label, String iconName, String action) {
    return GestureDetector(
      onTap: () => widget.onBulkAction(action, _selectedPatients.toList()),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient, bool isSelected) {
    final statusColor = _getStatusColor(patient['status']);
    final riskColor = _getRiskColor(patient['riskLevel']);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        color: isSelected
            ? AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3)
            : null,
        child: InkWell(
          onTap: () => widget.onPatientTap(patient['id']),
          onLongPress: () => _toggleSelection(patient['id']),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Selection checkbox
                if (_selectedPatients.isNotEmpty || isSelected)
                  Container(
                    margin: EdgeInsets.only(right: 3.w),
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (_) => _toggleSelection(patient['id']),
                    ),
                  ),

                // Patient avatar
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: statusColor,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: CustomImageWidget(
                      imageUrl: patient['avatar'],
                      width: 15.w,
                      height: 15.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                // Patient info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            patient['name'],
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: riskColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getRiskLabel(patient['riskLevel']),
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: riskColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${patient['diagnosis']} • ${patient['age']} años',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),

                      // Adherence bar
                      Row(
                        children: [
                          Text(
                            'Adherencia: ',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          Expanded(
                            child: Container(
                              height: 1.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: patient['adherence'],
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getAdherenceColor(
                                        patient['adherence']),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${(patient['adherence'] * 100).round()}%',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status indicator and actions
                Column(
                  children: [
                    Container(
                      width: 3.w,
                      height: 3.w,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSelection(String patientId) {
    setState(() {
      if (_selectedPatients.contains(patientId)) {
        _selectedPatients.remove(patientId);
      } else {
        _selectedPatients.add(patientId);
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'stable':
        return Colors.green;
      case 'attention':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  String _getRiskLabel(String riskLevel) {
    switch (riskLevel) {
      case 'low':
        return 'BAJO';
      case 'medium':
        return 'MEDIO';
      case 'high':
        return 'ALTO';
      default:
        return '';
    }
  }

  Color _getAdherenceColor(double adherence) {
    if (adherence >= 0.8) return Colors.green;
    if (adherence >= 0.6) return Colors.orange;
    return Colors.red;
  }
}
