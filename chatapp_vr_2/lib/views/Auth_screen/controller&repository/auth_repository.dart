import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_application/Snackbar/snackbarMaterialApp.dart';
import 'package:demo_application/views/Auth_screen/otp_Screen.dart';
import 'package:demo_application/views/home_screen/Screens/userinformationScreen.dart';
import 'package:demo_application/views/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../../../Model/User_model.dart';
import '../../../consts/consts.dart';

final authRespositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Get.offAll(() => const UserInformationScreen(),
          transition: Transition.downToUp);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String id = auth.currentUser!.uid;
      String photoUrl =
          'https://1fid.com/wp-content/uploads/2022/06/no-profile-picture-6-720x720.jpg';
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageProviderProvider)
            .storeFileToFirebase(
              'profilePic/$id',
              profilePic,
            );
      }
      var user = UserModel(
          name: name,
          id: id,
          profilePic: photoUrl,
          isOnline: true,
          phone: auth.currentUser!.phoneNumber!,
          groupId: []);
      await firestore.collection('users').doc(id).set(user.toMap());
      Get.offAll(() => const HomeScreen(), transition: Transition.downToUp);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
