import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../personalization/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _supabase = Supabase.instance.client;

  /// Function to save user data to Supabase 'profiles' table.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      // Using the updated toJson() which includes separate first_name and last_name
      await _supabase.from('profiles').upsert(user.toJson());
    } catch (e) {
      throw 'Error saving user record: ${e.toString()}';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return UserModel.empty();

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromMap(data);
    } catch (e) {
      throw 'Error fetching user details: ${e.toString()}';
    }
  }

  /// Function to update user data in Supabase.
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      await _supabase.from('profiles').update({
        'first_name': updatedUser.firstName,
        'last_name': updatedUser.lastName,
        'phone_number': updatedUser.phoneNumber,
      }).eq('id', updatedUser.id);
    } catch (e) {
      throw 'Error updating user details: ${e.toString()}';
    }
  }

  /// Function to update any single field in the profiles table.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      await _supabase.from('profiles').update(json).eq('id', userId);
    } catch (e) {
      throw 'Error updating field: ${e.toString()}';
    }
  }
}
