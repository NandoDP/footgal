import 'package:flutter/material.dart';
import 'package:footgal/core/common/paints.dart';

class Terrain extends StatelessWidget {
  final Widget? formation;
  const Terrain({super.key, this.formation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        height: 50 * 11 + 4,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.green),
        ),
        child: Stack(
          children: [
            // SizedBox(
            //   child: Image.asset(
            //     'assets/images/terrain_2.jpg',
            //     height: 550,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Column(
              children: [
                for (var i = 0; i < 11; i++)
                  Container(
                    width: double.infinity,
                    height: 50,
                    color: i % 2 == 0
                        ? const Color.fromARGB(255, 64, 121, 66)
                        : const Color.fromARGB(255, 7, 107, 10),
                  )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomPaint(
                painter: MyPainter(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 8,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: MyPainter01(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4 - 20,
                  height: MediaQuery.of(context).size.width / 8 - 17,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: MyPainter02(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.width / 4 - 20,
                ),
              ),
            ),
            if (formation != null) formation!
          ],
        ),
      ),
    );
  }
}
