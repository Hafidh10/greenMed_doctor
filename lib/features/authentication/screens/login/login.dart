// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/validators/validators.dart';
import '../../controller/login_controller.dart';
import '../password/forgot_password.dart';
import '../signUp/sign_up.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final controller = Get.put(LoginController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Logo, title & subtitle
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Doctor,',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Manage your patient reviews and provide expert medical consultations on the go.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: SkiiveColors.darkGrey,
                        ),
                      ),
                    ],
                  ),

                  //Form
                  Padding(
                    padding: EdgeInsets.only(top: 25, bottom: 10),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        children: [
                          //Email
                          TextFormField(
                            controller: controller.emailController,
                            validator: (value) =>
                                SkiiveValidator.validateEmail(value),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.direct_right),
                              labelText: 'Email',
                            ),
                          ),

                          SizedBox(height: 15),

                          Obx(
                            () => TextFormField(
                              controller: controller.passwordController,
                              validator: (value) =>
                                  SkiiveValidator.validatePassword(value),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.password_check),
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      controller.hidePassword.value = !controller.hidePassword.value,
                                  icon: Icon(
                                    controller.hidePassword.value
                                        ? Iconsax.eye_slash
                                        : Iconsax.eye,
                                  ),
                                ),
                                labelText: 'Password',
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: controller.hidePassword.value,
                            ),
                          ),

                          //Remember me & forgot password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Obx(
                                      () => Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (value) =>
                                            controller.rememberMe.value =
                                                value ?? false,
                                        fillColor:
                                            MaterialStateProperty.resolveWith((
                                              states,
                                            ) {
                                              if (states.contains(
                                                MaterialState.selected,
                                              )) {
                                                return SkiiveColors.primary;
                                              }
                                              return Colors.transparent;
                                            }),
                                        checkColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Text(
                                    'Remember me',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),

                              //Forgot password
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => ForgotPassScreen()),
                                child: Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: SkiiveColors.darkGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          //Sign in Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SkiiveColors.primary,
                              ),
                              onPressed: () => controller.login(),
                              child: Text('Sign In'),
                            ),
                          ),

                          SizedBox(height: 20),

                          //create account button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: Colors.black),
                              ),
                              onPressed: () => Get.to(() => SignUpScreen()),
                              child: Text(
                                'Create Account',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Divider(
                            color: SkiiveColors.darkGrey,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                        Text(
                          'or Sign In with',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        Flexible(
                          child: Divider(
                            color: SkiiveColors.darkGrey,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  //Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white70,
                          side: BorderSide(
                            color: SkiiveColors.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        onPressed: () {},
                        child: Image(
                                width: 26,
                                height: 26,
                                image: AssetImage(
                                  'assets/images/icons8-google-48.png',
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
