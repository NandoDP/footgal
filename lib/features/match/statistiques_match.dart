import 'package:flutter/material.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StatistiquesMatch extends StatelessWidget {
  final StatsMatch statsMatch;
  const StatistiquesMatch({super.key, required this.statsMatch});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListView(
        children: [
          ...plaques('BUTS', statsMatch.buts),
          ...plaques('TIRS', statsMatch.tirs),
          ...plaques('TIRS CADRE', statsMatch.tirsCadres),
          ...plaques('POSSESSION', statsMatch.possession),
          ...plaques('PASSES', statsMatch.passes),
          ...plaques('PRECISION DE PASSES', statsMatch.precisionPasses),
          ...plaques('FAUTES', statsMatch.fautes),
          ...plaques('CARTONS JAUNES', statsMatch.yellowCard),
          ...plaques('CARTONS ROUGES', statsMatch.redCard),
          ...plaques('HORS-JEU', statsMatch.horsJeu),
          ...plaques('CORNERS', statsMatch.corners),
        ],
      ),
    );
  }
}

List<Widget> plaques(String name, List<int> list) {
  return [
    Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(name),
          const SizedBox(height: 5),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${list[0]}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${list[1]}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: 2,
                  child: LinearPercentIndicator(
                    lineHeight: 6.0,
                    percent: list[0] + list[1] != 0
                        ? list[0] / (list[0] + list[1])
                        : 0,
                    animation: true,
                    barRadius: const Radius.circular(2),
                    progressColor:
                        list[0] > list[1] ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: LinearPercentIndicator(
                  lineHeight: 6.0,
                  percent: list[0] + list[1] != 0
                      ? list[1] / (list[0] + list[1])
                      : 0,
                  animation: true,
                  barRadius: const Radius.circular(2),
                  progressColor: list[0] < list[1] ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    const Padding(
      padding: EdgeInsets.all(8),
      child: Divider(),
    ),
  ];
}
