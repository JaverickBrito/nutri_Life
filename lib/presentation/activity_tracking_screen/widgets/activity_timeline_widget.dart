import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ActivityTimelineWidget extends StatelessWidget {
  const ActivityTimelineWidget({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> _mockActivities = const [
    {
      'id': '1',
      'type': 'running',
      'title': 'Morning Run',
      'duration': '32:45',
      'calories': 245,
      'distance': '4.2 km',
      'time': '08:30 AM',
      'date': 'Today',
      'intensity': 'high',
    },
    {
      'id': '2',
      'type': 'yoga',
      'title': 'Evening Yoga',
      'duration': '45:00',
      'calories': 156,
      'distance': '12 poses',
      'time': '06:00 PM',
      'date': 'Yesterday',
      'intensity': 'medium',
    },
    {
      'id': '3',
      'type': 'cycling',
      'title': 'Weekend Ride',
      'duration': '1:15:30',
      'calories': 486,
      'distance': '15.8 km',
      'time': '09:15 AM',
      'date': '2 days ago',
      'intensity': 'high',
    },
    {
      'id': '4',
      'type': 'strength',
      'title': 'Upper Body',
      'duration': '28:20',
      'calories': 198,
      'distance': '45 reps',
      'time': '07:00 PM',
      'date': '3 days ago',
      'intensity': 'medium',
    },
  ];

  Color _getExerciseColor(String type) {
    switch (type) {
      case 'running':
        return const Color(0xFFE74C3C);
      case 'cycling':
        return const Color(0xFF3498DB);
      case 'strength':
        return const Color(0xFF9B59B6);
      case 'yoga':
        return const Color(0xFF1ABC9C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  String _getExerciseIcon(String type) {
    switch (type) {
      case 'running':
        return 'directions_run';
      case 'cycling':
        return 'pedal_bike';
      case 'strength':
        return 'fitness_center';
      case 'yoga':
        return 'self_improvement';
      default:
        return 'fitness_center';
    }
  }

  Color _getIntensityColor(String intensity) {
    switch (intensity) {
      case 'high':
        return const Color(0xFFE74C3C);
      case 'medium':
        return const Color(0xFFF39C12);
      case 'low':
        return const Color(0xFF27AE60);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _mockActivities.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final activity = _mockActivities[index];
        final exerciseColor = _getExerciseColor(activity['type']);
        final intensityColor = _getIntensityColor(activity['intensity']);

        return Dismissible(
          key: Key(activity['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(16.sp),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'delete',
                  size: 24.sp,
                  color: Theme.of(context).colorScheme.onError,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                      ),
                ),
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16.sp),
              border: Border.all(
                color: exerciseColor.withAlpha(77),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(13),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.5.w),
                      decoration: BoxDecoration(
                        color: exerciseColor.withAlpha(26),
                        borderRadius: BorderRadius.circular(12.sp),
                      ),
                      child: CustomIconWidget(
                        iconName: _getExerciseIcon(activity['type']),
                        size: 24.sp,
                        color: exerciseColor,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity['title'],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Text(
                                '${activity['date']} • ${activity['time']}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(153),
                                    ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: intensityColor.withAlpha(26),
                                  borderRadius: BorderRadius.circular(8.sp),
                                ),
                                child: Text(
                                  activity['intensity'].toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: intensityColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8.sp,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        // Handle menu actions
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'edit',
                                size: 16.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              SizedBox(width: 2.w),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'delete',
                                size: 16.sp,
                                color: Theme.of(context).colorScheme.error,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        size: 20.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(153),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Metrics Row
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        icon: 'schedule',
                        label: 'Duration',
                        value: activity['duration'],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 6.h,
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        icon: 'local_fire_department',
                        label: 'Calories',
                        value: '${activity['calories']} cal',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 6.h,
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                    Expanded(
                      child: _buildMetricItem(
                        context,
                        icon: activity['type'] == 'running' ||
                                activity['type'] == 'cycling'
                            ? 'straighten'
                            : activity['type'] == 'strength'
                                ? 'fitness_center'
                                : 'self_improvement',
                        label: activity['type'] == 'running' ||
                                activity['type'] == 'cycling'
                            ? 'Distance'
                            : activity['type'] == 'strength'
                                ? 'Reps'
                                : 'Poses',
                        value: activity['distance'],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          size: 20.sp,
          color: Theme.of(context).colorScheme.primary,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}