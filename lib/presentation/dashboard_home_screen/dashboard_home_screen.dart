import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/activity_summary_widget.dart';
import './widgets/daily_calorie_progress_widget.dart';
import './widgets/goals_reminders_widget.dart';
import './widgets/meals_summary_widget.dart';
import './widgets/quick_add_menu_widget.dart';
import './widgets/water_intake_widget.dart';

class DashboardHomeScreen extends StatefulWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with TickerProviderStateMixin {
  bool _isRefreshing = false;
  bool _showQuickAddMenu = false;
  int _currentBottomNavIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  // Mock data
  final List<Map<String, dynamic>> _todayMeals = [
    {
      'id': '1',
      'name': 'Avena con frutas',
      'type': 'Desayuno',
      'calories': 320,
      'time': '08:30',
    },
    {
      'id': '2',
      'name': 'Ensalada César',
      'type': 'Almuerzo',
      'calories': 450,
      'time': '13:15',
    },
    {
      'id': '3',
      'name': 'Yogurt griego',
      'type': 'Snack',
      'calories': 150,
      'time': '16:00',
    },
  ];

  final List<Map<String, dynamic>> _goals = [
    {
      'id': '1',
      'title': 'Perder 5kg en 3 meses',
      'category': 'Peso',
      'progress': 0.4,
      'completed': false,
      'dueDate': DateTime.now().add(Duration(days: 45)),
    },
    {
      'id': '2',
      'title': 'Ejercitarse 5 días por semana',
      'category': 'Ejercicio',
      'progress': 0.7,
      'completed': false,
      'dueDate': DateTime.now().add(Duration(days: 7)),
    },
  ];

  final List<Map<String, dynamic>> _reminders = [
    {
      'id': '1',
      'title': 'Tomar vitaminas',
      'type': 'Medicamento',
      'scheduledTime': DateTime.now().add(Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'Beber agua',
      'type': 'Agua',
      'scheduledTime': DateTime.now().add(Duration(minutes: 30)),
    },
    {
      'id': '3',
      'title': 'Caminata vespertina',
      'type': 'Ejercicio',
      'scheduledTime': DateTime.now().subtract(Duration(minutes: 15)),
    },
  ];

  int _consumedCalories = 920;
  int _targetCalories = 2000;
  int _steps = 7850;
  int _targetSteps = 10000;
  int _exerciseMinutes = 25;
  int _targetExerciseMinutes = 60;
  int _waterIntake = 6;
  int _targetWaterIntake = 8;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate data refresh
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _incrementWaterIntake() {
    setState(() {
      _waterIntake = (_waterIntake + 1).clamp(0, _targetWaterIntake + 5);
    });
  }

  void _showQuickAddMenuDialog() {
    setState(() {
      _showQuickAddMenu = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickAddMenuWidget(
        onAddMeal: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/meal-logging-screen');
        },
        onAddWater: () {
          Navigator.pop(context);
          _incrementWaterIntake();
        },
        onAddExercise: () {
          Navigator.pop(context);
          // Navigate to exercise logging
        },
        onAddWeight: () {
          Navigator.pop(context);
          // Navigate to weight logging
        },
        onClose: () {
          Navigator.pop(context);
        },
      ),
    ).then((_) {
      setState(() {
        _showQuickAddMenu = false;
      });
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
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
    return '${now.day} de ${months[now.month - 1]}, ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_getGreeting()}, María',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                _getCurrentDate(),
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to notifications
                                },
                                child: Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.lightTheme.shadowColor,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: CustomIconWidget(
                                          iconName: 'notifications',
                                          color: AppTheme
                                              .lightTheme.colorScheme.onSurface,
                                          size: 20,
                                        ),
                                      ),
                                      Positioned(
                                        top: 2.w,
                                        right: 2.w,
                                        child: Container(
                                          width: 2.w,
                                          height: 2.w,
                                          decoration: BoxDecoration(
                                            color: AppTheme
                                                .lightTheme.colorScheme.error,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              GestureDetector(
                                onTap: () {
                                  // Navigate to profile
                                },
                                child: Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.lightTheme.shadowColor,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: CustomImageWidget(
                                      imageUrl:
                                          'https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
                                      width: 12.w,
                                      height: 12.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Main content
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Daily calorie progress
                    DailyCalorieProgressWidget(
                      consumedCalories: _consumedCalories,
                      targetCalories: _targetCalories,
                      onTap: () {
                        // Navigate to calorie details
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Meals summary
                    MealsSummaryWidget(
                      todayMeals: _todayMeals,
                      onAddMeal: () {
                        Navigator.pushNamed(context, '/meal-logging-screen');
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Activity summary
                    ActivitySummaryWidget(
                      steps: _steps,
                      targetSteps: _targetSteps,
                      exerciseMinutes: _exerciseMinutes,
                      targetExerciseMinutes: _targetExerciseMinutes,
                      onTap: () {
                        // Navigate to activity details
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Water intake
                    WaterIntakeWidget(
                      currentIntake: _waterIntake,
                      targetIntake: _targetWaterIntake,
                      onIncrement: _incrementWaterIntake,
                    ),
                    SizedBox(height: 3.h),

                    // Goals and reminders
                    GoalsRemindersWidget(
                      goals: _goals,
                      reminders: _reminders,
                      onGoalTap: (goalId) {
                        // Navigate to goal details
                      },
                      onReminderTap: (reminderId) {
                        // Handle reminder tap
                      },
                    ),
                    SizedBox(height: 10.h), // Extra space for FAB
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton(
              onPressed: _showQuickAddMenuDialog,
              backgroundColor: AppTheme.lightTheme.primaryColor,
              child: CustomIconWidget(
                iconName: _showQuickAddMenu ? 'close' : 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 24,
              ),
            ),
          );
        },
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });

          // Handle navigation
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              Navigator.pushNamed(context, '/meal-logging-screen');
              break;
            case 2:
              // Navigate to activity screen
              break;
            case 3:
              // Navigate to progress screen
              break;
            case 4:
              // Navigate to profile screen
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentBottomNavIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'restaurant',
              color: _currentBottomNavIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Comidas',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'fitness_center',
              color: _currentBottomNavIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'trending_up',
              color: _currentBottomNavIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Progreso',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentBottomNavIndex == 4
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
