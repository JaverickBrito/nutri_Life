import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_settings_section_widget.dart';
import './widgets/app_preferences_section_widget.dart';
import './widgets/connected_services_widget.dart';
import './widgets/health_metrics_section_widget.dart';
import './widgets/personal_info_section_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/subscription_management_widget.dart';
import './widgets/support_section_widget.dart';

/// Pantalla de perfil de usuario y configuración
/// Esta pantalla permite a los usuarios:
/// - Ver y editar información personal y de salud
/// - Gestionar configuraciones de notificaciones y preferencias de la app
/// - Conectar servicios externos de salud (Google Fit, Apple Health, etc.)
/// - Administrar suscripción y facturación
/// - Acceder a soporte técnico y ayuda
/// - Cambiar foto de perfil usando cámara o galería
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = false; // Estado de carga para operaciones asíncronas
  int _currentBottomNavIndex =
      4; // Índice de navegación inferior (Perfil activo)

  // Datos del usuario con información personal y de salud
  Map<String, dynamic> _userData = {
    'name': 'María González',
    'email': 'maria.gonzalez@email.com',
    'phone': '+34 612 345 678',
    'profileImage':
        'https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
    'membershipStatus': 'Premium', // Estado de membresía del usuario
    'age': 28,
    'height': 165, // Altura en centímetros
    'weight': 62, // Peso en kilogramos
    'activityLevel': 'Moderado', // Nivel de actividad física
    'dietaryPreferences': [
      'Vegetariana',
      'Sin gluten'
    ], // Preferencias dietéticas
    'allergens': ['Nueces', 'Mariscos'], // Alergias alimentarias
  };

  // Configuraciones de notificaciones del usuario
  Map<String, bool> _notificationSettings = {
    'mealReminders': true, // Recordatorios de comidas
    'waterReminders': true, // Recordatorios de hidratación
    'exerciseReminders': false, // Recordatorios de ejercicio
    'progressUpdates': true, // Actualizaciones de progreso
    'socialUpdates': false, // Actualizaciones sociales
  };

  // Preferencias generales de la aplicación
  Map<String, String> _appPreferences = {
    'theme': 'light', // Tema visual (claro/oscuro)
    'language': 'español', // Idioma de la aplicación
    'units': 'metric', // Sistema de unidades (métrico/imperial)
  };

  // Estado de servicios externos conectados
  Map<String, bool> _connectedServices = {
    'googleFit': true, // Google Fit conectado
    'appleHealth': false, // Apple Health desconectado
    'fitbit': true, // Fitbit conectado
    'strava': false, // Strava desconectado
    'myFitnessPal': false, // MyFitnessPal desconectado
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        // Usar CustomScrollView para mejor control del scroll con header
        child: CustomScrollView(
          slivers: [
            // Header del perfil con imagen y información básica
            SliverToBoxAdapter(
              child: ProfileHeaderWidget(
                name: _userData['name'],
                membershipStatus: _userData['membershipStatus'],
                profileImageUrl: _userData['profileImage'],
                onEditPhoto: _handleEditProfilePhoto,
              ),
            ),

            // Contenido principal del perfil con secciones configurables
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 3.h),

                  // Sección de información personal (nombre, email, teléfono)
                  PersonalInfoSectionWidget(
                    userData: _userData,
                    onEdit: _handleEditPersonalInfo,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de métricas de salud (peso, altura, preferencias dietéticas)
                  HealthMetricsSectionWidget(
                    userData: _userData,
                    onEdit: _handleEditHealthMetrics,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de configuraciones de cuenta y privacidad
                  AccountSettingsSectionWidget(
                    notificationSettings: _notificationSettings,
                    onNotificationChange: _handleNotificationChange,
                    onChangePassword: _handleChangePassword,
                    onPrivacySettings: _handlePrivacySettings,
                    onExportData: _handleExportData,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de preferencias de la aplicación
                  AppPreferencesSectionWidget(
                    preferences: _appPreferences,
                    onPreferenceChange: _handlePreferenceChange,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de servicios conectados (Google Fit, Fitbit, etc.)
                  ConnectedServicesWidget(
                    connectedServices: _connectedServices,
                    onServiceToggle: _handleServiceToggle,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de gestión de suscripción y facturación
                  SubscriptionManagementWidget(
                    membershipStatus: _userData['membershipStatus'],
                    onUpgrade: _handleUpgradeSubscription,
                    onViewBilling: _handleViewBillingHistory,
                  ),
                  SizedBox(height: 3.h),

                  // Sección de soporte técnico y ayuda
                  SupportSectionWidget(
                    onFAQ: _handleFAQ,
                    onContact: _handleContactSupport,
                    onAbout: _handleAboutApp,
                  ),
                  SizedBox(height: 3.h),

                  // Botón de cerrar sesión con estilo de advertencia
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    child: ElevatedButton(
                      onPressed: _handleLogout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.colorScheme.error,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onError,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Cerrar Sesión'),
                    ),
                  ),
                  SizedBox(
                      height:
                          10.h), // Espacio adicional para navegación inferior
                ]),
              ),
            ),
          ],
        ),
      ),

      // Barra de navegación inferior para moverse entre pantallas principales
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          if (index != _currentBottomNavIndex) {
            setState(() {
              _currentBottomNavIndex = index;
            });

            // Manejar navegación entre pantallas
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(
                    context, AppRoutes.dashboardHome);
                break;
              case 1:
                Navigator.pushNamed(context, AppRoutes.mealLogging);
                break;
              case 2:
                Navigator.pushNamed(context, AppRoutes.activityTracking);
                break;
              case 3:
                Navigator.pushNamed(context, AppRoutes.progressAnalytics);
                break;
              case 4:
                // Ya estamos en el perfil
                break;
            }
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

  /// Maneja la edición de la foto de perfil
  /// Muestra opciones para capturar con cámara o seleccionar de galería
  Future<void> _handleEditProfilePhoto() async {
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
              'Cambiar foto de perfil',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Opción para capturar con cámara
                _buildPhotoOption(
                  icon: 'camera_alt',
                  label: 'Cámara',
                  onTap: () async {
                    Navigator.pop(context);
                    await _captureFromCamera();
                  },
                ),
                // Opción para seleccionar de galería
                _buildPhotoOption(
                  icon: 'photo_library',
                  label: 'Galería',
                  onTap: () async {
                    Navigator.pop(context);
                    await _selectFromGallery();
                  },
                ),
              ],
            ),
            SizedBox(height: 3.h),
          ],
        ),
      ),
    );
  }

  /// Construye una opción de selección de foto con icono y etiqueta
  Widget _buildPhotoOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Contenedor circular con icono
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          SizedBox(height: 1.h),
          // Etiqueta descriptiva
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  /// Captura una foto usando la cámara del dispositivo
  /// Requiere permisos de cámara en dispositivos móviles
  Future<void> _captureFromCamera() async {
    try {
      // Solicitar permisos de cámara
      if (await Permission.camera.request().isGranted) {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.camera);

        if (image != null) {
          // Actualizar la imagen de perfil con la nueva foto
          setState(() {
            _userData['profileImage'] = image.path;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Foto actualizada correctamente')),
          );
        }
      }
    } catch (e) {
      // Manejar errores de captura de cámara
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar foto')),
      );
    }
  }

  /// Selecciona una imagen de la galería del dispositivo
  /// No requiere permisos especiales en versiones recientes de móviles
  Future<void> _selectFromGallery() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Actualizar la imagen de perfil con la imagen seleccionada
        setState(() {
          _userData['profileImage'] = image.path;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto actualizada correctamente')),
        );
      }
    } catch (e) {
      // Manejar errores de selección de galería
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar foto')),
      );
    }
  }

  /// Maneja la edición de información personal
  /// Podría navegar a una pantalla de edición o mostrar un diálogo
  void _handleEditPersonalInfo() {
    // TODO: Implementar pantalla de edición de información personal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función de edición próximamente')),
    );
  }

  /// Maneja la edición de métricas de salud
  /// Permite modificar peso, altura, preferencias dietéticas, etc.
  void _handleEditHealthMetrics() {
    // TODO: Implementar pantalla de edición de métricas de salud
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función de edición próximamente')),
    );
  }

  /// Maneja cambios en configuraciones de notificaciones
  /// Actualiza el estado y guarda las preferencias del usuario
  void _handleNotificationChange(String key, bool value) {
    setState(() {
      _notificationSettings[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configuración de notificaciones actualizada')),
    );
  }

  /// Maneja el cambio de contraseña del usuario
  void _handleChangePassword() {
    // TODO: Implementar pantalla de cambio de contraseña
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja la configuración de privacidad y seguridad
  void _handlePrivacySettings() {
    // TODO: Implementar pantalla de configuración de privacidad
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja la exportación de datos del usuario
  /// Permite descargar información personal en formato legible
  void _handleExportData() {
    // TODO: Implementar exportación de datos
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exportando datos...')),
    );
  }

  /// Maneja cambios en las preferencias generales de la app
  void _handlePreferenceChange(String key, String value) {
    setState(() {
      _appPreferences[key] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferencia actualizada')),
    );
  }

  /// Maneja la conexión/desconexión de servicios externos
  /// Permite integrar con Google Fit, Fitbit, Strava, etc.
  void _handleServiceToggle(String service, bool value) {
    setState(() {
      _connectedServices[service] = value;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text(value ? 'Servicio conectado' : 'Servicio desconectado')),
    );
  }

  /// Maneja la actualización de suscripción a versión premium
  void _handleUpgradeSubscription() {
    // TODO: Implementar proceso de actualización de suscripción
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja la visualización del historial de facturación
  void _handleViewBillingHistory() {
    // TODO: Implementar pantalla de historial de facturación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja el acceso a preguntas frecuentes
  void _handleFAQ() {
    // TODO: Implementar pantalla de FAQ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja el contacto con soporte técnico
  void _handleContactSupport() {
    // TODO: Implementar sistema de contacto con soporte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Función próximamente')),
    );
  }

  /// Maneja la información "Acerca de" la aplicación
  /// Muestra versión, desarrollador y información legal
  void _handleAboutApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Acerca de NutriTrack Pro'),
        content: Text(
            'Versión 1.0.0\n\nAplicación de seguimiento nutricional desarrollada para ayudarte a alcanzar tus objetivos de salud.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  /// Maneja el cierre de sesión del usuario
  /// Muestra diálogo de confirmación antes de proceder
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cerrar Sesión'),
        content: Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          // Botón para cancelar la acción
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          // Botón para confirmar el cierre de sesión
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pushReplacementNamed(
                  context, AppRoutes.login); // Ir a login
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
