import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/player/add_player_service.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
// import 'package:footgal/features/admin/competition/add_competition_service.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/features/view_profils/profils_services.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TeamProfileScreen extends ConsumerStatefulWidget {
  final String name;
  const TeamProfileScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TeamProfileScreenConsumerState();
}

class _TeamProfileScreenConsumerState extends ConsumerState<TeamProfileScreen> {
  int page = 0;
  String? selectedCompet;
  List<MatchM> allMatchs = [];
  List<List<PlayerM>> players = [[], [], [], []];

  void changeView(int index) {
    setState(() {
      page = index;
    });
  }

  void navigateToPlayer(String uid) {
    Routemaster.of(context).push('/p/$uid');
  }

  void navigateToCompet(String name) {
    Routemaster.of(context).push('/c/${name.split(' ').join('-')}');
  }

  void abonnementTeam(TeamM team) {
    ref.watch(profilsServicesProvider.notifier).abonnementTeam(team);
    showSnackBar(context, 'Vous etes abonner a ${team.name}');
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userProvider)!.uid;
    final teamName = widget.name.split('-').join(' ');
    return ref.watch(getTeamProvider(teamName)).when(
          data: (team) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: null,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(240),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
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
                                      NetworkImage(team.profilePic),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  team.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  team.pays,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width - 145,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.notifications_active_rounded,
                                    size: 24,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_rounded,
                                    size: 24,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => abonnementTeam(team),
                                  icon: Icon(
                                    team.followers.contains(uid)
                                        ? Icons.star_rate_rounded
                                        : Icons.star_border_rounded,
                                    size: 24,
                                  ),
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
                                    'Apercu',
                                    style: TextStyle(
                                      color: page == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
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
                                    'Saison',
                                    style: TextStyle(
                                      color: page == 1
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
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
                                    'Effectif',
                                    style: TextStyle(
                                      color: page == 2
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
                  if (page == 1) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 1,
                        child: DropdownButtonFormField(
                          value: selectedCompet ?? team.competition[1],
                          decoration: const InputDecoration(
                            prefix: Text('  '),
                            border: InputBorder.none,
                          ),
                          items: team.competition
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCompet = val;
                            });
                          },
                        ),
                      ),
                    ),
                    if (selectedCompet != null
                        ? selectedCompet == 'Ligue 1'
                        : team.competition[1] == 'Ligue 1')
                      Column(
                        children: [
                          // CLASSEMENT
                          Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'CLASSEMENT',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            Text(
                                              'J',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                              'Buts',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                              'Diff.',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            Text(
                                              'Pts.',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
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
                                        teams = classer(teams, 'Ligue 1');
                                        int j = teams
                                            .map((e) => e.name)
                                            .toList()
                                            .indexOf(teamName);

                                        if (j == 0) {
                                          j++;
                                          teams = teams
                                              .toList()
                                              .getRange(0, 3)
                                              .toList();
                                        } else if (j == teams.length - 1) {
                                          j--;
                                          teams = teams
                                              .toList()
                                              .getRange(j - 1, j + 2)
                                              .toList();
                                        } else {
                                          teams = teams
                                              .toList()
                                              .getRange(j - 1, j + 2)
                                              .toList();
                                        }
                                        return Column(
                                          children: [
                                            for (var i = 0;
                                                i < teams.length;
                                                i++)
                                              ListTile(
                                                onTap: () {
                                                  Routemaster.of(context).push(
                                                      '/t/${teams[i].name.split(' ').join('-')}');
                                                },
                                                // leading: Text('${j + i}'),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('${j + i}'),
                                                        const SizedBox(
                                                            width: 10),
                                                        const Icon(
                                                          Icons.circle_outlined,
                                                          size: 8,
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
                                                          backgroundImage:
                                                              NetworkImage(teams[
                                                                      i]
                                                                  .profilePic),
                                                          radius: 14,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          teams[i].name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                teams[i].name ==
                                                                        teamName
                                                                    ? FontWeight
                                                                        .w500
                                                                    : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 120,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            '${teams[i].stats.matchs['Ligue 1']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            '${teams[i].stats.buts['Ligue 1']}:${teams[i].stats.butsConcedes['Ligue 1']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            '${teams[i].stats.buts['Ligue 1'] - teams[i].stats.butsConcedes['Ligue 1']}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            '${teams[i].stats.points['Ligue 1']}',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                      error: (error, stackTrace) => ErrorPage(
                                        error: error.toString(),
                                      ),
                                      loading: () => const Loader(),
                                    ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(height: 0),
                                ),
                                ListTile(
                                  onTap: () => navigateToCompet('Ligue 1'),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Tout voir',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // MATCHS
                          Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    'MATCHS',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(height: 0),
                                ),
                                SizedBox(
                                  height: 90,
                                  child: ref
                                      .watch(getMatchsByTeamProvider(teamName))
                                      .when(
                                        data: (matchs) {
                                          allMatchs = matchs;
                                          return Row(
                                            children: [
                                              for (var i = 0;
                                                  i < matchs.length && i < 5;
                                                  i++)
                                                ref
                                                    .watch(getTeamProvider(
                                                        teamName ==
                                                                matchs[i]
                                                                    .team1Name
                                                            ? matchs[i]
                                                                .team2Name
                                                            : matchs[i]
                                                                .team1Name))
                                                    .when(
                                                      data: (data) =>
                                                          GestureDetector(
                                                        onTap: () => Routemaster
                                                                .of(context)
                                                            .push(
                                                                '/match/${matchs[i].uid}'),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      30,
                                                                  vertical: 8),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                '${matchs[i].date.day}/${matchs[i].date.month}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Image.network(
                                                                data.profilePic,
                                                                width: 25,
                                                                height: 25,
                                                              ),
                                                              Text(
                                                                  '${matchs[i].statsMatch.buts[0]} : ${matchs[i].statsMatch.buts[1]}')
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      error:
                                                          (error, stackTrace) =>
                                                              ErrorPage(
                                                        error: error.toString(),
                                                      ),
                                                      loading: () =>
                                                          const Loader(),
                                                    ),
                                            ],
                                          );
                                        },
                                        error: (error, stackTrace) => ErrorPage(
                                          error: error.toString(),
                                        ),
                                        loading: () => const Loader(),
                                      ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(height: 0),
                                ),
                                ListTile(
                                  onTap: () {},
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        'Tout voir',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    // TOP STATS
                    Card(
                      elevation: 1,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'TOP STATS',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(height: 0),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Buts',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              team.stats.matchs['Ligue 1'] != 0
                                                  ? '${team.stats.buts['Ligue 1'] / team.stats.matchs['Ligue 1']}'
                                                  : '0.0',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(thickness: 2),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Buts condeces',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              team.stats.matchs['Ligue 1'] != 0
                                                  ? '${team.stats.butsConcedes['Ligue 1'] / team.stats.matchs['Ligue 1']}'
                                                  : '0.0',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  130) /
                                              2,
                                      child: const Divider(
                                        height: 0,
                                        thickness: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      child: CircularPercentIndicator(
                                        radius: 40,
                                        percent: 0.75,
                                        backgroundColor: const Color.fromARGB(
                                            36, 158, 158, 158),
                                        progressColor: Colors.black,
                                        center: SizedBox(
                                          height: 35,
                                          width: 50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                      '${team.stats.victoirs['Ligue 1']}'),
                                                  const Text('V'),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                      '${team.stats.nulls['Ligue 1']}'),
                                                  const Text(
                                                    'N',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                      '${team.stats.defaites['Ligue 1']}'),
                                                  const Text(
                                                    'D',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          65, 158, 158, 158),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  130) /
                                              2,
                                      child: const Divider(
                                        height: 0,
                                        thickness: 2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              team.stats.matchs['Ligue 1']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Text(
                                              'Matchs',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const VerticalDivider(thickness: 2),
                                      SizedBox(
                                        width: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              team.stats.points['Ligue 1']
                                                  .toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Text(
                                              'Points',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                          ListTile(
                            onTap: () {},
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Tout voir',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                  if (page == 2) ...[
                    ref.watch(getPlayersMatchProvider(team.players)).when(
                          data: (data) {
                            for (var element in data) {
                              if (element.position == 'Gardien' &&
                                  !players[0].contains(element)) {
                                players[0].add(element);
                              }
                              if (element.position == 'Defenseur' &&
                                  !players[1].contains(element)) {
                                players[1].add(element);
                              }
                              if (element.position == 'Milieu' &&
                                  !players[2].contains(element)) {
                                players[2].add(element);
                              }
                              if (element.position == 'Attaquant' &&
                                  !players[3].contains(element)) {
                                players[3].add(element);
                              }
                            }
                            return Column(
                              children: [
                                Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          'GARDIEN',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(height: 0),
                                      ),
                                      for (var gardien in players[0]) ...[
                                        ListTile(
                                          onTap: () =>
                                              navigateToPlayer(gardien.uid),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                gardien.profilePic != null
                                                    ? NetworkImage(
                                                        gardien.profilePic!)
                                                    : null,
                                            child: gardien.profilePic == null
                                                ? const Icon(
                                                    Icons.person_2_rounded)
                                                : null,
                                          ),
                                          title: Text(gardien.name),
                                          subtitle: Text(gardien.pays),
                                        ),
                                        if (gardien != players[0].last)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                              height: 0,
                                              thickness: 2,
                                            ),
                                          ),
                                      ]
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          'DESENSEUR',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(height: 0),
                                      ),
                                      for (var defenseur in players[1]) ...[
                                        ListTile(
                                          onTap: () =>
                                              navigateToPlayer(defenseur.uid),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                defenseur.profilePic != null
                                                    ? NetworkImage(
                                                        defenseur.profilePic!)
                                                    : null,
                                            child: defenseur.profilePic == null
                                                ? const Icon(
                                                    Icons.person_2_rounded)
                                                : null,
                                          ),
                                          title: Text(defenseur.name),
                                          subtitle: Text(defenseur.pays),
                                        ),
                                        if (defenseur != players[1].last)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                              height: 0,
                                              thickness: 2,
                                            ),
                                          ),
                                      ]
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          'MILIEU',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(height: 0),
                                      ),
                                      for (var milieu in players[2]) ...[
                                        ListTile(
                                          onTap: () =>
                                              navigateToPlayer(milieu.uid),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                milieu.profilePic != null
                                                    ? NetworkImage(
                                                        milieu.profilePic!)
                                                    : null,
                                            child: milieu.profilePic == null
                                                ? const Icon(
                                                    Icons.person_2_rounded)
                                                : null,
                                          ),
                                          title: Text(milieu.name),
                                          subtitle: Text(milieu.pays),
                                        ),
                                        if (milieu != players[2].last)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                              height: 0,
                                              thickness: 2,
                                            ),
                                          ),
                                      ],
                                    ],
                                  ),
                                ),
                                Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
                                          'ATTAQUANT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(height: 0),
                                      ),
                                      for (var attaquant in players[3]) ...[
                                        ListTile(
                                          onTap: () =>
                                              navigateToPlayer(attaquant.uid),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.black,
                                            backgroundImage:
                                                attaquant.profilePic != null
                                                    ? NetworkImage(
                                                        attaquant.profilePic!)
                                                    : null,
                                            child: attaquant.profilePic == null
                                                ? const Icon(
                                                    Icons.person_2_rounded)
                                                : null,
                                          ),
                                          title: Text(attaquant.name),
                                          subtitle: Text(attaquant.pays),
                                        ),
                                        if (attaquant != players[3].last)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                              height: 0,
                                              thickness: 2,
                                            ),
                                          ),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          error: (error, stackTrace) => ErrorPage(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
                  ]
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
    return teams.reversed.toList();
  }
}
