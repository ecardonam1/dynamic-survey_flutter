import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFormController extends GetxController {
  GlobalKey<FormState> loginformkey = GlobalKey<FormState>();
  GlobalKey<FormState> registerformkey = GlobalKey<FormState>();

  RxString email = ''.obs;
  RxString password = ''.obs;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  bool isValidLoginForm() {
    return loginformkey.currentState?.validate() ?? false;
  }

  bool isValidRegisterForm() {
    return registerformkey.currentState?.validate() ?? false;
  }
}
