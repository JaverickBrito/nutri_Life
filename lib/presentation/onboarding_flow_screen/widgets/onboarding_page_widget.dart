import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isLastPage;
  final VoidCallback? onGetStarted;

  const OnboardingPageWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isLastPage = false,
    this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 80.w,
            height: 35.h,
            margin: EdgeInsets.only(bottom: 4.h),
            child: CustomImageWidget(
              imageUrl: imageUrl,
              width: 80.w,
              height: 35.h,
              fit: BoxFit.contain,
            ),
          ),

          // Title
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2.h),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: 6.h),

          // Get Started Button (only on last page)
          isLastPage
              ? Container(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      'Comenzar',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : SizedBox(height: 6.h),
        ],
      ),
    );
  }
}
