import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(error);
    return Center(
      child: SizedBox(
        // width: 500,
        // height: 200,
        child: Column(
          children: [
            // const SizedBox(height: 30),
            // Padding(
            //   padding: const EdgeInsets.all(8),
            //   child: Image.asset('Constants.loginEmotePath'),
            // ),
            // const Text('o'),
            // const Text('On dirait que quelque chose s\'est mal passer.'),
            // const SizedBox(height: 5),
            Text(error),
          ],
        ),
      ),
    );
  }
}
