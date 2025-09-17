import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginWidget extends StatelessWidget {
  final Function(String provider) onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.2),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'O continúa con',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.2),
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Social login buttons
        Row(
          children: [
            // Google Login
            Expanded(
              child: _SocialLoginButton(
                onTap: isLoading ? null : () => onSocialLogin('google'),
                icon: 'g_translate', // Using material icon as placeholder
                label: 'Google',
                backgroundColor: Colors.white,
                borderColor: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.2),
                textColor: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(width: 4.w),

            // Apple Login
            Expanded(
              child: _SocialLoginButton(
                onTap: isLoading ? null : () => onSocialLogin('apple'),
                icon: 'apple', // Using material icon as placeholder
                label: 'Apple',
                backgroundColor: Colors.black,
                borderColor: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  final String label;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _SocialLoginButton({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: textColor,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
