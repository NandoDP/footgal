// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';

import 'package:footgal/models/match_model.dart';
// import 'package:routemaster/routemaster.dart';

class MatchCard extends ConsumerWidget {
  final MatchM match;
  const MatchCard({
    Key? key,
    required this.match,
  }) : super(key: key);

  // void navigateToMatchScreen(BuildContext context) {
  //   Routemaster.of(context).push('/match/${match.uid}');
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ref.watch(getTeamProvider(match.team1Name)).when(
                          data: (data) {
                            return CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(data.profilePic),
                              radius: 12,
                            );
                          },
                          error: (error, stackTrace) => ErrorPage(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
                    const SizedBox(width: 10),
                    Text(match.team1Name),
                  ],
                ),
                const SizedBox(height: 10),
                Row(children: [
                  ref.watch(getTeamProvider(match.team2Name)).when(
                        data: (data) {
                          return CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(data.profilePic),
                            radius: 12,
                          );
                        },
                        error: (error, stackTrace) => ErrorPage(
                          error: error.toString(),
                        ),
                        loading: () => const Loader(),
                      ),
                  const SizedBox(width: 10),
                  Text(match.team2Name),
                ]),
              ],
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: VerticalDivider(),
              ),
              SizedBox(
                width: 100,
                child: Center(
                  child: Text(
                      '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
