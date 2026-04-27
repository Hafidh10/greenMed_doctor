// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:greenmed_doctor/utils/constants/colors.dart';
import 'package:greenmed_doctor/utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Lottie Animation Container
            Container(
              width: SkiiveHelperFunctions.screenWidth() * 0.7,
              height: SkiiveHelperFunctions.screenWidth() * 0.7,
              decoration: BoxDecoration(
                color: SkiiveColors.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                image,
                fit: BoxFit.contain,
              ),
            ),
            
            const SizedBox(height: 40),

            // Titles and subtitles
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: SkiiveColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[600],
                  fontSize: 15,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const Spacer(),

            // Buttons
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SkiiveColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: SkiiveColors.primary.withOpacity(0.3),
                ),
                child: const Text(
                  "Continue to Dashboard",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
