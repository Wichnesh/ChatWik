import 'package:demo_application/main.dart';
import 'package:flutter/material.dart';

import '../../Auth_screen/controller&repository/auth_controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Authcontroller authcontroller = Authcontroller();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('SignOut'),
          onPressed: () {
            authcontroller.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatApp()),
            );
          },
        ),
      ),
    );
  }
}
