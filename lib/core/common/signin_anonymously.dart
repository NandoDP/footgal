import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/constant/constants.dart';

class SignInButtonAnonym extends ConsumerWidget {
  const SignInButtonAnonym({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    // ref.watch(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInAsGuest(ref, context),
        icon: const Icon(
          Icons.person_2_outlined,
          color: Colors.black,
        ),
        label: const Text(
          'Connexion anonyme',
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
