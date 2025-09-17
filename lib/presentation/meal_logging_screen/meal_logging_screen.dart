import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_capture_widget.dart';
import './widgets/food_search_widget.dart';
import './widgets/meal_summary_widget.dart';
import './widgets/meal_type_selector_widget.dart';
import './widgets/recent_foods_widget.dart';
import './widgets/serving_size_selector_widget.dart';

class MealLoggingScreen extends StatefulWidget {
  const MealLoggingScreen({Key? key}) : super(key: key);

  @override
  State<MealLoggingScreen> createState() => _MealLoggingScreenState();
}

class _MealLoggingScreenState extends State<MealLoggingScreen> {
  String selectedMealType = 'Desayuno';
  String searchQuery = '';
  List<Map<String, dynamic>> selectedFoods = [];
  bool showServingSelector = false;
  String selectedFoodName = '';
  Map<String, dynamic> selectedFoodData = {};
  XFile? capturedImage;
  bool isProcessingImage = false;

  final List<Map<String, dynamic>> spanishFoodDatabase = [
    {
      "name": "Arroz con pollo",
      "calories": 320,
      "servingSize": "1 taza (200g)",
      "protein": 25.0,
      "carbs": 45.0,
      "fats": 8.0,
      "category": "Platos principales"
    },
    {
      "name": "Paella valenciana",
      "calories": 380,
      "servingSize": "1 porción (250g)",
      "protein": 22.0,
      "carbs": 52.0,
      "fats": 12.0,
      "category": "Platos principales"
    },
    {
      "name": "Tortilla española",
      "calories": 280,
      "servingSize": "1 porción (150g)",
      "protein": 18.0,
      "carbs": 20.0,
      "fats": 16.0,
      "category": "Platos principales"
    },
    {
      "name": "Gazpacho andaluz",
      "calories": 85,
      "servingSize": "1 taza (250ml)",
      "protein": 3.0,
      "carbs": 12.0,
      "fats": 3.5,
      "category": "Sopas"
    },
    {
      "name": "Pan tostado integral",
      "calories": 120,
      "servingSize": "2 rebanadas (60g)",
      "protein": 5.0,
      "carbs": 22.0,
      "fats": 2.0,
      "category": "Cereales"
    },
    {
      "name": "Café con leche",
      "calories": 90,
      "servingSize": "1 taza (200ml)",
      "protein": 4.0,
      "carbs": 8.0,
      "fats": 4.5,
      "category": "Bebidas"
    },
    {
      "name": "Jamón serrano",
      "calories": 180,
      "servingSize": "50g",
      "protein": 28.0,
      "carbs": 0.0,
      "fats": 7.0,
      "category": "Carnes"
    },
    {
      "name": "Queso manchego",
      "calories": 200,
      "servingSize": "50g",
      "protein": 15.0,
      "carbs": 1.0,
      "fats": 16.0,
      "category": "Lácteos"
    },
    {
      "name": "Aceitunas verdes",
      "calories": 75,
      "servingSize": "10 unidades (30g)",
      "protein": 1.0,
      "carbs": 2.0,
      "fats": 7.5,
      "category": "Snacks"
    },
    {
      "name": "Plátano",
      "calories": 105,
      "servingSize": "1 unidad mediana (120g)",
      "protein": 1.3,
      "carbs": 27.0,
      "fats": 0.4,
      "category": "Frutas"
    },
  ];

