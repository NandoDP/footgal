import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/screens/accueil/accueil_service.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:footgal/models/articles.dart';
import 'package:footgal/models/match_model.dart';
// import 'package:footgal/models/team_model.dart';
import 'package:routemaster/routemaster.dart';

class AccueilBody extends ConsumerWidget {
  AccueilBody({super.key});
  int? timeH, timeM, timeS;
  // TeamM team;

  void navigateToMatchScreen(BuildContext context, MatchM match) {
    Routemaster.of(context).push('/match/${match.uid}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          height: 100,
          child: ref.watch(getSomeMatchs).when(
                data: (matchs) => ListView(
                  scrollDirection: Axis.horizontal,
                  children: matchs
                      .map(
                        (match) => Container(
                          width: 120,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () => navigateToMatchScreen(context, match),
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Image.network(
                                          match.team1Pic,
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Image.network(
                                          match.team2Pic,
                                          width: 35,
                                          height: 35,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    match.date
                                                .difference(DateTime.now())
                                                .inDays
                                                .abs() <
                                            1
                                        ? "Aujourd'hui"
                                        : '${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ),
        if (user.yourTeam != '')
          ref.watch(getTeamProvider(user.yourTeam)).when(
                data: (team) => Column(
                  children: [
                    if (team.matchs.isNotEmpty)
                      ref.watch(getMatchProvider(team.matchs.last)).when(
                            data: (match) {
                              final time =
                                  DateTime.now().difference(match.date);
                              int minuteJouer = 0;
                              if (match.statue == 1) {
                                minuteJouer = DateTime.now()
                                    .difference(match.start1Mt!)
                                    .inMinutes
                                    .abs();
                              } else if (match.statue == 3) {
                                minuteJouer = DateTime.now()
                                        .difference(match.start2Mt!)
                                        .inMinutes
                                        .abs() +
                                    45;
                              }
                              if (time.isNegative) {
                                timeH = time.inHours;
                                timeM = time.inMinutes - timeH! * 60;
                                timeS = time.inSeconds -
                                    timeM! * 60 -
                                    timeH! * 60 * 60;
                              }
                              if (match.date
                                      .difference(DateTime.now())
                                      .abs()
                                      .inHours <
                                  24) {
                                return const SizedBox();
                              } else {
                                return Card(
                                  elevation: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Ton équipe",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Container(
                                          width: double.infinity,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  78, 158, 158, 158),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () => navigateToMatchScreen(
                                                context, match),
                                            title: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    match.competition,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Image.network(
                                                              match.team1Pic,
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                            Text(match
                                                                .team1Name),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            if (match.statue ==
                                                                0) ...[
                                                              time.isNegative
                                                                  ? Text(
                                                                      '${timeH!.abs().toString().padLeft(2, '0')}:${timeM!.abs().toString().padLeft(2, '0')}:${timeS!.abs().toString().padLeft(2, '0')}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      match.date.difference(DateTime.now()).inDays.abs() <
                                                                              1
                                                                          ? "Aujourd'hui"
                                                                          : '${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year.toString().padLeft(2, '0')}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                              Text(
                                                                '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}',
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ],
                                                            if (match.statue !=
                                                                0)
                                                              Text(
                                                                '${match.statsMatch.buts[0]} : ${match.statsMatch.buts[1]}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            if (match.statue ==
                                                                1)
                                                              Text(
                                                                minuteJouer < 46
                                                                    ? "$minuteJouer'"
                                                                    : "45+${minuteJouer - 45}'",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            if (match.statue ==
                                                                2)
                                                              const Text(
                                                                'Mi-temps',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .redAccent),
                                                              ),
                                                            if (match.statue ==
                                                                3)
                                                              Text(
                                                                minuteJouer < 91
                                                                    ? "$minuteJouer'"
                                                                    : "90+${minuteJouer - 90}'",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .redAccent,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            if (match.statue ==
                                                                4)
                                                              const Text(
                                                                'TERMINE',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        Column(
                                                          children: [
                                                            Image.network(
                                                              match.team2Pic,
                                                              width: 35,
                                                              height: 35,
                                                            ),
                                                            Text(match
                                                                .team2Name),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            error: (error, stackTrace) => ErrorPage(
                              error: error.toString(),
                            ),
                            loading: () => const Loader(),
                          ),
                    listArticles(
                      context,
                      team.name,
                      team.profilePic,
                      'tu suis cette équipe',
                      [
                        Article(
                          uid: 'uid1',
                          title: 'title 1',
                          content: 'content 1',
                          date: DateTime(2023, 6, 9, 10),
                        ),
                        Article(
                          uid: 'uid2',
                          title:
                              'title 2 : Another exception was thrown: Incorrect use of ParentDataWidget.',
                          content: 'content 2',
                          date: DateTime(2023, 6, 9, 7),
                        )
                      ],
                    )
                  ],
                ),
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              )
      ],
    );
  }

  Widget listArticles(BuildContext context, String theme, String profilPic,
      String sousTheme, List<Article> articles) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  profilPic,
                  width: 35,
                  height: 35,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      sousTheme,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 0),
            ),
            ListTile(
              onTap: () {},
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color.fromARGB(78, 158, 158, 158),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      articles[0].title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Il y a ${DateTime.now().difference(articles[0].date).inHours} heures',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(height: 0),
            ),
            for (var i = 1; i < 5 && i < articles.length; i++) ...[
              ListTile(
                onTap: () {},
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            child: Text(
                              articles[i].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: const Color.fromARGB(78, 158, 158, 158),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Il y a ${DateTime.now().difference(articles[i].date).inHours} heures',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(height: 0),
              ),
            ],
            // const Divider(height: 0),
            ListTile(
              onTap: () {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'En voir plus',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
