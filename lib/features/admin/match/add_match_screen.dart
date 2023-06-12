import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/match/add_match_service.dart';
import 'package:footgal/features/admin/player/add_player_service.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';

class AddMatchScreen extends ConsumerStatefulWidget {
  final String uid;
  final String compet;
  AddMatchScreen({
    super.key,
    required this.uid,
    required this.compet,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends ConsumerState<AddMatchScreen> {
  TextEditingController stadeController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  TeamM? selectedTeam1, selectedTeam2;
  List<TeamM> teams = [];
  // List<String> playersTeam1 = [];
  // List<String> playersTeam2 = [];
  DateTime datetime = DateTime.now();
  TimeOfDay time = const TimeOfDay(hour: 16, minute: 30);
  CompetitionM? selectedCompetition;
  List<CompetitionM> competitions = [];

  void _selectedDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      setState(() {
        datetime = value!;
        dateController.text = "${value.day}/${value.month}/${value.year}";
      });
    });
  }

  void _selectedTime() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        time = value!;
        timeController.text = time.format(context);
      });
    });
  }

  // void addPlayer(String uid, int index) {
  //   if (index == 0) {
  //     if (playersTeam1.length < 18) {
  //       setState(() {
  //         playersTeam1.add(uid);
  //       });
  //     } else {
  //       showSnackBar(
  //           context, 'Il y a deja 18 joueur. Veuillez enlever un autre !');
  //     }
  //   } else {
  //     if (playersTeam2.length < 18) {
  //       setState(() {
  //         playersTeam2.add(uid);
  //       });
  //     } else {
  //       showSnackBar(
  //           context, 'Il y a deja 18 joueur. Veuillez enlever un autre !');
  //     }
  //   }
  // }

  // void removePlayer(String uid, int index) {
  //   if (index == 0) {
  //     setState(() {
  //       playersTeam1.remove(uid);
  //     });
  //   } else {
  //     setState(() {
  //       playersTeam2.remove(uid);
  //     });
  //   }
  // }

  void addMatch() {
    if (stadeController.text.isNotEmpty
        // &&
        //     playersTeam1.length > 11 &&
        //     playersTeam2.length > 11
        ) {
      // StatsMatch statsMatch = StatsMatch(
      //   buts: [0, 0],
      //   tirs: [0, 0],
      //   tirsCadres: [0, 0],
      //   possession: [0, 0],
      //   passes: [0, 0],
      //   precisionPasses: [0, 0],
      //   fautes: [0, 0],
      //   yellowCard: [0, 0],
      //   redCard: [0, 0],
      //   horsJeu: [0, 0],
      //   corners: [0, 0],
      // );

      // MatchM match = MatchM(
      //   uid: widget.uid,
      //   competition: widget.compet,
      //   stade: stadeController.text.trim(),
      //   date: DateTime.utc(datetime.year, datetime.month, datetime.day,
      //       time.hour, time.minute),
      //   statsMatch: statsMatch,
      //   team1Name: selectedTeam1 != null ? selectedTeam1!.name : teams[0].name,
      //   team2Name: selectedTeam2 != null ? selectedTeam2!.name : teams[1].name,
      //   team1Composition: [],
      //   team2Composition: [],
      //   redCards: {},
      //   scoreurs: {},
      //   yellowCards: {},
      //   statue: 0,
      //   changements: {},
      // );
      // Routemaster.of(context).push('/c/${widget.compet.split(' ').join('-')}');
      // ref.watch(addMatchServiceProvider).addMatch(
      //       context: context,
      //       // match: match,
      //       date: DateTime.utc(datetime.year, datetime.month, datetime.day,
      //           time.hour, time.minute),
      //       competition: selectedCompetition ?? competitions[0],
      //       stade: stadeController.text.trim(),
      //       // team1Composition: [''],
      //       // team1Composition: ['', ...playersTeam1],
      //       team1: selectedTeam1 ?? teams[0],
      //       // team2Composition: [''],
      //       team2: selectedTeam2 ?? teams[1],
      //     );
    } else if (stadeController.text.isEmpty) {
      showSnackBar(context, 'Remplisser tous les champs');
    } else {
      showSnackBar(context, 'Chaque équipe dois avoir au moins 12 joueurs !');
    }
  }

  @override
  void dispose() {
    super.dispose();
    stadeController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Match'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => addMatch(),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: stadeController,
              decoration: const InputDecoration(
                filled: true,
                hintText: 'Stade',
                border: InputBorder.none,
              ),
            ),
          ),
          // const SizedBox(height: 10),
          // ref.watch(getAllCompetitionProvider).when(
          //       data: (data) {
          //         competitions = data;
          //         return Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             const Text('Competition : '),
          //             const SizedBox(width: 10),
          //             DropdownButton(
          //               value: selectedCompetition ?? competitions[0],
          //               items: competitions
          //                   .map(
          //                     (e) => DropdownMenuItem(
          //                       value: e,
          //                       child: Text(e.name),
          //                     ),
          //                   )
          //                   .toList(),
          //               onChanged: (val) {
          //                 setState(() {
          //                   selectedCompetition = val;
          //                 });
          //               },
          //             ),
          //           ],
          //         );
          //       },
          //       error: (error, stackTrace) => ErrorPage(
          //         error: error.toString(),
          //       ),
          //       loading: () => const Loader(),
          //     ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Date',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                    labelText:
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  ),
                ),
              ),
              MaterialButton(
                onPressed: _selectedDate,
                color: Colors.black,
                child: const Text(
                  "Choisir date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Heure',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                    labelText: TimeOfDay.now().format(context),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: _selectedTime,
                color: Colors.black,
                child: const Text(
                  "Choisir heure",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          ref.watch(getAllTeamsProvider).when(
                data: (data) {
                  teams = data;
                  // TeamM team1 = selectedTeam1 ?? data[0];
                  // TeamM team2 = selectedTeam2 ?? data[1];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DropdownButton(
                            value: selectedTeam1 ?? data[0],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedTeam1 = val;
                              });
                            },
                          ),
                          DropdownButton(
                            value: selectedTeam2 ?? data[1],
                            items: data
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedTeam2 = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
