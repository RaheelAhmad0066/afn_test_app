import 'package:afn_test/app/screens/pages/home_screen.dart';
import 'package:afn_test/app/screens/pages/leaderboard_screen.dart';
import 'package:afn_test/app/screens/pages/profile_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    HomeScreen(),
    LeaderboardScreen(),
    HomeScreen(), // Settings - can be replaced with SettingsScreen later
    ProfileScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
