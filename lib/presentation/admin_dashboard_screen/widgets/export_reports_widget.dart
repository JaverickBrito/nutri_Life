import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExportReportsWidget extends StatelessWidget {
  final Function(String) onGenerateReport;
  final Function(String) onExportData;

  const ExportReportsWidget({
    Key? key,
    required this.onGenerateReport,
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
              'Reportes y Exportación',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),

            // Report types
            Text(
              'Generar Reportes',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 4.w,
              childAspectRatio: 1.2,
              children: [
                _buildReportCard(
                  'Reporte General',
                  'Resumen completo de pacientes',
                  'assessment',
                  Colors.blue,
                  'general',
                ),
                _buildReportCard(
                  'Análisis Nutricional',
                  'Estadísticas de nutrición',
                  'restaurant',
                  Colors.green,
                  'nutrition',
                ),
                _buildReportCard(
                  'Adherencia',
                  'Reporte de cumplimiento',
                  'trending_up',
                  Colors.purple,
                  'adherence',
                ),
                _buildReportCard(
                  'Resultados Clínicos',
                  'Evolución de resultados',
                  'favorite',
                  Colors.red,
                  'outcomes',
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // Export options
            Text(
              'Exportar Datos',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),

            Row(
              children: [
                Expanded(
                  child: _buildExportButton(
                    'PDF',
                    'picture_as_pdf',
                    Colors.red,
                    'pdf',
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildExportButton(
                    'CSV',
                    'table_chart',
                    Colors.green,
                    'csv',
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildExportButton(
                    'Excel',
                    'description',
                    Colors.blue,
                    'excel',
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // HIPAA compliance notice
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'security',
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Todos los reportes cumplen con HIPAA y están encriptados para proteger la privacidad del paciente.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    String title,
    String description,
    String iconName,
    Color color,
    String reportType,
  ) {
    return GestureDetector(
      onTap: () => onGenerateReport(reportType),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 28,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButton(
    String format,
    String iconName,
    Color color,
    String exportFormat,
  ) {
    return GestureDetector(
      onTap: () => onExportData(exportFormat),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: color,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              format,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
