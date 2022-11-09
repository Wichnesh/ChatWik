import 'package:demo_application/views/Auth_screen/loginScreen.dart';
import 'package:demo_application/views/Auth_screen/otp_Screen.dart';
import 'package:demo_application/views/home_screen/Screens/chats/screen/MobileChatScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'error.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPScreen(
                verificationId: verificationId,
              ));

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final id = arguments['id'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          id: id,
        ),
      );

    default:
      return CupertinoPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesnt exist'),
        ),
      );
  }
}
