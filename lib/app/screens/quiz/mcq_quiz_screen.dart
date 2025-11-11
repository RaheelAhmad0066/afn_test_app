import 'package:afn_test/app/app_widgets/app_colors.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';
import 'package:afn_test/app/controllers/quiz_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class MCQQuizScreen extends StatelessWidget {
  const MCQQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuizController>();
    final ttsController = Get.put(TTSController());
    final audioController = Get.put(AudioController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
            padding: EdgeInsets.zero,
          ),
        ),
        title: Column(
          children: [
            Text(
              controller.selectedCategory.value.isNotEmpty
                  ? '${controller.selectedCategory.value} Quiz Question'
                  : 'Quiz Question',
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${controller.getTotalQuestions()} Questions',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final currentQuestion = controller.getCurrentQuestion();
        if (currentQuestion == null) {
          return Center(
            child: Text(
              'No questions available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryTeal,
              ),
            ),
          );
        }

        final questionIndex = controller.currentQuestionIndex.value;
        final selectedAnswer = controller.getSelectedAnswer(questionIndex);
        final isAnswered = controller.isQuestionAnswered(questionIndex);
        final isCorrect = isAnswered && controller.isAnswerCorrect(questionIndex);

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // White Container with Shadow for Question and Options
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Question Number
                          Text(
                            'Question ${questionIndex + 1}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Question Text with Speaker Icon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  currentQuestion.question,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    color: AppColors.primaryTeal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Obx(() => GestureDetector(
                                    onTap: () => ttsController.speak(currentQuestion.question),
                                    child: Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryTeal.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        ttsController.isSpeaking.value
                                            ? Icons.volume_up
                                            : Icons.volume_up_outlined,
                                        color: AppColors.primaryTeal,
                                        size: 20.sp,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // Options with Animation
                          ...currentQuestion.options.asMap().entries.map((entry) {
                            final optionIndex = entry.key;
                            final option = entry.value;
                            final isSelected = selectedAnswer == optionIndex;
                            final isCorrectOption = optionIndex == currentQuestion.correctAnswerIndex;

                            Color optionColor;
                            Color textColor;
                            Color borderColor;

                            if (isAnswered) {
                              if (isCorrectOption) {
                                // Correct answer - light lime green
                                optionColor = const Color(0xffEEF9C0);
                                textColor = AppColors.primaryTeal;
                                borderColor = Colors.transparent;
                              } else if (isSelected && !isCorrect) {
                                // Wrong selected answer - red
                                optionColor = Colors.red.shade50;
                                textColor = Colors.red.shade700;
                                borderColor = Colors.red.shade300;
                              } else {
                                // Other options
                                optionColor = Colors.white;
                                textColor = AppColors.primaryTeal;
                                borderColor = Colors.grey.shade300;
                              }
                            } else {
                              // Not answered yet
                              optionColor = Colors.white;
                              textColor = AppColors.primaryTeal;
                              borderColor = Colors.grey.shade300;
                            }

                            return TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: value,
                                  child: Opacity(
                                    opacity: value,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isAnswered) {
                                          controller.selectAnswer(questionIndex, optionIndex);
                                          // Play sound effect
                                          if (optionIndex == currentQuestion.correctAnswerIndex) {
                                            audioController.playCorrectSound();
                                          } else {
                                            audioController.playWrongSound();
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 12.h),
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                                        decoration: BoxDecoration(
                                          color: optionColor,
                                          borderRadius: BorderRadius.circular(12.r),
                                          border: Border.all(
                                            color: borderColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: textColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Explanation Section with Light Blue Background
                    if (isAnswered && currentQuestion.explanation != null)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Basic Explanation:',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildExplanation(currentQuestion.explanation!),
                            SizedBox(height: 16.h),
                            // Answer Validation Message - Only show if correct
                            if (isCorrect)
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Your answer is correct.',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Navigation Buttons at Bottom Center
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Skip Button (Outline)
                  SizedBox(
                    width: 120.w,
                    child: OutlinedButton(
                      onPressed: () {
                        controller.nextQuestion();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: AppColors.primaryTeal, width: 1.5),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Save & Next Button (Filled)
                  SizedBox(
                    width: 160.w,
                    child: ElevatedButton(
                      onPressed: isAnswered
                          ? () {
                              if (questionIndex < controller.getTotalQuestions() - 1) {
                                controller.nextQuestion();
                              } else {
                                Get.back();
                                Get.snackbar(
                                  'Quiz Completed',
                                  'You have completed all questions!',
                                  backgroundColor: AppColors.primaryTeal,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        questionIndex < controller.getTotalQuestions() - 1
                            ? 'Save & Next'
                            : 'Finish',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Helper method to build explanation with steps
  Widget _buildExplanation(String explanation) {
    final lines = explanation.split('\n');
    final hasSteps = lines.any((line) => line.trim().toLowerCase().startsWith('step:'));

    if (hasSteps) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((line) {
          if (line.trim().isEmpty) return SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              line.trim(),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryTeal,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return Text(
        explanation,
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.primaryTeal,
          fontWeight: FontWeight.w400,
        ),
      );
    }
  }
}

// TTS Controller using GetX
class TTSController extends GetxController {
  FlutterTts flutterTts = FlutterTts();
  final isSpeaking = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });
  }

  Future<void> speak(String text) async {
    if (isSpeaking.value) {
      await flutterTts.stop();
      isSpeaking.value = false;
    } else {
      isSpeaking.value = true;
      await flutterTts.speak(text);
    }
  }

  @override
  void onClose() {
    flutterTts.stop();
    super.onClose();
  }
}

// Audio Controller using GetX
class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playCorrectSound() async {
    try {
      await _audioPlayer.play(AssetSource('correct.mp3'));
    } catch (e) {
      print('Error playing correct sound: $e');
    }
  }

  Future<void> playWrongSound() async {
    try {
      await _audioPlayer.play(AssetSource('wrong.mp3'));
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
