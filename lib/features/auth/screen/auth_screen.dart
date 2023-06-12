import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/common/signin_anonymously.dart';
import 'package:footgal/core/common/signin_apple.dart';
import 'package:footgal/core/common/signin_facebook.dart';
import 'package:footgal/core/common/signin_google.dart';
import 'package:footgal/core/constant/constants.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              Constants.logoPath,
              height: 40,
            ),
            const Text(
              'FOOTGAL',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: const [
                SizedBox(height: 30),
                Text(
                  "S'inscrire",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                    "Utiliser l'une des methodes suivantes pour vous connecter a FootGal."),
                SizedBox(height: 20),
                SignInButtonAnonym(),
                SignInButtonGoogle(),
                SignInButtonFaceBook(),
                SignInButtonApple(),
              ],
            ),
    );
  }
}
