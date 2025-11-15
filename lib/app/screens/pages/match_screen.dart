import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';
import 'package:afn_test/app/app_widgets/auth_required_dialog.dart';
import 'package:afn_test/app/controllers/match_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if guest user
    if (FirebaseAuth.instance.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AuthRequiredDialog.show();
      });
      // Return empty scaffold while dialog shows
      return Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Container(),
      );
    }

    final controller = Get.find<MatchController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryTeal,
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Header
                Text(
                  'Find Your Match',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Challenge other players and compete!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 24.h),

                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.search_normal,
                        color: AppColors.primaryTeal,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: controller.searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by username or email',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          onChanged: (value) => controller.searchUsers(value),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Available Users List
                if (controller.availableUsers.isEmpty && !controller.isSearching.value)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.w),
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.people,
                            size: 64.sp,
                            color: AppColors.textLight,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No users available',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...controller.availableUsers.map((user) {
                    return _buildUserCard(user, controller);
                  }),

                SizedBox(height: 100.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildUserCard(dynamic user, MatchController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: AppColors.accentYellowGreenLight,
              shape: BoxShape.circle,
            ),
            child: user['userAvatar'] != null
                ? ClipOval(
                    child: Image.network(
                      user['userAvatar'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person,
                          color: AppColors.primaryTeal,
                          size: 30.sp,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person,
                    color: AppColors.primaryTeal,
                    size: 30.sp,
                  ),
          ),

          SizedBox(width: 16.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['userName'] ?? 'Unknown User',
                  style: AppTextStyles.label16.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Points: ${user['totalPoints'] ?? 0}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Challenge Button
          ElevatedButton(
            onPressed: () => controller.challengeUser(user['userId']),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentYellowGreen,
              foregroundColor: AppColors.primaryTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            child: Text(
              'Challenge',
              style: AppTextStyles.label14.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

