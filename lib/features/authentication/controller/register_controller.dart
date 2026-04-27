import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenmed_doctor/utils/popups/loaders.dart';
import 'package:greenmed_doctor/utils/popups/full_screen_loader.dart';
import 'package:greenmed_doctor/utils/constants/api_constants.dart';
import 'package:greenmed_doctor/features/authentication/screens/login/login.dart';

import '../../../utils/constants/image_strings.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  
  final signUpFormKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  Future<void> register() async {
    try {
      // 1. Form validation
      if (!signUpFormKey.currentState!.validate()) return;

      // 2. Privacy Policy check
      if (!privacyPolicy.value) {
        TLoaders.warningSnackBar(
          title: "Accept Privacy Policy",
          message: "In order to create an account, you must read and accept the privacy policy.",
        );
        return;
      }

      // 3. Email Whitelist Check
      final email = emailController.text.trim().toLowerCase();
      if (!APIConstants.authorizedDoctorEmails.contains(email)) {
        TLoaders.errorSnackBar(
          title: 'Unauthorized',
          message: 'This email is not authorized for doctor registration.',
        );
        return;
      }

      // 4. Start Loading with Animated Loader
      TFullScreenLoader.openLoadingDialog(
        'We are processing your information...',
        TImages.docerAnimation,
      );

      // 5. Sign up user in Supabase Auth
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: passwordController.text.trim(),
        data: {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'role': 'doctor',
        },
      );

      final user = res.user;
      if (user == null) throw 'Registration failed. Please try again.';

      // 6. Insert/Update profiles table
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'email': email,
        'role': 'doctor',
      });

      // 7. Stop the loader
      TFullScreenLoader.stopLoading();

      // 8. Success Message
      TLoaders.successSnackBar(
        title: 'Congratulations!',
        message: 'Your doctor account has been created successfully. Please verify your email.',
      );
      
      // 9. Clear controllers
      firstNameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();

      // 10. Navigate to Login
      Get.offAll(() => const LoginScreen());

    } on AuthException catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Auth Error', message: e.message);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
