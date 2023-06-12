import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/constants.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';

class SignInButtonGoogle extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButtonGoogle({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          'Continuer avec Google',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          side: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
