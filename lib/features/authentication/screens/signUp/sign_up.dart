// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/validators/validators.dart';
import '../../controller/register_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Delete any previous instance to avoid state conflicts during reassemble/hot reload
    Get.delete<RegisterController>();
    final controller = Get.put(RegisterController());
    final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's create your doctor account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(height: 20),

              //Form
              Form(
                key: controller.signUpFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.firstNameController,
                            validator: (value) =>
                                SkiiveValidator.validateEmptyText(
                                  'First name',
                                  value,
                                ),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'First Name',
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lastNameController,
                            validator: (value) =>
                                SkiiveValidator.validateEmptyText(
                                  'Last name',
                                  value,
                                ),
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.user),
                              labelText: 'Last Name',
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 15),

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

                    //password
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

                    SizedBox(height: 10),

                    //terms and conditions
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Obx(
                            () => Checkbox(
                              value: controller.privacyPolicy.value,
                              onChanged: (value) =>
                                  controller.privacyPolicy.value = value ?? false,
                              fillColor: MaterialStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(MaterialState.selected)) {
                                  return SkiiveColors.primary;
                                }
                                return Colors.transparent;
                              }),
                              checkColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 16),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I Agree to ',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              TextSpan(
                                text: 'Privacy Policy ',
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      color: dark
                                          ? SkiiveColors.white
                                          : SkiiveColors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
                              ),
                              TextSpan(
                                text: 'and ',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              TextSpan(
                                text: 'Terms of Use',
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(
                                      color: dark
                                          ? SkiiveColors.white
                                          : SkiiveColors.primary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: dark
                                          ? SkiiveColors.white
                                          : SkiiveColors.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    //create button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SkiiveColors.primary,
                        ),
                        onPressed: () => controller.register(),
                        child: Text('Create Account'),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
