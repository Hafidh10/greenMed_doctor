import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:greenmed_doctor/utils/popups/loaders.dart';
import 'package:greenmed_doctor/utils/popups/full_screen_loader.dart';
import 'package:greenmed_doctor/utils/constants/image_strings.dart';
import 'package:greenmed_doctor/navigation.dart';
import 'package:greenmed_doctor/utils/notifications/notification_service.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observables
  final hidePassword = true.obs;
  final rememberMe = true.obs;
  
  final loginFormKey = GlobalKey<FormState>();
  final _supabase = Supabase.instance.client;

  Future<void> login() async {
    try {
      // 1. Form validation
      if (!loginFormKey.currentState!.validate()) return;

      // 2. Start Loading with Animated Loader
      TFullScreenLoader.openLoadingDialog(
        'Logging you in...',
        TImages.docerAnimation,
      );

      // 3. Login user with Supabase Auth
      final AuthResponse res = await _supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = res.user;
      if (user == null) throw 'Login failed. Please try again.';

      // 4. Check if user is a doctor (Optional but recommended)
      // We can query the profiles table to verify the role
      final profile = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      if (profile['role'] != 'doctor') {
        await _supabase.auth.signOut();
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'Access Denied',
          message: 'This app is strictly for doctors. Please use the patient app.',
        );
        return;
      }

      // 5. Stop the loader
      TFullScreenLoader.stopLoading();

      // 6. Success Message
      TLoaders.successSnackBar(
        title: 'Welcome Back!',
        message: 'You have logged in successfully.',
      );
      
      // 7. Initialize Notifications (FCM)
      await NotificationService.instance.initNotifications();
      
      // 8. Clear controllers
      emailController.clear();
      passwordController.clear();

      // 9. Navigate to Navigation (Dashboard)
      Get.offAll(() => const Navigation());

    } on AuthException catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Auth Error', message: e.message);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
