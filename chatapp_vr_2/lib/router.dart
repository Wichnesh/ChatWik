import 'package:flutter/cupertino.dart';
import 'package:demo_application/views/home_screen/Screens/select_contact_screen.dart';
import 'package:flutter/material.dart';

import 'error.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case SelectContactScreen:
    //   return
    default:
      return CupertinoPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'This page doesn\'t exist'),
        ),
      );
  }
}
