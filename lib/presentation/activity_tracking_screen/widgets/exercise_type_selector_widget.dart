import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ExerciseTypeSelectorWidget extends StatefulWidget {
  final Function(String)? onExerciseSelected;

  const ExerciseTypeSelectorWidget({
    Key? key,
    this.onExerciseSelected,
  }) : super(key: key);

  @override
  State<ExerciseTypeSelectorWidget> createState() =>
      _ExerciseTypeSelectorWidgetState();
}

class _ExerciseTypeSelectorWidgetState
    extends State<ExerciseTypeSelectorWidget> {
  String _selectedExercise = 'running';

  final List<Map<String, dynamic>> _exerciseTypes = [
    {
      'id': 'running',
      'title': 'Running',
      'icon': 'directions_run',
      'color': const Color(0xFFE74C3C),
    },
    {
      'id': 'cycling',
      'title': 'Cycling',
      'icon': 'pedal_bike',
      'color': const Color(0xFF3498DB),
    },
    {
      'id': 'strength',
      'title': 'Strength',
      'icon': 'fitness_center',
      'color': const Color(0xFF9B59B6),
    },
    {
      'id': 'yoga',
      'title': 'Yoga',
      'icon': 'self_improvement',
      'color': const Color(0xFF1ABC9C),
    },
  ];

  void _selectExercise(String exerciseId) {
    setState(() {
      _selectedExercise = exerciseId;
    });
    widget.onExerciseSelected?.call(exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Exercise Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: _exerciseTypes.length,
          itemBuilder: (context, index) {
            final exercise = _exerciseTypes[index];
            final isSelected = _selectedExercise == exercise['id'];

            return GestureDetector(
              onTap: () => _selectExercise(exercise['id']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isSelected
                      ? exercise['color'].withAlpha(26)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.sp),
                  border: Border.all(
                    color: isSelected
                        ? exercise['color']
                        : Theme.of(context).colorScheme.outline.withAlpha(77),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: exercise['color'].withAlpha(77),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withAlpha(13),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: exercise['icon'],
                      size: 36.sp,
                      color: isSelected
                          ? exercise['color']
                          : Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      exercise['title'],
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isSelected
                                ? exercise['color']
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}