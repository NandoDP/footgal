import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
// import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/features/match/compositions_teams.dart';
import 'package:footgal/features/match/resume_match.dart';
import 'package:footgal/features/match/statistiques_match.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';

class MatchScreen extends ConsumerStatefulWidget {
  final String uid;
  const MatchScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MatchScreenConsumerState();
}

class _MatchScreenConsumerState extends ConsumerState<MatchScreen> {
  int page = 0;
  final double size = 45;
  List<bool> isChanged = [false, false];
  int? timeH, timeM, timeS;
  // String statue = 'Avant Match';
  List<String> statues = [
    'Avant Match',
    '1er Mi-temps',
    'Mi-temps',
    '2nd Mi-temps',
    'Terminé',
  ];
  void selectPage(int index) {
    setState(() {
      page = index;
    });
  }

  void changeStatue(MatchM match, int statue, TeamM team1, TeamM team2) {
    ref.watch(matchServicesProvider.notifier).changeStatueMatch(
          match: match,
          statue: statue,
          context: context,
        );
    if (statue == 4) {
      int buts1 = match.statsMatch.buts[0];
      int buts2 = match.statsMatch.buts[1];
      ref.watch(matchServicesProvider.notifier).endMatch(
            team1: team1,
            pt1: buts1 == buts2
                ? 1
                : buts1 > buts2
                    ? 3
                    : 0,
            team2: team2,
            pt2: buts1 == buts2
                ? 1
                : buts1 < buts2
                    ? 3
                    : 0,
            compet: match.competition,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isAdmin = user.isAdmin;
    return ref.watch(getMatchProvider(widget.uid)).when(
          data: (match) {
            final time = DateTime.now().difference(match.date);
            int minuteJouer = 0;
            if (match.statue == 1) {
              minuteJouer =
                  DateTime.now().difference(match.start1Mt!).inMinutes.abs();
            } else if (match.statue == 3) {
              minuteJouer =
                  DateTime.now().difference(match.start2Mt!).inMinutes.abs() +
                      45;
            }
            if (time.isNegative) {
              timeH = time.inHours;
              timeM = time.inMinutes - timeH! * 60;
              timeS = time.inSeconds - timeM! * 60 - timeH! * 60 * 60;
            }
            return ref.watch(getMatchTeamsProvider(match)).when(
                  data: (teams) {
                    // print('object');
                    if (match.team1Name != teams[0].name) {
                      teams = teams.reversed.toList();
                      if (match.team1Name != teams[0].name) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: const Center(
                            child: ErrorPage(
                              error:
                                  "On dirait que quelque chose s'est mal passer",
                            ),
                          ),
                        );
                      }
                    }
                    final name1 = teams[0].name.split(' ').join('-');
                    final name2 = teams[1].name.split(' ').join('-');
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.black,
                        title: isAdmin
                            ? DropdownButton(
                                value: statues[match.statue],
                                style: const TextStyle(color: Colors.white),
                                items: statues
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  changeStatue(
                                    match,
                                    statues.indexOf(val!),
                                    teams[0],
                                    teams[1],
                                  );
                                },
                              )
                            : null,
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share_rounded),
                          )
                        ],
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(130),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Routemaster.of(context)
                                              .push('/t/$name1');
                                        },
                                        child: Image.network(
                                          teams[0].profilePic,
                                          width: size,
                                          height: size,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        teams[0].name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      if (match.statue == 0) ...[
                                        time.isNegative
                                            ? Text(
                                                '${timeH!.abs().toString().padLeft(2, '0')}:${timeM!.abs().toString().padLeft(2, '0')}:${timeS!.abs().toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              )
                                            : Text(
                                                match.date
                                                            .difference(
                                                                DateTime.now())
                                                            .inDays
                                                            .abs() <
                                                        1
                                                    ? "Aujourd'hui"
                                                    : '${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year.toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                        Text(
                                          '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      if (match.statue != 0)
                                        Text(
                                          '${match.statsMatch.buts[0]} : ${match.statsMatch.buts[1]}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      if (match.statue == 1)
                                        Text(
                                          minuteJouer < 46
                                              ? "$minuteJouer'"
                                              : "45+${minuteJouer - 45}'",
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16,
                                          ),
                                        ),
                                      if (match.statue == 2)
                                        const Text(
                                          'Mi-temps',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      if (match.statue == 3)
                                        Text(
                                          minuteJouer < 91
                                              ? "$minuteJouer'"
                                              : "90+${minuteJouer - 90}'",
                                          style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 16,
                                          ),
                                        ),
                                      if (match.statue == 4)
                                        const Text(
                                          'TERMINE',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Routemaster.of(context)
                                              .push('/t/$name2');
                                        },
                                        child: Image.network(
                                          teams[1].profilePic,
                                          width: size,
                                          height: size,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        teams[1].name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 30,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: page == 0
                                              ? const Border(
                                                  bottom: BorderSide(
                                                  width: 2,
                                                  color: Colors.white,
                                                ))
                                              : null,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => selectPage(0),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            elevation: 0,
                                          ),
                                          child: Text(
                                            'Résumé',
                                            style: TextStyle(
                                              color: page == 0
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: page == 1
                                              ? const Border(
                                                  bottom: BorderSide(
                                                  width: 2,
                                                  color: Colors.white,
                                                ))
                                              : null,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => selectPage(1),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            elevation: 0,
                                            // side: page == 1
                                            //     ? const BorderSide(
                                            //         width: 1,
                                            //         color: Colors.white,
                                            //       )
                                            //     : null,
                                          ),
                                          child: Text(
                                            'Fil du Match',
                                            style: TextStyle(
                                              color: page == 1
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: page == 2
                                              ? const Border(
                                                  bottom: BorderSide(
                                                  width: 2,
                                                  color: Colors.white,
                                                ))
                                              : null,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => selectPage(2),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            elevation: 0,
                                            // side: page == 2
                                            //     ? const BorderSide(
                                            //         width: 1,
                                            //         color: Colors.white,
                                            //       )
                                            //     : null,
                                          ),
                                          child: Text(
                                            'Compositions',
                                            style: TextStyle(
                                              color: page == 2
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: page == 3
                                              ? const Border(
                                                  bottom: BorderSide(
                                                  width: 2,
                                                  color: Colors.white,
                                                ))
                                              : null,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () => selectPage(3),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            elevation: 0,
                                            // side: page == 3
                                            //     ? const BorderSide(
                                            //         width: 1,
                                            //         color: Colors.white,
                                            //       )
                                            //     : null,
                                          ),
                                          child: Text(
                                            'Statistiques',
                                            style: TextStyle(
                                              color: page == 3
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
                      body: page == 0
                          ? ResumeMatch(match: match)
                          : page == 1
                              ? Center(
                                  child: Text(match.date
                                              .compareTo(DateTime.now()) >
                                          0
                                      ? "Ce match n'a pas encore commencé.\nReviens plus tard !"
                                      : 'Le match a commencé'),
                                )
                              : page == 2
                                  ? CompositionsTeams(
                                      match: match,
                                      minute: minuteJouer,
                                      team1: teams[0],
                                      team2: teams[1],
                                      isChanged: isChanged,
                                    )
                                  : StatistiquesMatch(
                                      statsMatch: match.statsMatch,
                                    ),
                      // PageView(
                      //   onPageChanged: (value) => selectPage(value),
                      //   children: [
                      //     ResumeMatch(match: match),
                      //     // match.date.compareTo(DateTime.now()) > 0
                      //     //     ? const Center(
                      //     //         child: Text(
                      //     //             "Ce match n'a pas encore commencé.\nReviens plus tard !"),
                      //     //       )
                      //     //     : const ResumeMatch(),
                      //     Center(
                      //       child: Text(match.date.compareTo(DateTime.now()) > 0
                      //           ? "Ce match n'a pas encore commencé.\nReviens plus tard !"
                      //           : 'Le match a commencé'),
                      //     ),

                      //     CompositionsTeams(
                      //       match: match,
                      //       team1: data[0],
                      //       team2: data[1],
                      //       isChanged: isChanged,
                      //     ),
                      //     StatistiquesMatch(statsMatch: match.statsMatch),
                      //     // match.date.compareTo(DateTime.now()) > 0
                      //     //     ? const Center(
                      //     //         child: Text(
                      //     //             "Ce match n'a pas encore commencé.\nReviens plus tard !"),
                      //     //       )
                      //     //     : StatistiquesMatch(statsMatch: match.statsMatch),
                      //   ],
                      // ),
                    );
                  },
                  error: (error, stackTrace) => ErrorPage(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
