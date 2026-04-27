import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/authentication/screens/login/login.dart';
import '../../features/authentication/screens/onboarding/onboarding.dart';
import '../../navigation.dart';
import '../../utils/popups/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final deviceStorage = GetStorage();
  final _supabase = Supabase.instance.client;

  // Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Function to show Relevant Screen
  Future<void> screenRedirect() async {
    final session = _supabase.auth.currentSession;
    
    // 1. Check if it's the user's first time (Onboarding)
    deviceStorage.writeIfNull('isFirstTime', true);
    if (deviceStorage.read('isFirstTime') == true) {
      Get.offAll(() => const OnBoardingScreen());
      return;
    }

    // 2. Check if user is logged in
    if (session != null) {
      // User has an active session
      // Robust check: Ensure they are a doctor
      try {
        final profile = await _supabase
            .from('profiles')
            .select('role')
            .eq('id', session.user.id)
            .single();

        if (profile['role'] == 'doctor') {
          Get.offAll(() => const Navigation());
        } else {
          // If somehow a patient logged in here, sign them out
          await logout();
        }
      } catch (e) {
        // If profile fetch fails, safer to go to login
        Get.offAll(() => const LoginScreen());
      }
    } else {
      // No active session
      Get.offAll(() => const LoginScreen());
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      TLoaders.errorSnackBar(
        title: "Oh Snap",
        message: "Something went wrong during logout. Please try again!",
      );
    }
  }
}
