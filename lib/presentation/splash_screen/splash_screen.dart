import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showRetryOption = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _animationController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    try {
      setState(() {
        _isInitializing = true;
        _showRetryOption = false;
      });

      // Simulate initialization tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _syncCachedNutritionData(),
        _loadUserPreferences(),
        _prepareOfflineDatabase(),
      ]).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Initialization timeout');
        },
      );

      // Navigate based on authentication status
      await _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _showRetryOption = true;
        _isInitializing = false;
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate checking authentication
  }

  Future<void> _syncCachedNutritionData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulate syncing nutrition data
  }

  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 400));
    // Simulate loading user preferences
  }

  Future<void> _prepareOfflineDatabase() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Simulate preparing offline database
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Simulate authentication check
    final bool isAuthenticated = false; // Mock authentication status
    final bool isFirstTime = true; // Mock first time user check

    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
    } else if (isFirstTime) {
      Navigator.pushReplacementNamed(context, '/onboarding-flow-screen');
    } else {
      Navigator.pushReplacementNamed(context, '/login-screen');
    }
  }

  void _retryInitialization() {
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.primaryColor.withValues(alpha: 0.8),
                AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.6),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'restaurant',
                                          color:
                                              AppTheme.lightTheme.primaryColor,
                                          size: 8.w,
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'NT',
                                          style: GoogleFonts.inter(
                                            fontSize: 6.w,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'NutriTrack Pro',
                                  style: GoogleFonts.inter(
                                    fontSize: 7.w,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Tu compañero de nutrición inteligente',
                                  style: GoogleFonts.inter(
                                    fontSize: 3.5.w,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _showRetryOption
                          ? _buildRetrySection()
                          : _buildLoadingSection(),
                      SizedBox(height: 4.h),
                      Text(
                        'Versión 1.0.0',
                        style: GoogleFonts.inter(
                          fontSize: 2.8.w,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        SizedBox(
          width: 8.w,
          height: 8.w,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          _isInitializing
              ? 'Inicializando servicios de salud...'
              : 'Cargando...',
          style: GoogleFonts.inter(
            fontSize: 3.2.w,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRetrySection() {
    return Column(
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: Colors.white.withValues(alpha: 0.9),
          size: 8.w,
        ),
        SizedBox(height: 2.h),
        Text(
          'Error de conexión',
          style: GoogleFonts.inter(
            fontSize: 4.w,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'No se pudo conectar con los servicios.\nVerifica tu conexión a internet.',
          style: GoogleFonts.inter(
            fontSize: 3.w,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        ElevatedButton(
          onPressed: _retryInitialization,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppTheme.lightTheme.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
            elevation: 4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.primaryColor,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Reintentar',
                style: GoogleFonts.inter(
                  fontSize: 3.5.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}