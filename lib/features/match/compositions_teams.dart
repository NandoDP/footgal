import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/paints.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/terrain_screen.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/features/match/formation.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';

class CompositionsTeams extends ConsumerStatefulWidget {
  final MatchM match;
  final int minute;
  final TeamM team1;
  final TeamM team2;
  final List<bool> isChanged;
  const CompositionsTeams({
    super.key,
    required this.match,
    required this.minute,
    required this.team1,
    required this.team2,
    required this.isChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompositionsTeamsConsumerState();
}

class _CompositionsTeamsConsumerState extends ConsumerState<CompositionsTeams> {
  int selectedTeam = 0;
  String? selectedFormation1;
  String? selectedFormation2;
  String? formation;
  List<Map<String, dynamic>> onze = [{}, {}];
  List<List<String>> onzeUid = [[], []];
  List<List<String>> substUid = [[], []];
  late List<String> A, B, C;

  @override
  void initState() {
    super.initState();
    setState(() {
      A = [...widget.match.team1Composition];
      A.removeAt(0);
      B = [...widget.match.team2Composition];
      B.removeAt(0);

      if (widget.match.team1Composition[0] != '') {
        changeFormation(widget.match.team1Composition[0], A, 0);
      }
      if (widget.match.team2Composition[0] != '') {
        changeFormation(widget.match.team2Composition[0], B, 1);
      }
    });
  }

  void selectTeam(int index) {
    setState(() {
      selectedTeam = index;
    });
  }

  // void change() {
  //   changeFormation(formation!, C, selectedTeam);
  // }

  void changeFormation(String val, List<String> C, int selectedTeam) {
    setState(() {
      // selectedTeam == 0 ? selectedFormation1 = val : selectedFormation2 = val;
      widget.isChanged[selectedTeam] = true;

      int z = val.split('-').length;
      int a = int.parse(val.split('-')[0]);
      int b = int.parse(val.split('-')[1]);
      int c = int.parse(val.split('-')[2]);
      onze[selectedTeam] = {};
      onzeUid[selectedTeam] = [];
      substUid[selectedTeam] = [];
      onze[selectedTeam]['Gardien'] = [C[0]];
      if (z == 3) {
        onze[selectedTeam]['Defense'] = [...C.getRange(1, a + 1)];
        onze[selectedTeam]['Milieu'] = [...C.getRange(a + 1, a + b + 1)];
        onze[selectedTeam]
            ['Attaque'] = [...C.getRange(a + b + 1, a + b + c + 1)];
      } else {
        int d = int.parse(val.split('-')[3]);
        onze[selectedTeam]['Defense'] = [...C.getRange(1, a + 1)];
        onze[selectedTeam]['MilieuDef'] = [...C.getRange(a + 1, a + b + 1)];
        onze[selectedTeam]
            ['MilieuOff'] = [...C.getRange(a + b + 1, a + b + c + 1)];
        onze[selectedTeam]
            ['Attaque'] = [...C.getRange(a + b + c + 1, a + b + c + d + 1)];
      }

      for (var element in onze[selectedTeam].keys) {
        for (var e in onze[selectedTeam][element]) {
          onzeUid[selectedTeam].add(e);
        }
      }
      for (var element in C) {
        if (!onzeUid[selectedTeam].contains(element)) {
          substUid[selectedTeam].add(element);
        }
      }
    });
  }

  void navigateToEditCompo() {
    Routemaster.of(context).push('/match/${widget.match.uid}/$selectedTeam');
  }

  void navigateToPlayer(String uid) {
    Routemaster.of(context).push('/p/$uid');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isAdmin = user.isAdmin;

    String? selectedFormation =
        selectedTeam == 0 ? selectedFormation1 : selectedFormation2;
    var teamsFormation = [
      widget.match.team1Composition,
      widget.match.team2Composition
    ];
    formation = isAdmin
        ? selectedFormation ?? teamsFormation[selectedTeam][0]
        : teamsFormation[selectedTeam][0];
    teamsFormation[selectedTeam][0] = formation!;

    C = selectedTeam == 0 ? A : B;
    int j = 11;

    List<String> yellowCards = widget.match.yellowCards.keys.toList();
    List<String> redCards = widget.match.redCards.keys.toList();
    List<String> scoreurs =
        widget.match.scoreurs.keys.map((e) => e.split('|')[0]).toList();
    List<String> changements =
        widget.match.changements.keys.map((e) => e.split('|')[1]).toList();
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => selectTeam(0),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTeam == 0 ? Colors.black : Colors.white,
                  ),
                  child: Text(
                    widget.match.team1Name,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedTeam == 0 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => selectTeam(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedTeam == 1 ? Colors.black : Colors.white,
                  ),
                  child: Text(
                    widget.match.team2Name,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedTeam == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        formation == '' && !isAdmin
            ? Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                    "La composition de cette équipe n'est pas encore disponible.\nReviens plus tard !"),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Card(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.done_outlined,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Compo officielle',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                isAdmin
                                    ? Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () =>
                                                navigateToEditCompo(),
                                            child: const Text(
                                              'Changer',
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          if (formation != '')
                                            Text(
                                              formation!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                        ],
                                      )
                                    : Text(
                                        formation!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Terrain(
                    formation: Formation(
                      // changeFormation: change,
                      onze: onze[selectedTeam],
                      titusUid: onzeUid[selectedTeam],
                      subsUid: substUid[selectedTeam],
                      minute: widget.minute,
                      match: widget.match,
                      team1: widget.team1,
                      team2: widget.team2,
                      isChanged: widget.isChanged[selectedTeam],
                    ),
                  ),
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
                                'REMPLACANTS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ref
                              .watch(getPlayersMatchProvider(
                                  substUid[selectedTeam]))
                              .when(
                                data: (players) => Column(
                                  children: players.map(
                                    (e) {
                                      j++;
                                      return Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6),
                                            child: Divider(height: 0),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ListTile(
                                              onTap: () =>
                                                  navigateToPlayer(e.uid),
                                              leading: SizedBox(
                                                child: Stack(
                                                  children: [
                                                    e.profilePic != null
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                Colors.white,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              e.profilePic!,
                                                            ),
                                                            radius: 21,
                                                          )
                                                        : const CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black,
                                                            radius: 21,
                                                            child: Icon(
                                                              Icons
                                                                  .person_2_rounded,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                    if (yellowCards
                                                        .contains(e.uid))
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                right: 15),
                                                        child: CircleAvatar(
                                                          radius: 7,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            Icons
                                                                .square_rounded,
                                                            color:
                                                                Colors.yellow,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    if (redCards
                                                        .contains(e.uid))
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                right: 15),
                                                        child: CircleAvatar(
                                                          radius: 7,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: Icon(
                                                            Icons
                                                                .square_rounded,
                                                            color: Colors.red,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    if (changements
                                                        .contains(e.uid))
                                                      const CircleAvatar(
                                                        radius: 7,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons
                                                              .swap_horizontal_circle_sharp,
                                                          size: 14,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(e.name),
                                                  Text(
                                                    '$j',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ),
                                error: (error, stackTrace) => ErrorPage(
                                  error: error.toString(),
                                ),
                                loading: () => const SizedBox(),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
