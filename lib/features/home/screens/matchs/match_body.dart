import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/common/match_card.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
import 'package:routemaster/routemaster.dart';

class MatchBody extends ConsumerWidget {
  const MatchBody({super.key});

  void navigateToCompet(BuildContext context, name) {
    Routemaster.of(context).push('/c/${name.split(' ').join('-')}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final date = ref.watch(dateProvider);
    return ref.watch(getUserCompetitionProvider).when(
          data: (compets) => ListView.separated(
            itemCount: compets.length,
            itemBuilder: (context, index) {
              final compet = compets[index];
              return ref.watch(getMatchsByCompetProvider(compet.name)).when(
                    data: (matchs) {
                      if (matchs.isEmpty) {
                        return const SizedBox();
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: GestureDetector(
                                            onTap: () => navigateToCompet(
                                                context, compet.name),
                                            child: Image.network(
                                              compet.profilePic,
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        compet.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(height: 0),
                                ),
                                SizedBox(
                                  height: matchs.length * 80,
                                  child: ListView.separated(
                                    itemCount: matchs.length,
                                    itemBuilder: (context, i) {
                                      final match = matchs[i];
                                      return SizedBox(
                                        height: 80,
                                        child: ListTile(
                                          onTap: () {
                                            Routemaster.of(context)
                                                .push('/match/${match.uid}');
                                          },
                                          title: MatchCard(match: match),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Divider(height: 0),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(height: 0),
                                ),
                                ListTile(
                                  onTap: () =>
                                      navigateToCompet(context, compet.name),
                                  title: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Voir classement ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Icon(
                                          Icons.navigate_next_outlined,
                                          color: Color.fromARGB(
                                              193, 158, 158, 158),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    error: (error, stackTrace) => ErrorPage(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(),
          ),
          error: (error, stackTrace) => ErrorPage(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
