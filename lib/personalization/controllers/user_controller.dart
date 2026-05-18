import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/repositories/user_repository.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final Rx<UserModel> user = UserModel.empty().obs;
  final RxBool isLoading = false.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadCachedUser(); // Load from local storage immediately
    fetchUserRecord();
  }

  /// Load profile from local storage for offline access
  void _loadCachedUser() {
    final cachedData = _storage.read('user_profile');
    if (cachedData != null) {
      user.value = UserModel.fromMap(Map<String, dynamic>.from(cachedData));
    }
  }

  /// Fetch user record from Supabase
  Future<void> fetchUserRecord() async {
    try {
      isLoading.value = true;
      final userRecord = await userRepository.fetchUserDetails();
      user.value = userRecord;
      
      // Cache the record for next time
      _storage.write('user_profile', userRecord.toJson());
    } catch (e) {
      // If error (offline), we keep the cached version
    } finally {
      isLoading.value = false;
    }
  }
}
