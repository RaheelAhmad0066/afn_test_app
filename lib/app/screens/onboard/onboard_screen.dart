import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_icons.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';
import 'package:afn_test/app/app_widgets/theme/app_themes.dart';
import 'package:afn_test/app/routes/app_routes.dart';
import 'package:afn_test/app/screens/onboard/widgets/box_patteren_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top spacing
            SizedBox(height: 40.h),

            // Box Pattern Graphic - Center
            Center(
              child: BoxPatternGraphic(
                size: 250.w,
                lineColor: AppTheme.accentYellowGreen,
              ),
            ),

            SizedBox(height: 32.h),
            // Content with padding on column
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heading
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.headlineLarge,
                      children: [
                        const TextSpan(text: 'Think '),
                        TextSpan(
                          text: 'Outside',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.accentYellowGreen,
                          ),
                        ),
                        const TextSpan(text: '\n'),
                       TextSpan(
                          text: 'the Box',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.accentYellowGreen,
                          ),
                        ),
                        const TextSpan(text: ' with \n'),
                        const TextSpan(text: 'Quizzax'),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Description
                  Text(
                    'Take your learning to the next level with our interactive and personalised quizzes.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.backgroundColor,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Continue Button - Right aligned
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.dashboard);
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Continue',
                            style: AppTextStyles.label18.copyWith(
                              color: AppColors.accentYellowGreen,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Image.asset(
                            AppIcons.arrowForward,
                            width: 24.w,
                            height: 24.h,
                            color: AppColors.accentYellowGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom spacing
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
