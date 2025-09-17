import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServingSizeSelectorWidget extends StatefulWidget {
  final String foodName;
  final Map<String, dynamic> foodData;
  final Function(Map<String, dynamic>) onServingConfirmed;
  final VoidCallback onCancel;

  const ServingSizeSelectorWidget({
    Key? key,
    required this.foodName,
    required this.foodData,
    required this.onServingConfirmed,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ServingSizeSelectorWidget> createState() =>
      _ServingSizeSelectorWidgetState();
}

class _ServingSizeSelectorWidgetState extends State<ServingSizeSelectorWidget> {
  String selectedUnit = 'gramos';
  double quantity = 1.0;
  final TextEditingController _quantityController = TextEditingController();

  final List<Map<String, dynamic>> servingUnits = [
    {'unit': 'gramos', 'multiplier': 1.0, 'icon': 'scale'},
    {'unit': 'tazas', 'multiplier': 200.0, 'icon': 'local_cafe'},
    {'unit': 'piezas', 'multiplier': 100.0, 'icon': 'fiber_manual_record'},
    {'unit': 'cucharadas', 'multiplier': 15.0, 'icon': 'restaurant'},
  ];

  @override
  void initState() {
    super.initState();
    _quantityController.text = quantity.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  double get totalCalories {
    final baseCalories = (widget.foodData["calories"] as num).toDouble();
    final multiplier = servingUnits.firstWhere(
      (unit) => unit['unit'] == selectedUnit,
      orElse: () => servingUnits.first,
    )['multiplier'] as double;

    return (baseCalories * quantity * multiplier) / 100.0;
  }

  double get totalProtein {
    final baseProtein = (widget.foodData["protein"] as num).toDouble();
    final multiplier = servingUnits.firstWhere(
      (unit) => unit['unit'] == selectedUnit,
      orElse: () => servingUnits.first,
    )['multiplier'] as double;

    return (baseProtein * quantity * multiplier) / 100.0;
  }

  double get totalCarbs {
    final baseCarbs = (widget.foodData["carbs"] as num).toDouble();
    final multiplier = servingUnits.firstWhere(
      (unit) => unit['unit'] == selectedUnit,
      orElse: () => servingUnits.first,
    )['multiplier'] as double;

    return (baseCarbs * quantity * multiplier) / 100.0;
  }

  double get totalFats {
    final baseFats = (widget.foodData["fats"] as num).toDouble();
    final multiplier = servingUnits.firstWhere(
      (unit) => unit['unit'] == selectedUnit,
      orElse: () => servingUnits.first,
    )['multiplier'] as double;

    return (baseFats * quantity * multiplier) / 100.0;
  }

  void _updateQuantity(String value) {
    final newQuantity = double.tryParse(value);
    if (newQuantity != null && newQuantity > 0) {
      setState(() {
        quantity = newQuantity;
      });
    }
  }

  void _confirmServing() {
    final servingData = {
      'name': widget.foodName,
      'quantity': quantity,
      'unit': selectedUnit,
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fats': totalFats,
      'timestamp': DateTime.now(),
    };

    widget.onServingConfirmed(servingData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.foodName,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: widget.onCancel,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Quantity Input
          Text(
            'Cantidad',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          Row(
            children: [
              // Decrease Button
              GestureDetector(
                onTap: () {
                  if (quantity > 0.1) {
                    setState(() {
                      quantity = (quantity - 0.1).clamp(0.1, double.infinity);
                      _quantityController.text = quantity.toStringAsFixed(1);
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'remove',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Quantity Input Field
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  onChanged: _updateQuantity,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Increase Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    quantity += 0.1;
                    _quantityController.text = quantity.toStringAsFixed(1);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'add',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Unit Selection
          Text(
            'Unidad de medida',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: servingUnits.map((unit) {
              final isSelected = selectedUnit == unit['unit'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUnit = unit['unit'] as String;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: unit['icon'] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        unit['unit'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Nutritional Summary
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Información nutricional',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutrientInfo(
                        'Calorías', '${totalCalories.toStringAsFixed(0)} kcal'),
                    _buildNutrientInfo(
                        'Proteína', '${totalProtein.toStringAsFixed(1)}g'),
                    _buildNutrientInfo(
                        'Carbos', '${totalCarbs.toStringAsFixed(1)}g'),
                    _buildNutrientInfo(
                        'Grasas', '${totalFats.toStringAsFixed(1)}g'),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  child: Text('Cancelar'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _confirmServing,
                  child: Text('Agregar al registro'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
