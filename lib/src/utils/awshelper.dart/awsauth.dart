// ignore_for_file: use_build_context_synchronously

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walk/amplifyconfiguration.dart';
import 'package:walk/src/utils/custom_navigation.dart';
import 'package:walk/src/views/auth/otp_page.dart';
import 'package:walk/src/views/revisedhome/newhomepage.dart';

class AWSAuth {
  static void configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);

      // call Amplify.configure to use the initialized categories in your app
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }
  }

  static Future<void> signUpWithPhoneVerification(
    String username,
    String password,
    BuildContext context,
    bool isSignIn,
    Function isLoggedIn,
    Function logOut,
  ) async {
    try {
      debugPrint("signup");
      await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: SignUpOptions(
          userAttributes: <AuthUserAttributeKey, String>{
            AuthUserAttributeKey.phoneNumber: username,
          },
        ),
      );
      Go.to(
        context: context,
        push: OTPPage(
          phoneNumber: username,
          isSignIn: isSignIn,
          isLoggedIn: isLoggedIn,
          logOut: logOut,
        ),
      );

      debugPrint("signup opt sent successfully");
    } catch (e) {
      debugPrint("aws: signUpWithPhoneVerification: $e");
      toastMsg(e);
    }
  }

  static Future<void> confirmSignUpPhoneVerification(
    String username,
    String otpCode,
    Function isLoggedIn,
    Function logOut,
    BuildContext context,
  ) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: otpCode,
      );
      Go.pushAndRemoveUntil(
          context: context,
          pushReplacement:
              RevisedHomePage(isLoggedIn: isLoggedIn, logOut: logOut));
      debugPrint("signUP opt verfication successful");
    } catch (e) {
      debugPrint("confirmSignUpPhoneVerification: $e");
      toastMsg(e);
    }
  }

  static Future<void> signInWithPhoneVerification(
    String username,
    String password,
    BuildContext context,
    bool isSignIn,
    Function isLoggedIn,
    Function logOut,
  ) async {
    try {
      debugPrint("login ");
      await signOutCurrentUser();
      await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      Go.pushReplacement(
        context: context,
        pushReplacement: OTPPage(
          phoneNumber: username,
          isSignIn: isSignIn,
          isLoggedIn: isLoggedIn,
          logOut: logOut,
        ),
      );
      debugPrint("login opt sent successfully");
    } catch (e) {
      debugPrint("signInWithPhoneVerification: $e");
      toastMsg(e);
    }
  }

  static Future<void> confirmSignInPhoneVerification(
    String otpCode,
    BuildContext context,
    Function isLoggedIn,
    Function logOut,
  ) async {
    try {
      await Amplify.Auth.confirmSignIn(
        confirmationValue: otpCode,
      );
      Go.pushAndRemoveUntil(
          context: context,
          pushReplacement:
              RevisedHomePage(isLoggedIn: isLoggedIn, logOut: logOut));
      debugPrint("login opt verfication successful");
    } catch (e) {
      debugPrint("confirmSignInPhoneVerification: $e");
      toastMsg(e);
    }
  }

  static Future<void> signOutCurrentUser() async {
    final result = await Amplify.Auth.signOut();
    if (result is CognitoCompleteSignOut) {
      safePrint('Sign out completed successfully');
    } else if (result is CognitoFailedSignOut) {
      safePrint('Error signing user out: ${result.exception.message}');
    }
  }

  static Future<bool> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession();
      safePrint('User is signed in: ${result.isSignedIn}');
      return result.isSignedIn;
    } on AuthException catch (e) {
      safePrint('Error retrieving auth session: ${e.message}');
      return false;
    }
  }
}

Future<bool?> toastMsg(e) {
  return Fluttertoast.showToast(
      msg: (e.runtimeType.toString())
          .split(RegExp(r'(?=[A-Z])'))
          .sublist(0,
              (e.runtimeType.toString()).split(RegExp(r'(?=[A-Z])')).length - 1)
          .join(" "));
}