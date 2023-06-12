import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/common/match_card.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/match/add_match_screen.dart';
import 'package:footgal/features/admin/match/add_match_service.dart';
import 'package:footgal/features/admin/player/add_player_service.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/features/view_profils/profils_services.dart';
import 'package:footgal/models/competition.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/stats_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

class CompetitionProfileScreen extends ConsumerStatefulWidget {
  final String name;
  const CompetitionProfileScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompetitionProfileScreenConsumerState();
}

class _CompetitionProfileScreenConsumerState
    extends ConsumerState<CompetitionProfileScreen> {
  int page = 0;
  String selectedJournee = 'Journee 1';
  List<TeamM> allTeam = [];
  List<TeamM> allTeam1 = [];
  // List<bool>
  List<String> journees =
      Iterable.generate(26).map((e) => 'Journee ${e + 1}').toList();

  void changeView(int index) {
    setState(() {
      page = index;
    });
  }

  void navigateToPlayer(String uid) {
    Routemaster.of(context).push('/p/$uid');
  }

  void navigateToTeam(String team) {
    Routemaster.of(context).push('/t/${team.split(' ').join('-')}');
  }

  void abonnementTeam(TeamM team) {
    ref.watch(profilsServicesProvider.notifier).abonnementTeam(team);
    showSnackBar(context, 'Vous etes abonner a ${team.name}');
  }

  void abonnementCompet(CompetitionM competition) {
    ref
        .watch(profilsServicesProvider.notifier)
        .abonnementCompetition(competition);
    showSnackBar(context, 'Vous etes abonner a ${competition.name}');
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userProvider)!.uid;
    final competitionName = widget.name.split('-').join(' ');
    return ref.watch(getCompetitionProvider(competitionName)).when(
          data: (compet) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: null,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(300),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.blueGrey,
                                  backgroundImage:
                                      NetworkImage(compet.profilePic),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  compet.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Senegal',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(
                                left: 20, top: 185, bottom: 15),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => abonnementCompet(compet),
                                  icon: Icon(
                                    compet.followers.contains(uid)
                                        ? Icons.star_rate_rounded
                                        : Icons.star_border_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${compet.followers.length}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(149, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: page == 0
                                      ? const Border(
                                          bottom: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ))
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => changeView(0),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Classement',
                                    style: TextStyle(
                                      color: page == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: page == 1
                                      ? const Border(
                                          bottom: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ))
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => changeView(1),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Journee',
                                    style: TextStyle(
                                      color: page == 1
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: page == 2
                                      ? const Border(
                                          bottom: BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ))
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => changeView(2),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Statistiques',
                                    style: TextStyle(
                                      color: page == 2
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: page == 3
                                      ? const Border(
                                          bottom: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                                child: ElevatedButton(
                                  onPressed: () => changeView(3),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Equipes',
                                    style: TextStyle(
                                      color: page == 3
                                          ? Colors.black
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
              body: ListView(
                children: [
                  if (page == 0) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            // 'CLASSEMENT',
                            '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 170,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('J'),
                                Text('Buts'),
                                Text('Diff.'),
                                Text('Pts.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 0),
                    ),
                    ref.watch(getAllTeamsProvider).when(
                          data: (teams) {
                            teams = classer(teams, competitionName);
                            allTeam = teams;
                            allTeam1 = [...teams];
                            return Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  for (var i = 0; i < teams.length; i++)
                                    ListTile(
                                      onTap: () =>
                                          navigateToTeam(teams[i].name),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text('${i + 1}'),
                                              const SizedBox(width: 10),
                                              const Icon(
                                                Icons.circle_outlined,
                                                size: 8,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(width: 10),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(
                                                    teams[i].profilePic),
                                                radius: 14,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(teams[i].name),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${teams[i].stats.matchs[competitionName]}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  '${teams[i].stats.buts[competitionName]}:${teams[i].stats.butsConcedes[competitionName]}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  '${teams[i].stats.buts[competitionName] - teams[i].stats.butsConcedes[competitionName]}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                    '${teams[i].stats.points[competitionName]}'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          error: (error, stackTrace) => ErrorPage(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
                  ],
                  if (page == 1) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 1,
                        child: DropdownButtonFormField(
                          value: selectedJournee,
                          decoration: const InputDecoration(
                            prefix: Text('  '),
                            border: InputBorder.none,
                          ),
                          items: journees
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedJournee = val!;
                            });
                          },
                        ),
                      ),
                    ),
                    for (var i = 0; i < 7; i++) ...[
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Divider(height: 0),
                          ),
                          SizedBox(
                            height: 80,
                            child: ListTile(
                              tileColor: Colors.white,
                              onTap: () =>
                                  compet.matchs[selectedJournee].length > i
                                      ? () {}
                                      : addMatch(compet, selectedJournee),
                              title: compet.matchs[selectedJournee].length > i
                                  ? ref
                                      .watch(getMatchProvider(
                                          compet.matchs[selectedJournee][i]))
                                      .when(
                                        data: (match) =>
                                            MatchCard(match: match),
                                        error: (error, stackTrace) => ErrorPage(
                                          error: error.toString(),
                                        ),
                                        loading: () => const Loader(),
                                      )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                  if (page == 2) ...[
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
                                  'BUTEURS',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ref
                                .watch(getTopScoreurProvider(competitionName))
                                .when(
                                  data: (players) {
                                    return Column(
                                      children: [
                                        for (var i = 0; i < 3; i++) ...[
                                          Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Divider(height: 0),
                                              ),
                                              ListTile(
                                                onTap: () => navigateToPlayer(
                                                    players[i].uid),
                                                leading: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: players[i]
                                                              .profilePic !=
                                                          null
                                                      ? CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            players[i]
                                                                .profilePic!,
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
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(players[i].name),
                                                    Text(
                                                      '${players[i].stats.buts[competitionName]}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(players[i].team),
                                              ),
                                            ],
                                          )
                                        ]
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) => ErrorPage(
                                    error: error.toString(),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                            const Divider(height: 0),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  'PASSES DECISIVES',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ref
                                .watch(getTopPasseursProvider(competitionName))
                                .when(
                                  data: (players) {
                                    return Column(
                                      children: [
                                        for (var i = 0; i < 3; i++) ...[
                                          Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Divider(height: 0),
                                              ),
                                              ListTile(
                                                onTap: () => navigateToPlayer(
                                                    players[i].uid),
                                                leading: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Stack(
                                                    children: [
                                                      players[i].profilePic !=
                                                              null
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                players[i]
                                                                    .profilePic!,
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
                                                                color: Colors
                                                                    .white,
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
                                                    Text(players[i].name),
                                                    Text(
                                                      '${players[i].stats.passesD[competitionName]}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(players[i].team),
                                              ),
                                            ],
                                          )
                                        ]
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) => ErrorPage(
                                    error: error.toString(),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                            const Divider(height: 0),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  'CARTONS JAUNES',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ref
                                .watch(
                                    getTopYellowCardProvider(competitionName))
                                .when(
                                  data: (players) {
                                    return Column(
                                      children: [
                                        for (var i = 0; i < 3; i++) ...[
                                          Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Divider(height: 0),
                                              ),
                                              ListTile(
                                                onTap: () => navigateToPlayer(
                                                    players[i].uid),
                                                leading: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Stack(
                                                    children: [
                                                      players[i].profilePic !=
                                                              null
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                players[i]
                                                                    .profilePic!,
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
                                                                color: Colors
                                                                    .white,
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
                                                    Text(players[i].name),
                                                    Text(
                                                      '${players[i].stats.yellowCards[competitionName]}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(players[i].team),
                                              ),
                                            ],
                                          )
                                        ]
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) => ErrorPage(
                                    error: error.toString(),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                            const Divider(height: 0),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  'CARDTONS ROUGES',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ref
                                .watch(getTopRedCardProvider(competitionName))
                                .when(
                                  data: (players) {
                                    return Column(
                                      children: [
                                        for (var i = 0; i < 3; i++) ...[
                                          Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Divider(height: 0),
                                              ),
                                              ListTile(
                                                onTap: () => navigateToPlayer(
                                                    players[i].uid),
                                                leading: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Stack(
                                                    children: [
                                                      players[i].profilePic !=
                                                              null
                                                          ? CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                players[i]
                                                                    .profilePic!,
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
                                                                color: Colors
                                                                    .white,
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
                                                    Text(players[i].name),
                                                    Text(
                                                      '${players[i].stats.redCards[competitionName]}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Text(players[i].team),
                                              ),
                                            ],
                                          )
                                        ]
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) => ErrorPage(
                                    error: error.toString(),
                                  ),
                                  loading: () => const SizedBox(),
                                ),
                            const Divider(height: 0),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Tout voir',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  if (page == 3) ...[
                    for (var team in allTeam)
                      ListTile(
                        onTap: () => navigateToTeam(team.name),
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(team.profilePic),
                          radius: 14,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(team.name),
                            IconButton(
                              onPressed: () => abonnementTeam(team),
                              icon: Icon(
                                team.followers.contains(uid)
                                    ? Icons.star_rate_rounded
                                    : Icons.star_border_rounded,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  List<TeamM> classer(List<TeamM> teams, String compet) {
    teams.sort(
        (a, b) => a.stats.points[compet].compareTo(b.stats.points[compet]));
    // teams.sort((a, b) {
    //   final diffA = a.stats.buts[compet] - a.stats.butsConcedes[compet];
    //   final diffB = b.stats.buts[compet] - b.stats.butsConcedes[compet];
    //   return diffA.compareTo(diffB);
    // });
    return teams.reversed.toList();
  }

  void addMatch(CompetitionM compet, String journee) {
    String uid = const Uuid().v1();
    TeamM? selectedTeam1;
    TeamM? selectedTeam2;
    TextEditingController stadeController = TextEditingController();
    final dateController = TextEditingController();
    DateTime datetime = DateTime.now();
    final timeController = TextEditingController();
    TimeOfDay time = const TimeOfDay(hour: 16, minute: 30);
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 165,
                  child: DropdownButtonFormField(
                    value: selectedTeam1 ?? allTeam1[0],
                    decoration: const InputDecoration(
                      prefix: Text('  '),
                      border: InputBorder.none,
                    ),
                    items: allTeam1
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedTeam1 = value!,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 165,
                  child: DropdownButtonFormField(
                    value: selectedTeam2 ?? allTeam1[1],
                    decoration: const InputDecoration(
                      prefix: Text('  '),
                      border: InputBorder.none,
                    ),
                    items: allTeam1
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedTeam2 = value!,
                  ),
                ),
              ],
            ),
          ),
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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 120,
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
                onPressed: () => _selectedDate(datetime, dateController),
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
                width: 120,
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
                onPressed: () => _selectedTime(time, timeController),
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
          ButtonBar(
            alignment: MainAxisAlignment.center,
            buttonPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 243, 93, 33),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  final t1 = selectedTeam1 ?? allTeam1[0];
                  final t2 = selectedTeam2 ?? allTeam1[1];
                  ref.watch(addMatchServiceProvider).addMatch(
                        context: context,
                        uid: uid,
                        stade: stadeController.text.trim(),
                        compet: compet,
                        team1: t1,
                        team2: t2,
                        date: DateTime.utc(datetime.year, datetime.month,
                            datetime.day, time.hour, time.minute),
                        journee: journee,
                      );
                  allTeam1.remove(t1);
                  allTeam1.remove(t2);
                  Navigator.pop(context);
                },
                child: const Text('Valider'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectedDate(DateTime datetime, TextEditingController dateController) {
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

  void _selectedTime(TimeOfDay time, TextEditingController timeController) {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        time = value!;
        timeController.text = time.format(context);
      });
    });
  }
}
