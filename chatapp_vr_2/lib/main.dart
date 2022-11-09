import 'package:demo_application/consts/consts.dart';
import 'package:demo_application/router.dart';
import 'package:demo_application/views/Auth_screen/loginScreen.dart';
import 'package:demo_application/views/Auth_screen/verification_screen.dart';
import 'package:demo_application/views/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: App()));
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var isUser = false;
  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        setState(() {
          isUser = false;
        });
      } else {
        setState(() {
          isUser = true;
        });
      }
      print("User value is $isUser");
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: "lato"),
      debugShowCheckedModeBanner: false,
      home: isUser ? const HomeScreen() : const ChatApp(),
      title: appname,
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    logo,
                    width: 120,
                  ),
                  appname.text
                      .size(28)
                      .fontFamily(bold)
                      .color(Colors.lightBlue)
                      .make(),
                ],
              )),
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 2,
                    children: List.generate(listOfFeatures.length, (index) {
                      return Chip(
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 1),
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(
                            color: Vx.black,
                          ),
                          label: listOfFeatures[index]
                              .text
                              .semiBold
                              .color(Colors.lightBlue)
                              .make());
                    }),
                  ),
                  20.heightBox,
                  slogan.text
                      .size(36)
                      .fontFamily(bold)
                      .letterSpacing(2)
                      .color(Colors.lightBlue)
                      .make(),
                ],
              )),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    width: context.screenWidth - 80,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        navigateToLoginScreen(context);
                      },
                      child: cont.text.semiBold.size(16).make(),
                    ),
                  ),
                  10.heightBox,
                  poweredby.text
                      .size(15)
                      .semiBold
                      .color(Colors.lightBlue)
                      .make(),
                ],
              )),
        ],
      ),
    ));
  }
}
