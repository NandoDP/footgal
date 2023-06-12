import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/models/match_model.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:badges/badges.dart' as badges;

class Formation extends ConsumerStatefulWidget {
  // VoidCallback changeFormation;
  final Map<String, dynamic> onze;
  final List<String> titusUid;
  final List<String> subsUid;
  final int minute;
  final MatchM match;
  final TeamM team1;
  final TeamM team2;
  bool isChanged;
  Formation({
    super.key,
    // required this.changeFormation,
    required this.onze,
    required this.titusUid,
    required this.subsUid,
    required this.minute,
    required this.match,
    required this.team1,
    required this.team2,
    required this.isChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FormationConsumerState();
}

class _FormationConsumerState extends ConsumerState<Formation> {
  final minuteController = TextEditingController();
  List<PlayerM> onzePlayers = [];
  PlayerM? passeur;

  void yellowRedCard(PlayerM player, String card, int minute) {
    int selectedTeam =
        widget.match.team1Composition.contains(player.uid) ? 0 : 1;
    ref.watch(matchServicesProvider.notifier).yellowRedCard(
          player: player,
          match: widget.match,
          card: card,
          minute: minute,
          indexTeam: selectedTeam,
        );
    showSnackBar(context, '$card Card !');
  }

  void goal(
      PlayerM scoreur, PlayerM passeur, TeamM team1, TeamM team2, int minute) {
    int selectedTeam =
        widget.match.team1Composition.contains(scoreur.uid) ? 0 : 1;
    ref.watch(matchServicesProvider.notifier).goal(
          player: scoreur,
          passeur: passeur,
          match: widget.match,
          team1: team1,
          team2: team2,
          minute: minute,
          indexTeam: selectedTeam,
        );
    showSnackBar(context, 'Goal goal goal !');
  }

  void navigateToPlayer(String uid) {
    Routemaster.of(context).push('/p/$uid');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isAdmin = user.isAdmin;
    final onze = widget.onze;
    int j = 11;
    List<String> yellowCards = widget.match.yellowCards.keys.toList();
    List<String> redCards = widget.match.redCards.keys.toList();
    List<String> scoreurs =
        widget.match.scoreurs.keys.map((e) => e.split('|')[0]).toList();
    List<String> changements =
        widget.match.changements.keys.map((e) => e.split('|')[0]).toList();
    return ref.watch(getPlayersMatchProvider(widget.titusUid)).when(
          data: (players) {
            onzePlayers = players;

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var e in onze.keys.toList().reversed)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var i = 0; i < onze[e].length; i++, j--,)
                        Builder(builder: (context) {
                          final player = players[onzePlayers.indexWhere(
                            (element) => element.uid == onze[e][i].toString(),
                          )];
                          return Column(
                            children: [
                              scoreurs.contains(player.uid)
                                  ? badges.Badge(
                                      position: badges.BadgePosition.topEnd(
                                        top: -6.5,
                                        end: -6.5,
                                      ),
                                      badgeStyle: const badges.BadgeStyle(
                                        badgeColor: Colors.white,
                                        padding: EdgeInsets.all(0),
                                      ),
                                      badgeContent: const Icon(
                                        Icons.sports_soccer_rounded,
                                        size: 15,
                                      ),
                                      child: playerW(
                                        player,
                                        isAdmin,
                                        yellowCards.contains(player.uid),
                                        redCards.contains(player.uid),
                                        changements.contains(player.uid),
                                      ),
                                    )
                                  : playerW(
                                      player,
                                      isAdmin,
                                      yellowCards.contains(player.uid),
                                      redCards.contains(player.uid),
                                      changements.contains(player.uid),
                                    ),
                              Row(
                                children: [
                                  Text(
                                    '${player.numero} ',
                                    style: const TextStyle(
                                      color: Color.fromARGB(131, 255, 255, 255),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      player.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
                    ],
                  )
              ],
            );
          },
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  Widget playerW(PlayerM player, bool isAdmin, bool yellowCard, bool redCard,
      bool changement) {
    return SizedBox(
      child: Stack(
        children: [
          isAdmin
              ? CircleAvatar(
                  backgroundColor:
                      player.profilePic != null ? null : Colors.black,
                  backgroundImage: player.profilePic != null
                      ? NetworkImage(player.profilePic!)
                      : null,
                  radius: 21,
                  child: buildPopUpMenu(
                    player,
                    onzePlayers,
                    const Icon(
                      Icons.person_2_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    showSnackBar(context, 'text');
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        player.profilePic != null ? null : Colors.black,
                    backgroundImage: player.profilePic != null
                        ? NetworkImage(player.profilePic!)
                        : null,
                    radius: 21,
                    child: player.profilePic != null
                        ? null
                        : const Icon(
                            Icons.person_outline_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
          if (yellowCard)
            const Padding(
              padding: EdgeInsets.only(top: 15, right: 15),
              child: CircleAvatar(
                radius: 7,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.square_rounded,
                  color: Colors.yellow,
                  size: 12,
                ),
              ),
            ),
          if (redCard)
            const Padding(
              padding: EdgeInsets.only(top: 15, right: 15),
              child: CircleAvatar(
                radius: 7,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.square_rounded,
                  color: Colors.red,
                  size: 12,
                ),
              ),
            ),
          if (changement)
            const CircleAvatar(
              radius: 7,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.swap_horizontal_circle_sharp,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPopUpMenu(PlayerM player, List<PlayerM> players, Widget child) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addEvent(player, players);
            },
            child: const Text('Action'),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              // showSnackBar(context, player.uid);
              navigateToPlayer(player.uid);
            },
            child: const Text('Consulter'),
          ),
        ),
        PopupMenuItem(
          child: PopupMenuButton(
            itemBuilder: (context) =>
                ref.watch(getPlayersMatchProvider(widget.subsUid)).when(
                      data: (players) => [
                        for (var i in players)
                          PopupMenuItem(
                            child: GestureDetector(
                              onTap: () {
                                ref
                                    .watch(matchServicesProvider.notifier)
                                    .changement(
                                      player1: player,
                                      player2: i,
                                      match: widget.match,
                                      minute: widget.minute,
                                    );
                                showSnackBar(context, 'Changement effectuer');
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text(i.name),
                            ),
                          )
                      ],
                      error: (error, stackTrace) => [
                        const PopupMenuItem(
                          child: Text('Erreur !'),
                        ),
                      ],
                      loading: () => [
                        const PopupMenuItem(
                          child: Loader(),
                        ),
                      ],
                    ),
            child: const Text('Remplacer'),
          ),
        ),
      ],
      child: player.profilePic != null
          ? const Icon(
              Icons.add,
              color: Color.fromARGB(0, 255, 255, 255),
            )
          : child,
    );
  }

  void addEvent(PlayerM player, List<PlayerM> players) {
    String event = 'But';
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField(
              value: event,
              items: ['But', 'Carton Jaune', 'Carton Rouge']
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onChanged: (value) => event = value!,
            ),
          ),
          if (event == 'But')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text('Passeur :'),
                  const SizedBox(width: 10),
                  passeur == null
                      ? SizedBox(
                          width: 90,
                          child: PopupMenuButton(
                            onSelected: (value) => passeur = value,
                            child: const Icon(Icons.question_mark),
                            itemBuilder: (context) => [
                              for (var player in players)
                                PopupMenuItem(
                                  value: player,
                                  child: Text(player.name),
                                ),
                            ],
                          ),
                        )
                      : Text(passeur!.name),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: minuteController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'minute',
                prefix: Text('  '),
                //   border: InputBorder.none,
              ),
              maxLength: 3,
            ),
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
                  if (event == 'Carton Jaune') {
                    yellowRedCard(
                      player,
                      'Yellow',
                      int.parse(minuteController.text.trim()),
                    );
                  } else if (event == 'Carton Rouge') {
                    yellowRedCard(
                      player,
                      'Red',
                      int.parse(minuteController.text.trim()),
                    );
                  } else {
                    bool inTeam1 = widget.team1.players.contains(player.uid);
                    goal(
                      player,
                      passeur!,
                      inTeam1 ? widget.team1 : widget.team2,
                      inTeam1 ? widget.team2 : widget.team1,
                      int.parse(minuteController.text.trim()),
                    );
                  }
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
}
