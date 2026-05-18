import 'package:get/get.dart';
import 'package:greenmed_doctor/data/repositories/user_repository.dart';

import '../utils/loaders/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(UserRepository());
  }
}
