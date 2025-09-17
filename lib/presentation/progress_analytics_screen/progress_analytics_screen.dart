import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/calorie_comparison_chart_widget.dart';
import './widgets/date_range_selector_widget.dart';
import './widgets/exercise_heatmap_widget.dart';
import './widgets/goal_achievement_widget.dart';
import './widgets/macronutrient_breakdown_widget.dart';
import './widgets/weight_progress_chart_widget.dart';

/// Pantalla de análisis de progreso y métricas
/// Esta pantalla permite a los usuarios:
/// - Ver gráficos de progreso de peso y calorías
/// - Analizar tendencias nutricionales y de actividad
/// - Revisar logros de objetivos y hitos alcanzados
/// - Exportar reportes de progreso
/// - Personalizar rangos de fechas para análisis
class ProgressAnalyticsScreen extends StatefulWidget {
  const ProgressAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<ProgressAnalyticsScreen> createState() =>
      _ProgressAnalyticsScreenState();
}

class _ProgressAnalyticsScreenState extends State<ProgressAnalyticsScreen>
    with TickerProviderStateMixin {
  int _activeTabIndex =
      3; // Índice de la pestaña activa en navegación inferior (Progreso)
  String _selectedDateRange =
      'week'; // Rango de fechas seleccionado para análisis
  late TabController
      _tabController; // Controlador para pestañas internas de la pantalla

  @override
  void initState() {
    super.initState();
    // Inicializar controlador de pestañas con 4 secciones
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  /// Construye la barra de aplicación superior
  /// Incluye título, botón de exportación y menú de opciones
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Análisis de Progreso', // Título en español
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        // Botón para exportar reportes
        IconButton(
          icon: CustomIconWidget(
            iconName: 'file_download',
            size: 24.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: _exportReport,
        ),
        // Botón de menú de opciones adicionales
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            size: 24.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => _showOptionsMenu(context),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  /// Construye el cuerpo principal de la pantalla
  /// Incluye selector de rango de fechas, pestañas y contenido
  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          // Widget para seleccionar rango de fechas (semana, mes, año)
          DateRangeSelectorWidget(
            selectedRange: _selectedDateRange,
            onRangeChanged: (range) {
              setState(() {
                _selectedDateRange = range;
              });
            },
          ),
          SizedBox(height: 2.h),
          _buildTabBar(), // Barra de pestañas internas
          Expanded(
            // Vista con contenido de cada pestaña
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(), // Pestaña de resumen general
                _buildNutritionTab(), // Pestaña de análisis nutricional
                _buildActivityTab(), // Pestaña de análisis de ejercicio
                _buildGoalsTab(), // Pestaña de metas y logros
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la barra de pestañas internas
  /// Permite navegar entre diferentes tipos de análisis
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12.sp),
        // Sombra sutil para el contenedor de pestañas
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false, // Pestañas de ancho fijo
        indicatorSize: TabBarIndicatorSize.tab,
        // Indicador personalizado con bordes redondeados
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor:
            Theme.of(context).colorScheme.onSurface.withAlpha(153),
        labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        tabs: const [
          Tab(text: 'Resumen'), // Pestaña de vista general
          Tab(text: 'Nutrición'), // Pestaña de análisis nutricional
          Tab(text: 'Actividad'), // Pestaña de análisis de ejercicio
          Tab(text: 'Objetivos'), // Pestaña de metas y logros
        ],
      ),
    );
  }

  /// Construye la pestaña de resumen general
  /// Muestra gráficos de peso, calorías e insights semanales
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Gráfico de progreso de peso a lo largo del tiempo
          WeightProgressChartWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Gráfico comparativo de calorías consumidas vs quemadas
          CalorieComparisonChartWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Tarjeta con insights y análisis semanal
          _buildWeeklyInsightsCard(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Construye la pestaña de análisis nutricional
  /// Muestra desglose de proteínas, carbohidratos y grasas
  Widget _buildNutritionTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Widget que muestra desglose de proteínas, carbohidratos y grasas
          MacronutrientBreakdownWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Reutilizar gráfico de calorías para contexto nutricional
          CalorieComparisonChartWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Insights específicos sobre patrones nutricionales
          _buildNutritionInsightsCard(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Construye la pestaña de análisis de actividad física
  /// Muestra mapa de calor de ejercicios y estadísticas de actividad
  Widget _buildActivityTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Mapa de calor que muestra frecuencia de ejercicios por día
          ExerciseHeatmapWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Estadísticas detalladas de actividad física
          _buildActivityStatsCard(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Construye la pestaña de objetivos y logros
  /// Muestra progreso hacia metas establecidas y hitos alcanzados
  Widget _buildGoalsTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          SizedBox(height: 2.h),
          // Widget que muestra progreso hacia objetivos establecidos
          GoalAchievementWidget(dateRange: _selectedDateRange),
          SizedBox(height: 2.h),
          // Tarjeta con hitos y logros recientes
          _buildMilestonesCard(),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  /// Construye tarjeta de insights semanales
  /// Analiza tendencias y proporciona feedback sobre el progreso
  Widget _buildWeeklyInsightsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'insights',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Insights Semanales', // Título de la sección
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Insight sobre pérdida de peso con indicador de mejora
            _buildInsightItem(
              'Pérdida de Peso',
              '↓ 0.8 kg esta semana',
              '12% mejora respecto a la semana anterior',
              const Color(0xFF27AE60), // Verde para indicar progreso positivo
            ),
            SizedBox(height: 1.h),
            // Insight sobre balance calórico
            _buildInsightItem(
              'Balance Calórico',
              'Déficit promedio: 285 cal/día',
              'Consistente con tu objetivo',
              const Color(0xFF3498DB), // Azul para información neutra
            ),
            SizedBox(height: 1.h),
            // Insight sobre actividad física
            _buildInsightItem(
              'Actividad',
              '4 sesiones de entrenamiento completadas',
              '33% aumento respecto a la semana anterior',
              const Color(0xFFF39C12), // Naranja para actividad
            ),
          ],
        ),
      ),
    );
  }

  /// Construye tarjeta de análisis nutricional
  /// Proporciona feedback sobre patrones de alimentación
  Widget _buildNutritionInsightsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'restaurant',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Análisis Nutricional', // Título de la sección
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Análisis de consumo de proteínas
            _buildInsightItem(
              'Ingesta de Proteínas',
              'Promedio: 112g/día',
              'Cumpliendo tu objetivo diario',
              const Color(0xFF27AE60),
            ),
            SizedBox(height: 1.h),
            // Análisis de hidratación
            _buildInsightItem(
              'Consumo de Agua',
              'Promedio: 2.1L/día',
              'Ligeramente por debajo del objetivo de 2.5L',
              const Color(0xFFF39C12), // Naranja para advertencia leve
            ),
            SizedBox(height: 1.h),
            // Análisis de horarios de comida
            _buildInsightItem(
              'Horarios de Comida',
              'Horarios regulares de comida',
              'Patrón de alimentación consistente',
              const Color(0xFF3498DB),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye tarjeta de estadísticas de actividad
  /// Muestra métricas cuantificadas de ejercicio y movimiento
  Widget _buildActivityStatsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'fitness_center',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Estadísticas de Actividad', // Título de la sección
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Primera fila de estadísticas
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Entrenamientos Totales',
                    '18',
                    'Este mes',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Minutos Activos',
                    '2,847',
                    'Este mes',
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            // Segunda fila de estadísticas
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Calorías Quemadas',
                    '4,256',
                    'Este mes',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Día Más Activo',
                    'Miércoles',
                    'Esta semana',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye tarjeta de hitos y logros recientes
  /// Celebra los logros del usuario con iconos emotivos
  Widget _buildMilestonesCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Hitos Recientes', // Título de la sección
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Hito de racha de entrenamientos
            _buildMilestoneItem(
              '10 Días de Racha',
              'Días consecutivos de entrenamiento',
              '🔥', // Emoji de fuego para representar la racha
              const Color(0xFFE74C3C), // Rojo para intensidad
            ),
            SizedBox(height: 1.h),
            // Hito de pérdida de peso
            _buildMilestoneItem(
              '5kg Perdidos',
              'Hito de pérdida de peso',
              '🎯', // Emoji de diana para representar objetivo cumplido
              const Color(0xFF27AE60), // Verde para éxito
            ),
            SizedBox(height: 1.h),
            // Hito de distancia recorrida
            _buildMilestoneItem(
              '100km Registrados',
              'Hito de distancia total',
              '🏃', // Emoji de corredor para representar actividad
              const Color(0xFF3498DB), // Azul para actividad
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un elemento individual de insight
  /// Parámetros: título, valor, subtítulo y color temático
  Widget _buildInsightItem(
      String title, String value, String subtitle, Color color) {
    return Row(
      children: [
        // Barra de color lateral para categorización visual
        Container(
          width: 4,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del insight
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 0.5.h),
              // Valor principal con color temático
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 0.5.h),
              // Información adicional o contexto
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construye un elemento de estadística con valor destacado
  /// Usado para mostrar métricas numéricas importantes
  Widget _buildStatItem(String title, String value, String subtitle) {
    return Column(
      children: [
        // Valor principal en texto grande y color primario
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 0.5.h),
        // Título de la métrica
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        // Contexto temporal o adicional
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
        ),
      ],
    );
  }

  /// Construye un elemento de hito o logro
  /// Incluye emoji, título, descripción y color temático
  Widget _buildMilestoneItem(
      String title, String subtitle, String emoji, Color color) {
    return Row(
      children: [
        // Contenedor circular para el emoji del hito
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color.withAlpha(26), // Color de fondo sutil
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título del hito
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              // Descripción del hito
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(153),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Maneja la exportación de reportes de progreso
  /// Muestra notificación de confirmación al usuario
  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exportando reporte de progreso...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Muestra menú de opciones adicionales
  /// Incluye compartir, configuración y ayuda
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción para compartir progreso
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                size: 24.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Compartir Progreso'),
              onTap: () => Navigator.pop(context),
            ),
            // Opción para configurar análisis
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                size: 24.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Configuración de Análisis'),
              onTap: () => Navigator.pop(context),
            ),
            // Opción de ayuda para entender gráficos
            ListTile(
              leading: CustomIconWidget(
                iconName: 'help_outline',
                size: 24.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text('Cómo Interpretar Gráficos'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la barra de navegación inferior
  /// Permite navegar entre las pantallas principales de la app
  Widget _buildBottomNavigation() {
    // Configuración de elementos de navegación con iconos y rutas
    final List<Map<String, dynamic>> navItems = [
      {'icon': 'home', 'label': 'Inicio', 'route': '/dashboard-home-screen'},
      {
        'icon': 'restaurant',
        'label': 'Comidas',
        'route': '/meal-logging-screen'
      },
      {
        'icon': 'fitness_center',
        'label': 'Actividad',
        'route': '/activity-tracking-screen'
      },
      {
        'icon': 'analytics',
        'label': 'Progreso',
        'route': '/progress-analytics-screen'
      },
      {'icon': 'person', 'label': 'Perfil', 'route': '/user-profile-screen'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        // Sombra superior para separar la navegación del contenido
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _activeTabIndex,
        type: BottomNavigationBarType.fixed, // Mostrar todas las pestañas
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withAlpha(153),
        showUnselectedLabels: true,
        onTap: (index) {
          // Navegar solo si no estamos ya en esa pestaña
          if (index != _activeTabIndex) {
            Navigator.pushReplacementNamed(context, navItems[index]['route']);
          }
        },
        // Generar elementos de navegación dinámicamente
        items: navItems.map((item) {
          int index = navItems.indexOf(item);
          return BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: item['icon'],
              size: 24.sp,
              // Cambiar color según estado de selección
              color: index == _activeTabIndex
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withAlpha(153),
            ),
            label: item['label'],
          );
        }).toList(),
      ),
    );
  }
}
