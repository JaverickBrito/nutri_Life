import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_export.dart';
import './widgets/basic_info_step.dart';
import './widgets/goals_preferences_step.dart';
import './widgets/health_metrics_step.dart';
import './widgets/profile_photo_section.dart';
import './widgets/registration_step_indicator.dart';
import './widgets/terms_privacy_section.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  final int _totalSteps = 3;
  bool _isLoading = false;

  // Form keys
  final GlobalKey<FormState> _basicInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _healthMetricsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _goalsFormKey = GlobalKey<FormState>();

  // Basic Info Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Health Metrics Data
  int _selectedAge = 0;
  String _selectedGender = '';
  double _selectedHeight = 0.0;
  double _selectedWeight = 0.0;
  String _selectedActivityLevel = '';

  // Goals and Preferences Data
  String _selectedWeightGoal = '';
  List<String> _selectedDietaryPreferences = [];
  Map<String, bool> _notificationPreferences = {
    'meal_reminders': true,
    'water_reminders': true,
    'exercise_reminders': false,
    'health_tips': true,
  };

  // Terms and Profile Photo
  bool _isTermsAccepted = false;
  XFile? _selectedProfileImage;

  // Animation Controllers
  late AnimationController _welcomeAnimationController;
  late Animation<double> _welcomeScaleAnimation;
  late Animation<double> _welcomeOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _welcomeAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _welcomeScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.elasticOut,
    ));

    _welcomeOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _welcomeAnimationController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _basicInfoFormKey.currentState?.validate() ?? false;
      case 2:
        if (!_healthMetricsFormKey.currentState!.validate()) return false;
        if (_selectedAge == 0) {
          _showErrorMessage('Por favor selecciona tu edad');
          return false;
        }
        if (_selectedGender.isEmpty) {
          _showErrorMessage('Por favor selecciona tu género');
          return false;
        }
        if (_selectedHeight == 0.0) {
          _showErrorMessage('Por favor selecciona tu altura');
          return false;
        }
        if (_selectedWeight == 0.0) {
          _showErrorMessage('Por favor selecciona tu peso');
          return false;
        }
        if (_selectedActivityLevel.isEmpty) {
          _showErrorMessage('Por favor selecciona tu nivel de actividad');
          return false;
        }
        return true;
      case 3:
        if (_selectedWeightGoal.isEmpty) {
          _showErrorMessage('Por favor selecciona tu objetivo de peso');
          return false;
        }
        if (!_isTermsAccepted) {
          _showErrorMessage('Debes aceptar los términos y condiciones');
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _totalSteps) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeRegistration();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeRegistration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate registration process
      await Future.delayed(Duration(seconds: 2));

      // Check for duplicate email (mock validation)
      if (_emailController.text.toLowerCase() == 'test@nutritrack.com') {
        throw Exception('Este correo electrónico ya está registrado');
      }

      // Show welcome animation
      await _showWelcomeAnimation();

      // Navigate to onboarding
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding-flow-screen');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showWelcomeAnimation() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AnimatedBuilder(
        animation: _welcomeAnimationController,
        builder: (context, child) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: _welcomeScaleAnimation.value,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'check',
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),
                Opacity(
                  opacity: _welcomeOpacityAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        '¡Bienvenido a NutriTrack Pro!',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Tu cuenta ha sido creada exitosamente. Comencemos tu viaje hacia una vida más saludable.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
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

    _welcomeAnimationController.forward();
    await Future.delayed(Duration(seconds: 2));
  }

  void _showTermsOfService() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Términos de Servicio'),
            leading: IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadHtmlString('''
                <html>
                  <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                      body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; padding: 20px; line-height: 1.6; }
                      h1 { color: #2E7D5A; }
                      h2 { color: #1E5A3F; margin-top: 30px; }
                    </style>
                  </head>
                  <body>
                    <h1>Términos de Servicio - NutriTrack Pro</h1>
                    <h2>1. Aceptación de Términos</h2>
                    <p>Al usar NutriTrack Pro, aceptas estos términos de servicio...</p>
                    <h2>2. Uso de la Aplicación</h2>
                    <p>NutriTrack Pro está diseñado para ayudarte a monitorear tu nutrición y actividad física...</p>
                    <h2>3. Privacidad y Datos</h2>
                    <p>Respetamos tu privacidad y protegemos tus datos de salud...</p>
                  </body>
                </html>
              '''),
          ),
        ),
      ),
    );
  }

  void _showPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Política de Privacidad'),
            leading: IconButton(
              icon: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..loadHtmlString('''
                <html>
                  <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <style>
                      body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; padding: 20px; line-height: 1.6; }
                      h1 { color: #2E7D5A; }
                      h2 { color: #1E5A3F; margin-top: 30px; }
                    </style>
                  </head>
                  <body>
                    <h1>Política de Privacidad - NutriTrack Pro</h1>
                    <h2>1. Información que Recopilamos</h2>
                    <p>Recopilamos información de salud y fitness para personalizar tu experiencia...</p>
                    <h2>2. Cómo Usamos tu Información</h2>
                    <p>Utilizamos tus datos para proporcionar recomendaciones personalizadas...</p>
                    <h2>3. Protección de Datos</h2>
                    <p>Implementamos medidas de seguridad para proteger tu información...</p>
                  </body>
                </html>
              '''),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Cancel and Step Counter
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Text(
                    '$_currentStep de $_totalSteps',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Indicator
            RegistrationStepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),

            // Form Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Basic Information
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: BasicInfoStep(
                      formKey: _basicInfoFormKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      onNameChanged: (value) => setState(() {}),
                      onEmailChanged: (value) => setState(() {}),
                      onPasswordChanged: (value) => setState(() {}),
                      onConfirmPasswordChanged: (value) => setState(() {}),
                    ),
                  ),

                  // Step 2: Health Metrics
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: HealthMetricsStep(
                      formKey: _healthMetricsFormKey,
                      selectedAge: _selectedAge,
                      selectedGender: _selectedGender,
                      selectedHeight: _selectedHeight,
                      selectedWeight: _selectedWeight,
                      selectedActivityLevel: _selectedActivityLevel,
                      onAgeChanged: (age) => setState(() => _selectedAge = age),
                      onGenderChanged: (gender) =>
                          setState(() => _selectedGender = gender),
                      onHeightChanged: (height) =>
                          setState(() => _selectedHeight = height),
                      onWeightChanged: (weight) =>
                          setState(() => _selectedWeight = weight),
                      onActivityLevelChanged: (level) =>
                          setState(() => _selectedActivityLevel = level),
                    ),
                  ),

                  // Step 3: Goals and Preferences
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        GoalsPreferencesStep(
                          formKey: _goalsFormKey,
                          selectedWeightGoal: _selectedWeightGoal,
                          selectedDietaryPreferences:
                              _selectedDietaryPreferences,
                          notificationPreferences: _notificationPreferences,
                          onWeightGoalChanged: (goal) =>
                              setState(() => _selectedWeightGoal = goal),
                          onDietaryPreferenceToggled: (preference) {
                            setState(() {
                              if (_selectedDietaryPreferences
                                  .contains(preference)) {
                                _selectedDietaryPreferences.remove(preference);
                              } else {
                                _selectedDietaryPreferences.add(preference);
                              }
                            });
                          },
                          onNotificationPreferenceChanged: (key, value) {
                            setState(() {
                              _notificationPreferences[key] = value;
                            });
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Profile Photo Section
                        ProfilePhotoSection(
                          selectedImage: _selectedProfileImage,
                          onImageSelected: (image) {
                            setState(() {
                              _selectedProfileImage = image;
                            });
                          },
                        ),

                        SizedBox(height: 3.h),

                        // Terms and Privacy Section
                        TermsPrivacySection(
                          isTermsAccepted: _isTermsAccepted,
                          onTermsAcceptedChanged: (value) {
                            setState(() {
                              _isTermsAccepted = value;
                            });
                          },
                          onTermsPressed: _showTermsOfService,
                          onPrivacyPressed: _showPrivacyPolicy,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation Buttons
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  if (_currentStep > 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Text('Anterior'),
                      ),
                    ),
                  if (_currentStep > 1) SizedBox(width: 4.w),
                  Expanded(
                    flex: _currentStep == 1 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextStep,
                      child: _isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_currentStep == _totalSteps
                              ? 'Crear Cuenta'
                              : 'Continuar'),
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
}
