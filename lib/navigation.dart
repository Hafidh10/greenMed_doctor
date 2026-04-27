// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenmed_doctor/utils/constants/colors.dart';
import 'package:greenmed_doctor/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

import 'features/authentication/screens/courses/courses.dart';
import 'features/authentication/screens/home/home.dart';
import 'features/authentication/screens/profile/profile.dart';
import 'features/authentication/screens/quiz/quiz_screen.dart';

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = SkiiveHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          backgroundColor: darkMode ? SkiiveColors.black : Colors.white,
          indicatorColor: darkMode
              ? SkiiveColors.white.withOpacity(0.1)
              : SkiiveColors.black.withOpacity(0.1),
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Iconsax.heart),
              label: 'Medications',
            ),
            NavigationDestination(icon: Icon(Icons.history), label: 'History'),
            NavigationDestination(
              icon: Icon(Iconsax.profile_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    HomeScreen(),
    CoursesScreen(),
    QuizScreen(),
    ProfileScreen(),
  ];
}
