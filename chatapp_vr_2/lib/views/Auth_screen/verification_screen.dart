import 'package:demo_application/consts/colors.dart';
import 'package:demo_application/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:demo_application/consts/strings.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../consts/utils.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var Controller = Get.put(Authcontroller());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Letsconnect.text.blue400.fontFamily(bold).make(),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              //username field
              TextFormField(
                controller: Controller.usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.account_circle,
                      color: Colors.lightBlue,
                    ),
                    alignLabelWithHint: true,
                    labelText: "Username",
                    hintText: "eg.vignesh",
                    labelStyle: const TextStyle(
                      color: Vx.blue300,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              10.heightBox,
              //phone number field
              TextFormField(
                controller: Controller.phoneController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone_android_rounded,
                      color: Colors.lightBlue,
                    ),
                    alignLabelWithHint: true,
                    labelText: "Phone Number",
                    prefixText: "+91",
                    hintText: " eg.1234567890",
                    labelStyle: const TextStyle(
                      color: Vx.blue300,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              10.heightBox,
              otp.text.semiBold.size(10).blue500.make(),

              //otp field
              Obx(
                () => Visibility(
                  visible: Controller.isOtpSent.value,
                  child: SizedBox(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                            width: 56,
                            child: TextField(
                              controller: Controller.otpController[index],
                              onChanged: (value) {
                                if (value.length == 1 && index <= 5) {
                                  FocusScope.of(context).nextFocus();
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              },
                              style: const TextStyle(
                                fontFamily: bold,
                                // color:
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: bgColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: bgColor,
                                    ),
                                  ),
                                  hintText: "*"),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: context.screenWidth - 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {
                    if (Controller.isOtpSent.value == false) {
                      Controller.isOtpSent.value = true;
                      await Controller.sendOtp();
                    } else {
                      await Controller.verifyOtp(context);
                    }

                    // Get.to(() => const HomeScreen(),
                    //     transition: Transition.downToUp);
                  },
                  child: continuetext.text.semiBold.size(16).make(),
                ),
              ),
              30.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
