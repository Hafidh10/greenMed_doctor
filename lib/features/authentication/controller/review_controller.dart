import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenmed_doctor/data/repositories/health_check_repository.dart';
import 'package:greenmed_doctor/models/health_check_model.dart';
import 'package:greenmed_doctor/utils/popups/full_screen_loader.dart';
import 'package:greenmed_doctor/utils/popups/loaders.dart';
import 'package:greenmed_doctor/utils/constants/image_strings.dart';
import 'package:greenmed_doctor/features/authentication/screens/signUp/success.dart';
import 'package:greenmed_doctor/navigation.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final feedbackController = TextEditingController();
  final medsController = TextEditingController();
  final priceController = TextEditingController();
  final HealthCheckRepository _repository = HealthCheckRepository();

  Future<void> submitReview(HealthCheck healthCheck) async {
    try {
      // 1. Validation
      if (feedbackController.text.trim().isEmpty) {
        TLoaders.warningSnackBar(title: 'Empty Feedback', message: 'Please provide clinical feedback for the patient.');
        return;
      }

      // 2. Start Loading
      TFullScreenLoader.openLoadingDialog(
        'Processing your review...',
        TImages.docerAnimation,
      );

      // 3. Prepare updated object
      final updatedCheck = HealthCheck(
        id: healthCheck.id,
        userId: healthCheck.userId,
        complain: healthCheck.complain,
        feelingDescription: healthCheck.feelingDescription,
        medications: healthCheck.medications,
        systolicBP: healthCheck.systolicBP,
        diastolicBP: healthCheck.diastolicBP,
        pulseRate: healthCheck.pulseRate,
        fbs: healthCheck.fbs,
        postprandialSugar: healthCheck.postprandialSugar,
        hba1c: healthCheck.hba1c,
        cholesterol: healthCheck.cholesterol,
        triglyceride: healthCheck.triglyceride,
        height: healthCheck.height,
        weight: healthCheck.weight,
        createdAt: healthCheck.createdAt,
        status: HealthCheckStatus.reviewed,
        doctorFeedback: feedbackController.text.trim(),
        prescribedMeds: medsController.text.trim(),
        totalPrice: double.tryParse(priceController.text.trim()),
        paymentReference: healthCheck.paymentReference,
        isStable: healthCheck.isStable,
      );

      // 4. Update Repository (Supabase)
      await _repository.updateHealthCheck(updatedCheck);

      // 5. Stop Loader
      TFullScreenLoader.stopLoading();

      // 6. Navigate to Success Screen
      Get.offAll(() => SuccessScreen(
            image: TImages.successfullyRegisterAnimation, // Reusing success animation
            title: 'Review Submitted!',
            subTitle: 'Your medical feedback has been successfully sent to the patient.',
            onPressed: () => Get.offAll(() => const Navigation()),
          ));

    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Submission Failed', message: e.toString());
    }
  }

  @override
  void onClose() {
    feedbackController.dispose();
    medsController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
