import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/models/match_model.dart';

class ResumeMatch extends ConsumerStatefulWidget {
  final MatchM match;
  const ResumeMatch({
    super.key,
    required this.match,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResumeMatchConsumerState();
}

class _ResumeMatchConsumerState extends ConsumerState<ResumeMatch> {
  List<List> resume = [];

  @override
  void initState() {
    super.initState();
    resumer();
  }

  void resumer() {
    for (var y in widget.match.yellowCards.keys) {
      if (widget.match.team1Composition.contains(y)) {
        resume.add(['YellowCard', widget.match.yellowCards[y], '$y|', 0]);
      } else {
        resume.add(['YellowCard', widget.match.yellowCards[y], '$y|', 1]);
      }
    }
    for (var y in widget.match.redCards.keys) {
      if (widget.match.team1Composition.contains(y)) {
        resume.add(['redCard', widget.match.redCards[y], '$y|', 0]);
      } else {
        resume.add(['redCard', widget.match.redCards[y], '$y|', 1]);
      }
    }
    for (var y in widget.match.changements.keys) {
      if (widget.match.team1Composition.contains(y.split('|')[0])) {
        resume.add(['changement', widget.match.changements[y], y, 0]);
      } else {
        resume.add(['changement', widget.match.changements[y], y, 1]);
      }
    }
    for (var y in widget.match.scoreurs.keys) {
      if (widget.match.team1Composition.contains(y.split('|')[0])) {
        resume.add(['goal', widget.match.scoreurs[y], y, 0]);
      } else {
        resume.add(['goal', widget.match.scoreurs[y], y, 1]);
      }
    }
    resume.sort((a, b) => a[1].compareTo(b[1]));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'RESUME DU MATCH',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Divider(height: 0),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      for (var event in resume.reversed) ...[
                        event[3] == 0
                            ? Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${event[1]}'",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (event[0] == 'YellowCard')
                                      const Icon(
                                        Icons.square_rounded,
                                        color: Colors.yellow,
                                        size: 26,
                                      ),
                                    if (event[0] == 'redCard')
                                      const Icon(
                                        Icons.square_rounded,
                                        color: Colors.red,
                                        size: 26,
                                      ),
                                    if (event[0] == 'changement')
                                      const Icon(
                                        Icons.swap_horizontal_circle_sharp,
                                        // Icons.published_with_changes,
                                        size: 26,
                                      ),
                                    if (event[0] == 'goal')
                                      const Icon(
                                        Icons.sports_soccer_outlined,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (event[0] != 'changement') ...[
                                          ref
                                              .watch(getPlayerProvider(
                                                  event[2].split('|')[0]))
                                              .when(
                                                data: (player) => Text(
                                                  player.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                error: (error, stackTrace) =>
                                                    ErrorPage(
                                                  error: error.toString(),
                                                ),
                                                loading: () => const Loader(),
                                              ),
                                          if (event[2].split('|')[1] != '')
                                            ref
                                                .watch(getPlayerProvider(
                                                    event[2].split('|')[1]))
                                                .when(
                                                  data: (player) => Text(
                                                    'Passeur: ${player.name}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  error: (error, stackTrace) =>
                                                      ErrorPage(
                                                    error: error.toString(),
                                                  ),
                                                  loading: () => const Loader(),
                                                ),
                                        ],
                                        if (event[0] == 'changement') ...[
                                          ref
                                              .watch(getPlayerProvider(
                                                  event[2].split('|')[1]))
                                              .when(
                                                data: (player) => Text(
                                                  player.name,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                error: (error, stackTrace) =>
                                                    ErrorPage(
                                                  error: error.toString(),
                                                ),
                                                loading: () => const Loader(),
                                              ),
                                          ref
                                              .watch(getPlayerProvider(
                                                  event[2].split('|')[0]))
                                              .when(
                                                data: (player) => Text(
                                                  player.name,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                error: (error, stackTrace) =>
                                                    ErrorPage(
                                                  error: error.toString(),
                                                ),
                                                loading: () => const Loader(),
                                              ),
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ref
                                            .watch(getPlayerProvider(
                                                event[2].split('|')[0]))
                                            .when(
                                              data: (player) => Text(
                                                player.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              error: (error, stackTrace) =>
                                                  ErrorPage(
                                                error: error.toString(),
                                              ),
                                              loading: () => const Loader(),
                                            ),
                                        if (event[2].split('|')[1] != '')
                                          ref
                                              .watch(getPlayerProvider(
                                                  event[2].split('|')[1]))
                                              .when(
                                                data: (player) => Text(
                                                  'Passeur: ${player.name}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                error: (error, stackTrace) =>
                                                    ErrorPage(
                                                  error: error.toString(),
                                                ),
                                                loading: () => const Loader(),
                                              ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    if (event[0] == 'YellowCard')
                                      const Icon(
                                        Icons.square_rounded,
                                        color: Colors.yellow,
                                        size: 26,
                                      ),
                                    if (event[0] == 'redCard')
                                      const Icon(
                                        Icons.square_rounded,
                                        color: Colors.red,
                                        size: 26,
                                      ),
                                    if (event[0] == 'changement')
                                      const Icon(
                                        Icons.swap_horizontal_circle_sharp,
                                        size: 26,
                                      ),
                                    if (event[0] == 'goal')
                                      const Icon(
                                        Icons.sports_soccer_outlined,
                                        color: Colors.black,
                                        size: 26,
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${event[1]}'",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Divider(height: 0),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
