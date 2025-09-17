import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickAddFloatingButtonWidget extends StatefulWidget {
  const QuickAddFloatingButtonWidget({Key? key}) : super(key: key);

  @override
  State<QuickAddFloatingButtonWidget> createState() =>
      _QuickAddFloatingButtonWidgetState();
}

class _QuickAddFloatingButtonWidgetState
    extends State<QuickAddFloatingButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _quickExercises = [
    {
      'id': 'walking',
      'title': 'Walking',
      'icon': 'directions_walk',
      'color': Color(0xFF2ECC71),
    },
    {
      'id': 'water',
      'title': 'Water',
      'icon': 'water_drop',
      'color': Color(0xFF3498DB),
    },
    {
      'id': 'stretching',
      'title': 'Stretch',
      'icon': 'accessibility_new',
      'color': Color(0xFF9B59B6),
    },
    {
      'id': 'meditation',
      'title': 'Meditate',
      'icon': 'spa',
      'color': Color(0xFF1ABC9C),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _addQuickExercise(Map<String, dynamic> exercise) {
    // Close the menu
    _toggleExpanded();

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise['title']} added successfully!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: exercise['color'],
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
        ),
      ),
    );

    // Here you would typically add the exercise to your data model
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Quick action buttons
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ..._quickExercises
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final exercise = entry.value;
                      final delay = index * 0.1;

                      return Transform.scale(
                        scale: _animation.value,
                        child: Transform.translate(
                          offset: Offset(
                              0, -_animation.value * (60.0 + (index * 60))),
                          child: Opacity(
                            opacity: _animation.value,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2.h),
                              child: FloatingActionButton(
                                mini: true,
                                heroTag: exercise['id'],
                                backgroundColor: exercise['color'],
                                onPressed: () => _addQuickExercise(exercise),
                                child: CustomIconWidget(
                                  iconName: exercise['icon'],
                                  size: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })
                    .toList()
                    .reversed,
                SizedBox(height: 8.h), // Space for main FAB
              ],
            );
          },
        ),
        // Main FAB
        FloatingActionButton(
          onPressed: _toggleExpanded,
          backgroundColor: _isExpanded
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
          child: AnimatedRotation(
            turns: _isExpanded ? 0.125 : 0.0, // 45 degree rotation
            duration: const Duration(milliseconds: 300),
            child: CustomIconWidget(
              iconName: _isExpanded ? 'close' : 'add',
              size: 24.sp,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}