import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Leaderboard',
                style: AppTextStyles.headlineLarge,
              ),
              SizedBox(height: 16.h),
              Text(
                'Top players ranking',
                style: AppTextStyles.bodyLarge,
              ),
              SizedBox(height: 32.h),
              // Add your leaderboard content here
              Expanded(
                child: Center(
                  child: Text(
                    'Leaderboard Content',
                    style: AppTextStyles.titleMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
