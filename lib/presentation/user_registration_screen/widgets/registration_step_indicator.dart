import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RegistrationStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const RegistrationStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          for (int i = 1; i <= totalSteps; i++) ...[
            Expanded(
              child: Container(
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: i <= currentStep
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (i < totalSteps) SizedBox(width: 2.w),
          ],
        ],
      ),
    );
  }
}
