import 'package:afn_test/app/routes/app_routes.dart';
import 'package:afn_test/app/screens/dashbord/dashboard_controller.dart';
import 'package:afn_test/app/screens/onboard/onboard_screen.dart';
import 'package:afn_test/app/screens/auth/auth_screen.dart';
import 'package:afn_test/app/screens/auth/login_screen.dart';
import 'package:afn_test/app/screens/auth/signup_screen.dart';
import 'package:afn_test/app/screens/dashbord/dashboard_screen.dart';
import 'package:afn_test/app/screens/quiz/topics_list_screen.dart';
import 'package:afn_test/app/screens/quiz/quiz_progress_screen.dart';
import 'package:afn_test/app/screens/quiz/mcq_quiz_screen.dart';
import 'package:afn_test/app/screens/quiz/score_screen.dart';
import 'package:afn_test/app/screens/pages/profile/about_screen.dart';
import 'package:afn_test/app/screens/pages/profile/settings_screen.dart';
import 'package:afn_test/app/controllers/quiz_controller.dart';
import 'package:afn_test/app/controllers/auth_controller.dart';
import 'package:afn_test/app/controllers/login_controller.dart';
import 'package:afn_test/app/controllers/signup_controller.dart';
import 'package:afn_test/app/controllers/leaderboard_controller.dart';
import 'package:afn_test/app/controllers/match_controller.dart';
import 'package:get/get.dart';

class AppPages {
  static final routes = [
    // Onboard Screen - No binding needed
    GetPage(
      name: AppRoutes.onboard,
      page: () => const OnboardScreen(),
    ),

    // Auth Screen
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AuthController());
      }),
    ),

    // Login Screen
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) {
          Get.put(AuthController());
        }
        // Delete existing controller if present to avoid duplicate keys
        if (Get.isRegistered<LoginController>()) {
          Get.delete<LoginController>();
        }
        Get.put(LoginController(), permanent: false);
      }),
    ),

    // Signup Screen
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<AuthController>()) {
          Get.put(AuthController());
        }
        // Delete existing controller if present to avoid duplicate keys
        if (Get.isRegistered<SignupController>()) {
          Get.delete<SignupController>();
        }
        Get.put(SignupController(), permanent: false);
      }),
    ),

    // Dashboard Screen
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DashboardController());
        // Dashboard pages bindings
        Get.lazyPut(() => LeaderboardController());
        Get.lazyPut(() => MatchController());
      }),
    ),

    // Topics List Screen
    GetPage(
      name: AppRoutes.topicsList,
      page: () => const TopicsListScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.lazyPut(() => QuizController());
        }
      }),
    ),

    // Quiz Progress Screen
    GetPage(
      name: AppRoutes.quizProgress,
      page: () => const QuizProgressScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.lazyPut(() => QuizController());
        }
      }),
    ),

    // MCQ Quiz Screen
    GetPage(
      name: AppRoutes.mcqQuiz,
      page: () => const MCQQuizScreen(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<QuizController>()) {
          Get.lazyPut(() => QuizController());
        }
      }),
    ),

    // Score Screen
    GetPage(
      name: AppRoutes.score,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        return ScoreScreen(
          correctAnswers: args?['correctAnswers'] ?? 0,
          totalQuestions: args?['totalQuestions'] ?? 0,
          totalPoints: args?['totalPoints'] ?? 0,
          testPassed: args?['testPassed'] ?? false,
        );
      },
    ),

    // About Screen
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutScreen(),
    ),

    // Settings Screen
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
  ];
}
