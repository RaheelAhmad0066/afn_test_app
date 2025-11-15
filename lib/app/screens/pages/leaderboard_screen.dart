import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';
import 'package:afn_test/app/controllers/leaderboard_controller.dart';
import 'package:afn_test/app/models/leaderboard_model.dart';
import 'package:afn_test/app/utils/avatar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderboardController());

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryTeal,
            ),
          );
        }

        final leaderboard = controller.currentLeaderboard;
        final topThree = controller.topThree;
        final hasRankFourPlus = leaderboard.length > 3;
        final tableData = hasRankFourPlus ? leaderboard.sublist(3) : <LeaderboardModel>[];

        return CustomScrollView(
          slivers: [
            // Custom Header (No AppBar)
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: 16.h,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 24.sp,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Leaderboard',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w), // Balance for back button
                  ],
                ),
              ),
            ),

            // Top 3 Leaders
            SliverToBoxAdapter(
              child: topThree.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Center(
                        child: Text(
                          'No rankings yet',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 2nd Place (Left)
                          if (topThree.length >= 2)
                            Expanded(
                              child: _buildTopThreeCard(
                                player: topThree[0],
                                rank: 2,
                              ),
                            ),
                          SizedBox(width: 12.w),
                          // 1st Place (Center) - Tallest
                          if (topThree.isNotEmpty)
                            Expanded(
                              child: _buildTopThreeCard(
                                player: topThree.length >= 2 ? topThree[1] : topThree[0],
                                rank: 1,
                                isFirst: true,
                              ),
                            ),
                          SizedBox(width: 12.w),
                          // 3rd Place (Right)
                          if (topThree.length >= 3)
                            Expanded(
                              child: _buildTopThreeCard(
                                player: topThree[2],
                                rank: 3,
                              ),
                            ),
                        ],
                      ),
                    ),
            ),

            // Leaderboard List (4-10+)
            if (hasRankFourPlus)
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: tableData.asMap().entries.map((entry) {
                            final index = entry.key;
                            final player = entry.value;
                            final rank = index + 4;
                            return _buildLeaderboardItem(player, rank);
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  /// Build top 3 card with stack structure
  Widget _buildTopThreeCard({
    required LeaderboardModel player,
    required int rank,
    bool isFirst = false,
  }) {
    final avatarUrl = player.userAvatar ?? AvatarUtils.getAvatarUrl(player.userName);
    final badgeColor = AppColors.accentYellowGreen;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Stack: Crown → Rank → Profile
        Stack(
          alignment: Alignment.topCenter,
          children: [
            // Profile Avatar with green glow (bottom layer)
            Container(
              width: isFirst ? 100.w : 90.w,
              height: isFirst ? 140.h : 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: badgeColor,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: badgeColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.accentYellowGreenLight,
                      child: Icon(
                        Icons.person,
                        color: AppColors.primaryTeal,
                        size: isFirst ? 50.sp : 45.sp,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: AppColors.accentYellowGreenLight,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryTeal,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Rank circle (middle layer - positioned at top of avatar)
            Positioned(
              top: -20.h,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowMedium,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Crown icon for rank 1 (top layer)
            if (isFirst)
              Positioned(
                top: -55.h,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowMedium,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Iconsax.crown1,
                    color: AppColors.primaryTeal,
                    size: 20.sp,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 20.h), // Space for rank circle

        // Name
        Text(
          player.isCurrentUser ? 'You' : player.userName,
          textAlign: TextAlign.center,
          style: AppTextStyles.label16.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 6.h),

        // Points with leaf icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${player.totalPoints}',
              style: AppTextStyles.label16.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.eco,
              color: AppColors.accentYellowGreen,
              size: 16.sp,
            ),
            SizedBox(width: 2.w),
            Text(
              'pts',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build leaderboard item for rank 4+
  Widget _buildLeaderboardItem(LeaderboardModel player, int rank) {
    final isCurrentUser = player.isCurrentUser;
    final avatarUrl = player.userAvatar ?? AvatarUtils.getAvatarUrl(player.userName);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.accentYellowGreenLight : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isCurrentUser
            ? Border.all(
                color: AppColors.accentYellowGreen,
                width: 2,
              )
            : null,
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: AppColors.accentYellowGreen.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 40.w,
            child: Text(
              rank.toString().padLeft(2, '0'),
              style: AppTextStyles.label16.copyWith(
                color: isCurrentUser
                    ? AppColors.primaryTeal
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Avatar
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.accentYellowGreenLight,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser
                    ? AppColors.primaryTeal
                    : AppColors.borderLight,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: AppColors.primaryTeal,
                    size: 24.sp,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        color: AppColors.primaryTeal,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Name
          Expanded(
            child: Text(
              player.isCurrentUser ? 'You' : player.userName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Points with leaf icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${player.totalPoints}',
                style: AppTextStyles.label16.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.eco,
                color: AppColors.accentYellowGreen,
                size: 14.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'pts',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
