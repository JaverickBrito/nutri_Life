import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/activity_timeline_widget.dart';
import './widgets/exercise_type_selector_widget.dart';
import './widgets/quick_add_floating_button_widget.dart';
import './widgets/workout_metrics_widget.dart';

/// Pantalla de seguimiento de actividad física
/// Esta pantalla permite a los usuarios:
/// - Iniciar y detener entrenamientos
/// - Ver progreso diario de pasos y calorías
/// - Seleccionar tipos de ejercicio
/// - Ver cronología de actividades recientes
class ActivityTrackingScreen extends StatefulWidget {
  const ActivityTrackingScreen({Key? key}) : super(key: key);

  @override
  State<ActivityTrackingScreen> createState() => _ActivityTrackingScreenState();
}

class _ActivityTrackingScreenState extends State<ActivityTrackingScreen>
    with TickerProviderStateMixin {
  // Variables de estado para controlar el entrenamiento activo
  bool _isWorkoutActive = false; // Indica si hay un entrenamiento en progreso
  String _selectedExerciseType = 'running'; // Tipo de ejercicio seleccionado
  int _activeTabIndex =
      2; // Índice de la pestaña activa en la navegación inferior (Actividad)

  // Controladores de animación para efectos visuales
  late AnimationController
      _workoutAnimationController; // Controla animaciones durante el entrenamiento
  late AnimationController
      _metricsAnimationController; // Controla animaciones de métricas en tiempo real

  // Datos simulados de actividad diaria
  int _dailySteps = 8247; // Pasos registrados en el día
  double _activeCalories = 324.5; // Calorías activas quemadas

  // Métricas del entrenamiento en tiempo real
  Duration _workoutDuration =
      Duration.zero; // Duración del entrenamiento actual
  int _heartRate = 0; // Frecuencia cardíaca actual (simulada)
  double _caloriesBurned = 0.0; // Calorías quemadas en el entrenamiento actual
  double _distance = 0.0; // Distancia recorrida en el entrenamiento actual

  @override
  void initState() {
    super.initState();
    // Inicializar controladores de animación
    _workoutAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _metricsAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // Limpiar recursos de animación al destruir el widget
    _workoutAnimationController.dispose();
    _metricsAnimationController.dispose();
    super.dispose();
  }

  /// Inicia una sesión de entrenamiento
  /// Activa las animaciones y comienza la simulación de datos en tiempo real
  void _startWorkout() {
    setState(() {
      _isWorkoutActive = true;
    });
    _workoutAnimationController.forward(); // Inicia animación de entrada
    _metricsAnimationController
        .repeat(); // Inicia animación cíclica de métricas

    // Simular actualizaciones de datos del entrenamiento
    _simulateWorkoutData();
  }

  /// Detiene la sesión de entrenamiento actual
  /// Resetea todas las métricas y detiene las animaciones
  void _stopWorkout() {
    setState(() {
      _isWorkoutActive = false;
      _workoutDuration = Duration.zero;
      _heartRate = 0;
      _caloriesBurned = 0.0;
      _distance = 0.0;
    });
    _workoutAnimationController.reverse(); // Animación de salida
    _metricsAnimationController.stop(); // Detiene animación cíclica
  }

  /// Simula datos de entrenamiento en tiempo real
  /// Se ejecuta recursivamente cada segundo mientras el entrenamiento esté activo
  void _simulateWorkoutData() {
    if (_isWorkoutActive) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isWorkoutActive) {
          setState(() {
            // Incrementar duración del entrenamiento
            _workoutDuration =
                Duration(seconds: _workoutDuration.inSeconds + 1);
            // Simular frecuencia cardíaca variable (75-115 bpm)
            _heartRate = 75 + (DateTime.now().millisecondsSinceEpoch % 40);
            // Incrementar calorías quemadas gradualmente
            _caloriesBurned += 0.1;
            // Incrementar distancia recorrida gradualmente
            _distance += 0.005;
          });
          _simulateWorkoutData(); // Llamada recursiva
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
      // Mostrar botón flotante solo cuando no hay entrenamiento activo
      floatingActionButton:
          !_isWorkoutActive ? const QuickAddFloatingButtonWidget() : null,
    );
  }

  /// Construye la barra de aplicación superior
  /// Incluye título y botón de configuración
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Seguimiento de Actividad', // Título en español
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      actions: [
        // Botón de configuración
        IconButton(
          icon: CustomIconWidget(
            iconName: 'settings',
            size: 24.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {}, // TODO: Implementar configuración
        ),
        SizedBox(width: 4.w),
      ],
    );
  }

  /// Construye el cuerpo principal de la pantalla
  /// Incluye resumen diario, controles de entrenamiento y actividades recientes
  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        physics:
            const BouncingScrollPhysics(), // Efecto de rebote al hacer scroll
        child: Column(
          children: [
            _buildDailyOverviewSection(), // Sección de resumen diario
            SizedBox(height: 3.h),
            // Mostrar sección activa o de inicio según el estado del entrenamiento
            _isWorkoutActive
                ? _buildActiveWorkoutSection()
                : _buildStartWorkoutSection(),
            SizedBox(height: 3.h),
            _buildRecentActivitiesSection(), // Sección de actividades recientes
            SizedBox(height: 10.h), // Espacio para el botón flotante
          ],
        ),
      ),
    );
  }

  /// Construye la sección de resumen diario
  /// Muestra pasos del día y calorías quemadas con diseño atractivo
  Widget _buildDailyOverviewSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        // Gradiente de color primario para destacar la información importante
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(204),
            Theme.of(context).colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.sp),
        // Sombra para efecto de elevación
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progreso de Hoy', // Título de la sección
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                SizedBox(height: 1.h),
                // Mostrar pasos del día en texto grande
                Text(
                  '$_dailySteps pasos',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 0.5.h),
                // Mostrar calorías quemadas como información secundaria
                Text(
                  '${_activeCalories.toStringAsFixed(1)} cal quemadas',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withAlpha(230),
                      ),
                ),
              ],
            ),
          ),
          // Icono decorativo de caminar
          CustomIconWidget(
            iconName: 'directions_walk',
            size: 48.sp,
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(204),
          ),
        ],
      ),
    );
  }

  /// Construye la sección para iniciar entrenamiento
  /// Incluye botón principal y selector de tipo de ejercicio
  Widget _buildStartWorkoutSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Botón principal para iniciar entrenamiento
          Container(
            width: double.infinity,
            height: 15.h,
            decoration: BoxDecoration(
              // Gradiente del color secundario para diferenciarlo del resumen
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.secondary.withAlpha(204),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20.sp),
              // Sombra con color secundario para consistencia visual
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(102),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.sp),
                onTap: _startWorkout, // Iniciar entrenamiento al tocar
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de play para indicar acción de inicio
                    CustomIconWidget(
                      iconName: 'play_arrow',
                      size: 48.sp,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Iniciar Entrenamiento', // Texto del botón en español
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Widget para seleccionar tipo de ejercicio
          const ExerciseTypeSelectorWidget(),
        ],
      ),
    );
  }

  /// Construye la sección de entrenamiento activo
  /// Muestra métricas en tiempo real y botón para detener
  Widget _buildActiveWorkoutSection() {
    return AnimatedBuilder(
      animation: _workoutAnimationController,
      builder: (context, child) {
        return Transform.scale(
          // Efecto de escala sutil durante el entrenamiento
          scale: 0.9 + (_workoutAnimationController.value * 0.1),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                // Widget que muestra métricas del entrenamiento en tiempo real
                WorkoutMetricsWidget(
                  duration: _workoutDuration,
                  heartRate: _heartRate,
                  calories: _caloriesBurned,
                  distance: _distance,
                  exerciseType: _selectedExerciseType,
                ),
                SizedBox(height: 2.h),
                // Botón para detener entrenamiento con color de error para indicar acción destructiva
                Container(
                  width: double.infinity,
                  height: 8.h,
                  child: ElevatedButton(
                    onPressed: _stopWorkout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.sp),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icono de detener
                        CustomIconWidget(
                          iconName: 'stop',
                          size: 24.sp,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Detener Entrenamiento', // Texto del botón en español
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                                fontWeight: FontWeight.bold,
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
      },
    );
  }

  /// Construye la sección de actividades recientes
  /// Muestra el historial de entrenamientos y actividades previas
  Widget _buildRecentActivitiesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actividades Recientes', // Título de la sección en español
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 2.h),
          // Widget que muestra cronología de actividades
          const ActivityTimelineWidget(),
        ],
      ),
    );
  }

  /// Construye la barra de navegación inferior
  /// Permite navegar entre las diferentes pantallas principales de la aplicación
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
        // Sombra superior para separar visualmente la navegación
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
        type: BottomNavigationBarType
            .fixed, // Tipo fijo para mostrar todas las pestañas
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.onSurface.withAlpha(153),
        showUnselectedLabels:
            true, // Mostrar etiquetas en pestañas no seleccionadas
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
              // Cambiar color según si está seleccionado
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
