import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FoodSearchWidget extends StatefulWidget {
  final Function(String) onFoodSelected;
  final Function(String) onSearchChanged;
  final String searchQuery;

  const FoodSearchWidget({
    Key? key,
    required this.onFoodSelected,
    required this.onSearchChanged,
    required this.searchQuery,
  }) : super(key: key);

  @override
  State<FoodSearchWidget> createState() => _FoodSearchWidgetState();
}

class _FoodSearchWidgetState extends State<FoodSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

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

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredFoods() {
    if (_searchController.text.isEmpty) {
      return spanishFoodDatabase.take(5).toList();
    }

    final query = _searchController.text.toLowerCase();
    return spanishFoodDatabase.where((food) {
      return (food["name"] as String).toLowerCase().contains(query) ||
          (food["category"] as String).toLowerCase().contains(query);
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });
    widget.onSearchChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final filteredFoods = _getFilteredFoods();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _searchFocusNode.hasFocus
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
                width: _searchFocusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar alimentos...',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              style: AppTheme.lightTheme.textTheme.bodyLarge,
            ),
          ),

          SizedBox(height: 2.h),

          // Search Results Header
          if (filteredFoods.isNotEmpty) ...[
            Text(
              _isSearching
                  ? 'Resultados de búsqueda (${filteredFoods.length})'
                  : 'Alimentos populares',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
          ],

          // Food Results List
          if (filteredFoods.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxHeight: 30.h),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredFoods.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final food = filteredFoods[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 1.h,
                    ),
                    leading: Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'restaurant',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                      food["name"] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          food["servingSize"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${food["calories"]} kcal',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: CustomIconWidget(
                      iconName: 'add_circle_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24,
                    ),
                    onTap: () => widget.onFoodSelected(food["name"] as String),
                  );
                },
              ),
            )
          else if (_isSearching)
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'search_off',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 48,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'No se encontraron alimentos',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Intenta con otro término de búsqueda',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