  String get currentTime {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _onMealTypeChanged(String mealType) {
    setState(() {
      selectedMealType = mealType;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void _onFoodSelected(String foodName) {
    final foodData = spanishFoodDatabase.firstWhere(
      (food) => food['name'] == foodName,
      orElse: () => {
        "name": foodName,
        "calories": 100,
        "servingSize": "1 porción (100g)",
        "protein": 5.0,
        "carbs": 15.0,
        "fats": 3.0,
        "category": "Otros"
      },
    );

    setState(() {
      selectedFoodName = foodName;
      selectedFoodData = foodData;
      showServingSelector = true;
    });
  }

  void _onServingConfirmed(Map<String, dynamic> servingData) {
    setState(() {
      selectedFoods.add(servingData);
      showServingSelector = false;
      selectedFoodName = '';
      selectedFoodData = {};
    });

    Fluttertoast.showToast(
      msg: "Alimento agregado al registro",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onCancelServing() {
    setState(() {
      showServingSelector = false;
      selectedFoodName = '';
      selectedFoodData = {};
    });
  }

  void _onRemoveFood(int index) {
    setState(() {
      selectedFoods.removeAt(index);
    });

    Fluttertoast.showToast(
      msg: "Alimento eliminado del registro",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onImageCaptured(XFile image) {
    setState(() {
      capturedImage = image;
      isProcessingImage = true;
    });

    // Simulate AI food recognition processing
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isProcessingImage = false;
        });

        // Simulate recognized food
        _showRecognizedFoodDialog();
      }
    });
  }

  void _showRecognizedFoodDialog() {
    final recognizedFoods = [
      'Arroz con pollo',
      'Tortilla española',
      'Pan tostado integral',
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Alimentos reconocidos',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hemos identificado estos alimentos en tu foto:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              ...recognizedFoods
                  .map((food) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CustomIconWidget(
                          iconName: 'restaurant',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        title: Text(
                          food,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _onFoodSelected(food);
                          },
                          child: Text('Agregar'),
                        ),
                      ))
                  .toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Show manual entry option
                _showManualEntryDialog();
              },
              child: Text('Entrada manual'),
            ),
          ],
        );
      },
    );
  }

  void _showManualEntryDialog() {
    final TextEditingController foodNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Entrada manual',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ingresa el nombre del alimento manualmente:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: foodNameController,
                decoration: InputDecoration(
                  hintText: 'Nombre del alimento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (foodNameController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  _onFoodSelected(foodNameController.text);
                }
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _onSaveMeal() {
    if (selectedFoods.isEmpty) {
      Fluttertoast.showToast(
        msg: "Agrega al menos un alimento para guardar la comida",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Simulate saving meal to database
    final mealData = {
      'mealType': selectedMealType,
      'foods': selectedFoods,
      'timestamp': DateTime.now(),
      'totalCalories': selectedFoods.fold(
          0.0, (sum, food) => sum + (food['calories'] as double)),
    };

    // Clear the form
    setState(() {
      selectedFoods.clear();
      searchQuery = '';
      capturedImage = null;
    });

    Fluttertoast.showToast(
      msg: "Comida guardada exitosamente",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );

    // Navigate back to dashboard
    Navigator.pushReplacementNamed(context, '/dashboard-home-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Registro de Comidas',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Show barcode scanner
              _showBarcodeScanner();
            },
            child: Container(
              margin: EdgeInsets.all(2.w),
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal Type Selector
                MealTypeSelectorWidget(
                  selectedMealType: selectedMealType,
                  onMealTypeChanged: _onMealTypeChanged,
                  currentTime: currentTime,
                ),

                SizedBox(height: 3.h),

                // Camera Capture Section
                if (isProcessingImage)
                  Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Analizando imagen...',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Reconociendo alimentos con IA',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  CameraCaptureWidget(
                    onImageCaptured: _onImageCaptured,
                  ),

                SizedBox(height: 3.h),

                // Food Search Section
                FoodSearchWidget(
                  onFoodSelected: _onFoodSelected,
                  onSearchChanged: _onSearchChanged,
                  searchQuery: searchQuery,
                ),

                SizedBox(height: 3.h),

                // Recent Foods Section
                RecentFoodsWidget(
                  onFoodSelected: _onFoodSelected,
                ),

                SizedBox(height: 3.h),

                // Meal Summary Section
                MealSummaryWidget(
                  selectedFoods: selectedFoods,
                  onRemoveFood: _onRemoveFood,
                  onSaveMeal: _onSaveMeal,
                ),

                SizedBox(height: 10.h), // Extra space for bottom sheet
              ],
            ),
          ),

          // Serving Size Selector Overlay
          if (showServingSelector)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(4.w),
                  constraints: BoxConstraints(
                    maxHeight: 80.h,
                  ),
                  child: SingleChildScrollView(
                    child: ServingSizeSelectorWidget(
                      foodName: selectedFoodName,
                      foodData: selectedFoodData,
                      onServingConfirmed: _onServingConfirmed,
                      onCancel: _onCancelServing,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showBarcodeScanner() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Escáner de códigos',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'qr_code_2',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 48,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Apunta la cámara al código de barras',
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
              ),
              SizedBox(height: 2.h),
              Text(
                'El escáner identificará automáticamente productos empaquetados',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
