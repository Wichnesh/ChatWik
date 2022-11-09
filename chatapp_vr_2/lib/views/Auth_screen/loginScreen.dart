import 'package:demo_application/Snackbar/snackbarMaterialApp.dart';
import 'package:demo_application/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controller&repository/Authcontroller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country _country) {
          setState(() {
            country = _country;
          });
        });
  }

  void sendPhonenumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
      // Provider ref --> Interact provider with provider
      //widget ref --> makes widget interact with provider
    } else {
      showSnackBar(context: context, content: 'Fill out the phonenumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Enter your Mobile Number'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('ChatWik will need to verify your phone number',
                style: TextStyle(color: bgColor)),
            SizedBox(height: 10),
            TextButton(
                onPressed: pickCountry,
                child: const Text(
                  'Pick Country',
                )),
            const SizedBox(height: 5),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'phone number',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.57),
            SizedBox(
              width: 90,
              child: ElevatedButton(
                onPressed: sendPhonenumber,
                child: const Text('Next'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
