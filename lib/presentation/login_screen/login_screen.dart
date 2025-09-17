import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/health_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometric = false;
  final ScrollController _scrollController = ScrollController();

  // Mock credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {
      "email": "admin@nutritrack.com",
      "password": "admin123",
      "role": "Administrador"
    },
    {
      "email": "usuario@nutritrack.com",
      "password": "usuario123",
      "role": "Usuario"
    },
    {
      "email": "nutricionista@nutritrack.com",
      "password": "nutri123",
      "role": "Nutricionista"
    }
  ];

  @override
  void initState() {
    super.initState();
    // Show biometric option after a delay to simulate first login success
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showBiometric = true;
        });
      }
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));

      // Check mock credentials
      final validCredential = _mockCredentials.firstWhere(
        (cred) => cred['email'] == email && cred['password'] == password,
        orElse: () => {},
      );

      if (validCredential.isNotEmpty) {
        // Success haptic feedback
        HapticFeedback.heavyImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡Bienvenido! Iniciando sesión como ${validCredential['role']}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to dashboard
        await Future.delayed(Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
        }
      } else {
        // Error haptic feedback
        HapticFeedback.heavyImpact();

        // Show error message with mock credentials hint
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Credenciales incorrectas'),
                SizedBox(height: 1.h),
                Text(
                  'Prueba con: admin@nutritrack.com / admin123',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // Network error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión. Verifica tu internet.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate social login process
      await Future.delayed(Duration(seconds: 2));

      HapticFeedback.heavyImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Bienvenido! Iniciando sesión con $provider'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión con $provider'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleBiometricSuccess() {
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Autenticación biométrica exitosa!'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 4.h),

                  // Health Logo
                  HealthLogoWidget(),
                  SizedBox(height: 6.h),

                  // Welcome Text
                  Text(
                    '¡Bienvenido de vuelta!',
                    style:
                        AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Inicia sesión para continuar tu viaje hacia una vida más saludable',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 3.h),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricSuccess: _handleBiometricSuccess,
                    isVisible: _showBiometric && !_isLoading,
                  ),
                  SizedBox(height: 3.h),

                  // Social Login
                  SocialLoginWidget(
                    onSocialLogin: _handleSocialLogin,
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 4.h),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Nuevo en la vida saludable? ',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.pushNamed(
                                    context, '/user-registration-screen');
                              },
                        child: Text(
                          'Regístrate',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}