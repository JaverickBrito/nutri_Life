import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/permission_request_widget.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showPermissions = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'title': 'Registra tus Comidas',
      'description':
          'Toma fotos de tus comidas y registra automáticamente las calorías y nutrientes. Mantén un control preciso de tu alimentación diaria.',
    },
    {
      'imageUrl':
          'https://images.pexels.com/photos/416778/pexels-photo-416778.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'title': 'Rastrea tu Actividad',
      'description':
          'Monitorea tus ejercicios, pasos y actividades físicas. Visualiza tu progreso con gráficos interactivos y anillos de actividad.',
    },
    {
      'imageUrl':
          'https://images.pixabay.com/photo/2017/08/06/12/06/people-2592247_1280.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
      'title': 'Establece Metas',
      'description':
          'Define objetivos personalizados de peso, calorías y actividad física. Recibe recordatorios y consejos para alcanzar tus metas de salud.',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3',
      'title': 'Panel Profesional',
      'description':
          'Los profesionales de la salud pueden monitorear el progreso de sus pacientes y brindar orientación personalizada a través del panel administrativo.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: _showPermissions
            ? PermissionRequestWidget(
                onPermissionsGranted: _completeOnboarding,
              )
            : Column(
                children: [
                  // Skip Button
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _completeOnboarding,
                          child: Text(
                            'Omitir',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Page Content
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _onboardingData.length,
                      itemBuilder: (context, index) {
                        final data = _onboardingData[index];
                        return OnboardingPageWidget(
                          imageUrl: data['imageUrl'],
                          title: data['title'],
                          description: data['description'],
                          isLastPage: index == _onboardingData.length - 1,
                          onGetStarted: _showPermissionScreen,
                        );
                      },
                    ),
                  ),

                  // Page Indicator
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: PageIndicatorWidget(
                      currentPage: _currentPage,
                      totalPages: _onboardingData.length,
                    ),
                  ),

                  // Navigation Buttons
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        _currentPage > 0
                            ? TextButton(
                                onPressed: _previousPage,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'arrow_back_ios',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      'Anterior',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(width: 20.w),

                        // Next Button
                        _currentPage < _onboardingData.length - 1
                            ? ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  foregroundColor:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6.w, vertical: 1.5.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Siguiente',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    CustomIconWidget(
                                      iconName: 'arrow_forward_ios',
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      size: 4.w,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(width: 20.w),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showPermissionScreen() {
    setState(() {
      _showPermissions = true;
    });
  }

  void _completeOnboarding() {
    // Navigate to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
  }
}
