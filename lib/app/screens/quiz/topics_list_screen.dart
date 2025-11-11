import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';
import 'package:afn_test/app/controllers/quiz_controller.dart';
import 'package:afn_test/app/models/topic_model.dart';
import 'package:afn_test/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TopicsListScreen extends StatelessWidget {
  const TopicsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find with fallback to Get.put if not registered
    final controller = Get.isRegistered<QuizController>()
        ? Get.find<QuizController>()
        : Get.put(QuizController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryTeal),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.selectedCategory.value.isNotEmpty
              ? '${controller.selectedCategory.value} Topics'
              : 'Topics',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primaryTeal,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingTopics.value) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryTeal,
            ),
          );
        }

        if (controller.topics.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.topic_outlined,
                  size: 64.sp,
                  color: AppColors.primaryTeal.withOpacity(0.5),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No topics available',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primaryTeal,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Please create topics in admin panel',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryTeal.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        // First, we need to filter topics that have tests
        // We'll use a FutureBuilder to get all topics with their test counts
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _getTopicsWithTests(controller),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryTeal,
                ),
              );
            }

            final topicsWithTests = snapshot.data ?? [];
            
            if (topicsWithTests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.topic_outlined,
                      size: 64.sp,
                      color: AppColors.primaryTeal.withOpacity(0.5),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'No topics with tests available',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Please create tests for topics in admin panel',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryTeal.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              itemCount: topicsWithTests.length,
              itemBuilder: (context, index) {
                final item = topicsWithTests[index];
                final topic = item['topic'] as TopicModel;
                final testCount = item['testCount'] as int;

                return _TopicListItem(
                  topic: topic,
                  testCount: testCount,
                  onTap: () {
                    // Load tests for this topic and navigate to quiz progress
                    controller.loadTestsByTopic(topic.id).then((_) {
                      controller.selectedTopicId.value = topic.id;
                      Get.toNamed(AppRoutes.quizProgress);
                    });
                  },
                );
              },
            );
          },
        );
      }),
    );
  }

  // Helper method to get only topics that have tests
  Future<List<Map<String, dynamic>>> _getTopicsWithTests(
      QuizController controller) async {
    final topicsWithTests = <Map<String, dynamic>>[];
    
    for (var topic in controller.topics) {
      final testCount = await controller.getTestCountForTopic(topic.id);
      if (testCount > 0) {
        topicsWithTests.add({
          'topic': topic,
          'testCount': testCount,
        });
      }
    }
    
    return topicsWithTests;
  }
}

class _TopicListItem extends StatelessWidget {
  final TopicModel topic;
  final int testCount;
  final VoidCallback onTap;

  const _TopicListItem({
    required this.topic,
    required this.testCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Row(
          children: [
            // Topic Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.topic,
                color: AppColors.primaryTeal,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            // Topic Info - Clean title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    topic.name,
                    style: AppTextStyles.label14.copyWith(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            // Start Button
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                minimumSize: Size(0, 32.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Start',
                style: AppTextStyles.label14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

