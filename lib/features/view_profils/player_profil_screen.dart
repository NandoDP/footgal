import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/constant/constants.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/features/view_profils/profils_services.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:footgal/router.dart';

class PlayerProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const PlayerProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlayerProfileScreenConsumerState();
}

class _PlayerProfileScreenConsumerState
    extends ConsumerState<PlayerProfileScreen> {
  int page = 0;
  String? teamProfilPic;
  List<String> listCompet = [];

  void changeView(int index) {
    setState(() {
      page = index;
    });
  }

  void abonnementPlayer(PlayerM player) {
    ref.watch(profilsServicesProvider.notifier).abonnementPlayer(player);
    showSnackBar(context, 'Vous etes abonner a ${player.name}');
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(userProvider)!.uid;
    return ref.watch(getPlayerProvider(widget.uid)).when(
          data: (player) {
            final names = player.name.split(' ');
            final teamNames = player.team.split(' ');
            final lastName = names.last;
            final teamLastName = teamNames.last;
            names.remove(lastName);
            teamNames.remove(teamLastName);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: null,
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(300),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.grey,
                                    Colors.black,
                                  ],
                                ),
                              ),
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
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 40,
                              bottom: 130,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  names.join(' '),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  lastName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 70,
                            margin: const EdgeInsets.only(top: 100),
                            color: const Color.fromARGB(161, 33, 149, 243),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  ref.watch(getTeamProvider(player.team)).when(
                                        data: (team) {
                                          teamProfilPic = team.profilePic;
                                          listCompet = team.competition;
                                          return CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(team.profilePic),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    161, 33, 149, 243),
                                            radius: 20,
                                          );
                                        },
                                        error: (error, stackTrace) => ErrorPage(
                                          error: error.toString(),
                                        ),
                                        loading: () => const Loader(),
                                      ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (teamNames.isNotEmpty)
                                        Text(
                                          teamNames.join(' '),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      Text(
                                        teamLastName,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(
                                left: 20, top: 185, bottom: 15),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => abonnementPlayer(player),
                                  icon: Icon(
                                    player.followers.contains(uid)
                                        ? Icons.star_rate_rounded
                                        : Icons.star_border_rounded,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${player.followers.length}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          player.profilePic != null
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  margin:
                                      const EdgeInsets.only(top: 50, right: 20),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      player.profilePic!,
                                    ),
                                    radius: 70,
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.centerRight,
                                  margin:
                                      const EdgeInsets.only(top: 50, right: 20),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 70,
                                  ),
                                ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
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
                                    'Carrière',
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
                      )
                    ],
                  ),
                ),
              ),
              body: ListView(
                children: [
                  if (page == 0) ...[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 5,
                        child: Wrap(
                          children: [
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Age',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${(DateTime.now().difference(player.naissance).inDays / 365).floor()} ans',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Pays',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    player.pays,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Position',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    player.position,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2 - 25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Numéro',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '${player.numero}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'EQUIPES',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(height: 0),
                          ),
                          ListTile(
                            onTap: () {},
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(teamProfilPic!),
                              backgroundColor: Colors.white,
                              radius: 20,
                            ),
                            title: Text(player.team),
                          ),
                          ListTile(
                            onTap: () {},
                            leading: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              // backgroundImage: NetworkImage(teamProfilPic!),
                              radius: 20,
                            ),
                            title: Text(player.pays),
                          )
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'MATCH A VENIR',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Divider(height: 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (page == 1) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                'MATCH A VENIR',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(height: 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Competitions'),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                        child: Image.asset(
                                          Constants.footballIconPath,
                                          height: 30,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                        child:
                                            Icon(Icons.sports_soccer_rounded),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                        child: Icon(
                                          Icons.square,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                        child: Icon(
                                          Icons.square,
                                          color: Colors.red,
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   width: 30,
                                      //   child: Icon(
                                      //     Icons.shoes,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            for (var compet in listCompet)
                              Padding(
                                padding: const EdgeInsets.all(15.0)
                                    .copyWith(right: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(compet),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                              '${player.stats.matchs[compet]}'),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                              '${player.stats.buts[compet]}'),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                              '${player.stats.yellowCards[compet]}'),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: Text(
                                              '${player.stats.redCards[compet]}'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
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
}
