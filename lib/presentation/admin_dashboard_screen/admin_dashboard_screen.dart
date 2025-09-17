import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/admin_header_widget.dart';
import './widgets/analytics_overview_widget.dart';
import './widgets/appointment_calendar_widget.dart';
import './widgets/export_reports_widget.dart';
import './widgets/patient_management_widget.dart';
import './widgets/population_health_widget.dart';
import './widgets/real_time_alerts_widget.dart';

/// Panel de administración para profesionales de la salud
/// Esta pantalla permite a administradores y profesionales sanitarios:
/// - Gestionar pacientes y su información médica
/// - Ver análisis poblacionales y tendencias de salud
/// - Administrar calendario de citas y consultas
/// - Generar reportes médicos y estadísticos
/// - Monitorear alertas en tiempo real de pacientes
/// - Realizar acciones administrativas masivas
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false; // Estado de carga para operaciones asíncronas
  int _selectedTabIndex =
      0; // Índice de la pestaña seleccionada en el dashboard
  String _searchQuery = ''; // Consulta de búsqueda para filtrar pacientes
  String _selectedFilter = 'all'; // Filtro seleccionado para mostrar pacientes
  late TabController
      _tabController; // Controlador para las pestañas del dashboard

  // Datos simulados del administrador/profesional de salud
  Map<String, dynamic> _adminData = {
    'name': 'Dr. María Rodríguez',
    'facility': 'Centro de Salud San Juan', // Centro médico de trabajo
    'specialization': 'Nutricionista Clínica', // Especialización médica
    'patientCount': 147, // Número total de pacientes bajo su cuidado
    'avatar':
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
  };

  // Lista simulada de pacientes con información médica básica
  List<Map<String, dynamic>> _patients = [
    {
      'id': 'P001', // Identificador único del paciente
      'name': 'Ana García',
      'age': 34,
      'status': 'stable', // Estado médico actual: stable, attention, critical
      'lastVisit':
          DateTime.now().subtract(Duration(days: 3)), // Última consulta
      'nextAppointment': DateTime.now().add(Duration(days: 7)), // Próxima cita
      'riskLevel': 'low', // Nivel de riesgo: low, medium, high
      'avatar':
          'https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000',
      'diagnosis': 'Diabetes tipo 2', // Diagnóstico principal
      'adherence': 0.92, // Porcentaje de adherencia al tratamiento (0.0-1.0)
    },
    {
      'id': 'P002',
      'name': 'Carlos López',
      'age': 45,
      'status': 'attention', // Requiere atención médica
      'lastVisit': DateTime.now().subtract(Duration(days: 1)),
      'nextAppointment': DateTime.now().add(Duration(days: 2)),
      'riskLevel': 'medium',
      'avatar':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=3000',
      'diagnosis': 'Hipertensión',
      'adherence': 0.75, // Adherencia moderada
    },
    {
      'id': 'P003',
      'name': 'Isabel Martín',
      'age': 28,
      'status': 'critical', // Estado crítico requiere atención inmediata
      'lastVisit': DateTime.now().subtract(Duration(hours: 6)),
      'nextAppointment': DateTime.now().add(Duration(days: 1)),
      'riskLevel': 'high',
      'avatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?fm=jpg&q=60&w=3000',
      'diagnosis': 'Trastorno alimentario',
      'adherence': 0.45, // Baja adherencia al tratamiento
    },
  ];

  // Datos analíticos agregados de la población de pacientes
  Map<String, dynamic> _analyticsData = {
    'totalPatients': 147, // Total de pacientes registrados
    'activePatients': 132, // Pacientes con actividad reciente
    'avgAdherence': 0.84, // Promedio de adherencia al tratamiento
    'completedGoals': 89, // Número de objetivos completados
    'medicationAdherence': 0.91, // Adherencia a medicación
    // Estadísticas de resultados por mes
    'outcomeStats': [
      {'month': 'Ene', 'improved': 23, 'stable': 45, 'declined': 3},
      {'month': 'Feb', 'improved': 28, 'stable': 42, 'declined': 2},
      {'month': 'Mar', 'improved': 31, 'stable': 38, 'declined': 1},
      {'month': 'Abr', 'improved': 35, 'stable': 41, 'declined': 2},
      {'month': 'May', 'improved': 38, 'stable': 39, 'declined': 1},
    ],
  };

  // Alertas en tiempo real del sistema de monitoreo
  List<Map<String, dynamic>> _alerts = [
    {
      'id': 'A001', // Identificador único de la alerta
      'patientId': 'P003',
      'patientName': 'Isabel Martín',
      'type': 'critical', // Tipo de alerta: critical, warning, info
      'message': 'Valores nutricionales fuera del rango normal',
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
      'acknowledged': false, // Si la alerta ha sido atendida
    },
    {
      'id': 'A002',
      'patientId': 'P005',
      'patientName': 'Roberto Díaz',
      'type': 'warning',
      'message': 'No ha registrado comidas en 48 horas',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'acknowledged': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar controlador de pestañas con 4 secciones principales
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // Limpiar recursos del controlador al destruir el widget
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header administrativo con información del profesional y alertas
            AdminHeaderWidget(
              adminData: _adminData,
              alertCount:
                  _alerts.where((alert) => !alert['acknowledged']).length,
              onNotificationTap: _handleNotificationTap,
              onSearchChanged: _handleSearchChanged,
            ),

            // Barra de pestañas para diferentes secciones del dashboard
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              child: TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                tabs: [
                  Tab(text: 'Pacientes'), // Gestión de pacientes
                  Tab(text: 'Análisis'), // Analytics y métricas
                  Tab(text: 'Calendario'), // Gestión de citas
                  Tab(text: 'Reportes'), // Generación de informes
                ],
              ),
            ),

            // Contenido de las pestañas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPatientsTab(), // Pestaña de gestión de pacientes
                  _buildAnalyticsTab(), // Pestaña de análisis y métricas
                  _buildCalendarTab(), // Pestaña de calendario de citas
                  _buildReportsTab(), // Pestaña de reportes y exportación
                ],
              ),
            ),
          ],
        ),
      ),

      // Botón flotante para acciones rápidas administrativas
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickActions,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
    );
  }

  /// Construye la pestaña de gestión de pacientes
  /// Incluye alertas en tiempo real y lista de pacientes con filtros
  Widget _buildPatientsTab() {
    final filteredPatients = _filterPatients(); // Aplicar filtros de búsqueda

    return RefreshIndicator(
      onRefresh: _refreshPatientData,
      child: Column(
        children: [
          // Alertas en tiempo real si existen alertas no atendidas
          if (_alerts.isNotEmpty)
            RealTimeAlertsWidget(
              alerts: _alerts,
              onAlertTap: _handleAlertTap,
              onAcknowledge: _handleAcknowledgeAlert,
            ),

          // Widget principal de gestión de pacientes
          Expanded(
            child: PatientManagementWidget(
              patients: filteredPatients,
              searchQuery: _searchQuery,
              selectedFilter: _selectedFilter,
              onPatientTap: _handlePatientTap,
              onFilterChanged: _handleFilterChanged,
              onBulkAction: _handleBulkAction,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la pestaña de análisis y métricas poblacionales
  /// Muestra tendencias de salud y estadísticas agregadas
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Widget de resumen analítico con métricas clave
          AnalyticsOverviewWidget(
            analyticsData: _analyticsData,
          ),
          SizedBox(height: 3.h),

          // Widget de análisis de salud poblacional
          PopulationHealthWidget(
            outcomeStats: _analyticsData['outcomeStats'],
            adherenceRate: _analyticsData['avgAdherence'],
          ),
        ],
      ),
    );
  }

  /// Construye la pestaña de calendario de citas
  /// Permite gestionar y visualizar citas médicas programadas
  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          AppointmentCalendarWidget(
            appointments: _generateAppointments(), // Generar citas simuladas
            onAppointmentTap: _handleAppointmentTap,
            onDateSelected: _handleDateSelected,
          ),
        ],
      ),
    );
  }

  /// Construye la pestaña de reportes y exportación
  /// Permite generar informes médicos y exportar datos
  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          ExportReportsWidget(
            onGenerateReport: _handleGenerateReport,
            onExportData: _handleExportData,
          ),
        ],
      ),
    );
  }

  /// Filtra la lista de pacientes según criterios de búsqueda
  /// Aplica filtros por nombre, ID y estado médico
  List<Map<String, dynamic>> _filterPatients() {
    List<Map<String, dynamic>> filtered = _patients;

    // Aplicar filtro de búsqueda por texto
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((patient) {
        return patient['name']
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            patient['id'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Aplicar filtro por estado médico
    if (_selectedFilter != 'all') {
      filtered = filtered.where((patient) {
        return patient['status'] == _selectedFilter;
      }).toList();
    }

    return filtered;
  }

  /// Genera datos simulados de citas médicas
  /// Crea citas futuras para demostración del calendario
  List<Map<String, dynamic>> _generateAppointments() {
    return [
      {
        'id': 'APP001',
        'patientName': 'Ana García',
        'patientId': 'P001',
        'dateTime': DateTime.now()
            .add(Duration(days: 1, hours: 9)), // Mañana a las 9:00
        'type': 'Control de rutina',
        'duration': 30, // Duración en minutos
      },
      {
        'id': 'APP002',
        'patientName': 'Carlos López',
        'patientId': 'P002',
        'dateTime': DateTime.now()
            .add(Duration(days: 2, hours: 14)), // Pasado mañana a las 14:00
        'type': 'Seguimiento',
        'duration': 45,
      },
    ];
  }

  /// Maneja el toque en el icono de notificaciones
  void _handleNotificationTap() {
    // TODO: Implementar panel de notificaciones
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mostrando notificaciones')),
    );
  }

  /// Maneja cambios en la consulta de búsqueda de pacientes
  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  /// Maneja el toque en un paciente específico
  /// Navega a los detalles médicos del paciente
  void _handlePatientTap(String patientId) {
    // TODO: Implementar navegación a detalles del paciente
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navegando a detalles del paciente $patientId')),
    );
  }

  /// Maneja cambios en el filtro de estado de pacientes
  void _handleFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  /// Maneja acciones masivas en múltiples pacientes
  /// Permite operaciones como envío de mensajes o actualización de estado
  void _handleBulkAction(String action, List<String> patientIds) {
    // TODO: Implementar acciones masivas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Acción $action aplicada a ${patientIds.length} pacientes')),
    );
  }

  /// Maneja el toque en una alerta específica
  /// Navega a los detalles de la alerta para resolverla
  void _handleAlertTap(String alertId) {
    // TODO: Implementar navegación a detalles de alerta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navegando a detalles de alerta $alertId')),
    );
  }

  /// Maneja el reconocimiento/resolución de una alerta
  /// Marca la alerta como atendida por el profesional
  void _handleAcknowledgeAlert(String alertId) {
    setState(() {
      final alertIndex = _alerts.indexWhere((alert) => alert['id'] == alertId);
      if (alertIndex != -1) {
        _alerts[alertIndex]['acknowledged'] = true;
      }
    });
  }

  /// Maneja el toque en una cita específica del calendario
  void _handleAppointmentTap(String appointmentId) {
    // TODO: Implementar navegación a detalles de cita
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navegando a detalles de cita $appointmentId')),
    );
  }

  /// Maneja la selección de una fecha en el calendario
  void _handleDateSelected(DateTime date) {
    // TODO: Filtrar citas por fecha seleccionada
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Fecha seleccionada: ${date.toString().split(' ')[0]}')),
    );
  }

  /// Maneja la generación de reportes médicos
  /// Crea informes especializados según el tipo solicitado
  void _handleGenerateReport(String reportType) {
    // TODO: Implementar generación de reportes
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generando reporte: $reportType')),
    );
  }

  /// Maneja la exportación de datos en diferentes formatos
  /// Permite exportar información médica en formatos como PDF o CSV
  void _handleExportData(String format) {
    // TODO: Implementar exportación de datos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exportando datos en formato: $format')),
    );
  }

  /// Actualiza los datos de pacientes mediante pull-to-refresh
  /// Simula la sincronización con el servidor médico
  Future<void> _refreshPatientData() async {
    setState(() {
      _isLoading = true;
    });

    // Simular actualización de datos desde el servidor
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  /// Muestra menú de acciones rápidas para tareas administrativas comunes
  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Acciones Rápidas',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            // Grid de acciones rápidas disponibles
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 2.h,
              crossAxisSpacing: 4.w,
              childAspectRatio: 1.5,
              children: [
                // Acción para registrar nuevo paciente
                _buildQuickActionTile('Nuevo Paciente', 'person_add', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Función próximamente')),
                  );
                }),
                // Acción para enviar mensaje masivo
                _buildQuickActionTile('Mensaje Masivo', 'message', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Función próximamente')),
                  );
                }),
                // Acción para generar reporte general
                _buildQuickActionTile('Generar Reporte', 'assessment', () {
                  Navigator.pop(context);
                  _handleGenerateReport('general');
                }),
                // Acción para exportar datos
                _buildQuickActionTile('Exportar Datos', 'file_download', () {
                  Navigator.pop(context);
                  _handleExportData('pdf');
                }),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  /// Construye un elemento individual de acción rápida
  /// Crea un botón visual con icono y texto descriptivo
  Widget _buildQuickActionTile(
      String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Fondo sutil con color primario
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          // Borde sutil para definir la acción
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono representativo de la acción
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 28,
            ),
            SizedBox(height: 1.h),
            // Título descriptivo de la acción
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
