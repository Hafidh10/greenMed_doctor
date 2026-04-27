import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/device/device_utils.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controller/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: 'assets/images/undraw_medicine_hqqg.png',
                title: 'Track Your Health',
                subTitle:
                    'Monitor blood pressure, blood sugar, and cholesterol in one secure place',
              ),
              OnBoardingPage(
                image: 'assets/images/undraw_questions_g2px.png',
                title: 'Answer Simple Health Questions',
                subTitle:
                    'Fill in guided medical questionnaires designed by healthcare professionals',
              ),
              OnBoardingPage(
                image: 'assets/images/undraw_doctors_djoj.png',
                title: 'Get Professional Feedback',
                subTitle:
                    'Receive personalized advice and recommendations from qualified doctors',
              ),
            ],
          ),

          //Skip button
          Positioned(
            top: SkiiveDeviceUtils.getAppBarHeight(),
            right: 10,
            child: TextButton(
              onPressed: () => OnBoardingController.instance.skipPage(),
              child: const Text('Skip'),
            ),
          ),

          // Dot navigation
          const DotNavigation(),

          // Button
          const OnBoardingButton(),
        ],
      ),
    );
  }
}

class OnBoardingButton extends StatelessWidget {
  const OnBoardingButton({super.key});

  // _storeOnBoardInfo() async {
  //   int isViewed = 0;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('OnBoard', isViewed);
  // }

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Positioned(
      right: 20,
      bottom: SkiiveDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: SkiiveColors.primary,

          // ✅ Increase size
          padding: const EdgeInsets.all(20),

          // ✅ Remove border/outline
          side: BorderSide.none,

          // ✅ Remove elevation shadow
          elevation: 0,
        ),
        onPressed: () {
          OnBoardingController.instance.nextPage();
        },
        child: const Icon(
          Icons.chevron_right,
          size: 32, // optional: make icon bigger
          color: Colors.white,
        ),
      ),
    );
  }
}

class DotNavigation extends StatelessWidget {
  const DotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);
    final controller = OnBoardingController.instance;

    return Positioned(
      bottom: SkiiveDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: 25,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: SkiiveColors.primary,
          dotHeight: 6,
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Image(
            image: AssetImage(image),
            width: SkiiveHelperFunctions.screenWidth() * 0.8,
            height: SkiiveHelperFunctions.screenHeight() * 0.6,
          ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
