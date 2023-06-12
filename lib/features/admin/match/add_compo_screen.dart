import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/common/terrain_screen.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/match/add_compo_service.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:routemaster/routemaster.dart';

class AddCompoScreen extends ConsumerStatefulWidget {
  final String uid;
  final int n;
  AddCompoScreen({
    super.key,
    required this.uid,
    required this.n,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCompoScreenConsumerState();
}

class _AddCompoScreenConsumerState extends ConsumerState<AddCompoScreen> {
  String? selectedFormation;
  List<PlayerM> listSub = [];
  List<PlayerM> listTitu = [];
  List<String> formations = [
    '3-4-3',
    '3-5-2',
    '3-2-3-2',
    '4-4-2',
    '4-3-3',
    '4-2-3-1',
    '4-1-4-1',
    '5-3-2',
  ];

  void save(
    MatchM match,
    List<String> teamComposition,
    int n,
  ) {
    if (teamComposition.length > 19) {
      teamComposition = [...teamComposition.getRange(0, 19).toList()];
    }
    ref
        .watch(addCompoServicesProvider.notifier)
        .addCompo(match: match, teamComposition: teamComposition, n: n);
    ref
        .watch(addCompoServicesProvider.notifier)
        .increMatch(listTitu, match.competition);
    showSnackBar(context, 'Composition officielle !');
    Routemaster.of(context).push('/match/${match.uid}');
  }

  @override
  Widget build(BuildContext context) {
    final formation = selectedFormation ?? formations[0];
    return ref.watch(getMatchProvider(widget.uid)).when(
          data: (match) {
            String teamName = widget.n == 0 ? match.team1Name : match.team2Name;
            return ref.watch(getTeamProvider(teamName)).when(
                  data: (team) => ref
                      .watch(getPlayersMatchProvider(team.players))
                      .when(
                        data: (players) {
                          listSub = players;
                          if (listSub.length < 11) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(team.name),
                                backgroundColor: Colors.black,
                              ),
                              body: const Center(
                                child: Text(
                                  "Cette Equipe n'a pas assez de joueurs.",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }
                          listTitu = listSub.getRange(0, 11).toList();
                          int j = 10;
                          return Scaffold(
                            appBar: AppBar(
                              title: Text(team.name),
                              backgroundColor: Colors.black,
                            ),
                            body: ListView(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Composition',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () => save(
                                                      match,
                                                      [
                                                        formation,
                                                        ...listSub
                                                            .map((e) => e.uid)
                                                      ],
                                                      widget.n,
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.black,
                                                    ),
                                                    child:
                                                        const Text('Valider'),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  DropdownButton(
                                                    value: selectedFormation ??
                                                        formations[0],
                                                    items: formations
                                                        .map(
                                                          (e) =>
                                                              DropdownMenuItem(
                                                            value: e,
                                                            child: Text(e),
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedFormation = val;
                                                      });
                                                      // changeFormation(
                                                      //     val!, C, selectedTeam);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Terrain(
                                  formation: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: '1-$formation'
                                        .split('-')
                                        .reversed
                                        .map(
                                          (e) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              for (var i = 0;
                                                  i < int.parse(e);
                                                  i++, j--)
                                                Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 21,
                                                      backgroundColor:
                                                          Colors.black,
                                                      child: buildPopUpMenu(
                                                        players[j],
                                                        listSub,
                                                        const Icon(
                                                          Icons
                                                              .person_outline_outlined,
                                                          // color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${j + 1} ',
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    131,
                                                                    255,
                                                                    255,
                                                                    255),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 70,
                                                          child: Text(
                                                            listSub[j].name,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                Column(
                                  children: listSub
                                      .map(
                                        (e) => buildPopUpMenu(
                                          e,
                                          listSub,
                                          Column(
                                            children: [
                                              if (listSub.indexOf(e) == 0)
                                                Container(
                                                  color: Colors.grey,
                                                  child:
                                                      const Text('TITULAIRES'),
                                                ),
                                              if (listSub.indexOf(e) == 11)
                                                Container(
                                                  color: Colors.grey,
                                                  child:
                                                      const Text('REMPLACANTS'),
                                                ),
                                              if (listSub.indexOf(e) == 18)
                                                Container(
                                                  color: Colors.grey,
                                                  child: const Text('RESERVES'),
                                                ),
                                              ListTile(
                                                leading: Text(
                                                    '${listSub.indexOf(e) + 1}'),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(e.name),
                                                    Text(e.position),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          );
                        },
                        error: (error, stackTrace) => Scaffold(
                          body: ErrorPage(
                            error: error.toString(),
                          ),
                        ),
                        loading: () => const Loader(),
                      ),
                  error: (error, stackTrace) => Scaffold(
                    body: ErrorPage(
                      error: error.toString(),
                    ),
                  ),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => Scaffold(
            body: ErrorPage(
              error: error.toString(),
            ),
          ),
          loading: () => const Loader(),
        );
  }

  Widget buildPopUpMenu(PlayerM player, List<PlayerM> players, Widget child) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        for (var i in players)
          PopupMenuItem(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  int id_1 = players.indexOf(player);
                  int id_2 = players.indexOf(i);
                  players[id_1] = i;
                  players[id_2] = player;
                });
                Navigator.of(context).pop();
              },
              child: Text(i.name),
            ),
          ),
      ],
      child: child,
    );
  }
}
