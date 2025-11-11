import 'package:afn_test/app/routes/app_routes.dart';
import 'package:afn_test/app/screens/dashbord/dashboard_controller.dart';
import 'package:afn_test/app/screens/onboard/onboard_screen.dart';
import 'package:afn_test/app/screens/dashbord/dashboard_screen.dart';
import 'package:afn_test/app/screens/quiz/topics_list_screen.dart';
import 'package:afn_test/app/screens/quiz/quiz_progress_screen.dart';
import 'package:afn_test/app/screens/quiz/mcq_quiz_screen.dart';
import 'package:afn_test/app/controllers/quiz_controller.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.onboard, page: () => const OnboardScreen()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: BindingsBuilder(() {
      Get.lazyPut(() => DashboardController());
      }),
    ),
    GetPage(
      name: AppRoutes.topicsList,
      page: () => const TopicsListScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.put(QuizController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.quizProgress,
      page: () => const QuizProgressScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.put(QuizController());
        }
      }),
    ),
    GetPage(
      name: AppRoutes.mcqQuiz,
      page: () => const MCQQuizScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.put(QuizController());
        }
      }),
    ),
  ];
}