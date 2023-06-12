import 'package:flutter/material.dart';
import 'package:footgal/features/admin/competition/add_competition_screen.dart';
import 'package:footgal/features/admin/match/add_compo_screen.dart';
import 'package:footgal/features/admin/match/add_match_screen.dart';
import 'package:footgal/features/admin/player/add_player_screen.dart';
import 'package:footgal/features/admin/team/add_team_screen.dart';
import 'package:footgal/features/auth/screen/auth_screen.dart';
import 'package:footgal/features/home/screens/home_screen.dart';
import 'package:footgal/features/match/match_screen.dart';
import 'package:footgal/features/view_profils/competition_profil.dart';
import 'package:footgal/features/view_profils/player_profil_screen.dart';
import 'package:footgal/features/view_profils/team_profil_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  },
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
    '/match/:uid': (route) => MaterialPage(
          child: MatchScreen(
            uid: route.pathParameters['uid']!,
          ),
        ),
    '/match/:uid/:n': (route) => MaterialPage(
          child: AddCompoScreen(
            uid: route.pathParameters['uid']!,
            n: int.parse(route.pathParameters['n']!),
          ),
        ),
    '/add-player': (_) => const MaterialPage(
          child: AddPlayerScreen(),
        ),
    '/add-team': (_) => const MaterialPage(
          child: AddTeamScreen(),
        ),
    '/add-match/:uid/:compet': (routeData) => MaterialPage(
          child: AddMatchScreen(
            uid: routeData.pathParameters['uid']!,
            compet: routeData.pathParameters['compet']!,
          ),
        ),
    '/add-competition': (_) => const MaterialPage(
          child: AddCompetitionScreen(),
        ),
    '/p/:uid': (routeData) => MaterialPage(
          child: PlayerProfileScreen(
            uid: routeData.pathParameters['uid']!,
          ),
        ),
    '/t/:name': (routeData) => MaterialPage(
          child: TeamProfileScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
    '/c/:name': (routeData) => MaterialPage(
          child: CompetitionProfileScreen(
            name: routeData.pathParameters['name']!,
          ),
        ),
  },
);

// class MyProvider extends StatelessWidget {
//   final String text;
//   const MyProvider({super.key, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return StreamProvider<Map<String, dynamic>>.value(
//       value: MatService().getTeamByName(text),
//       initialData: const {},
//       child: CircleAvatar(
//         radius: 20,
//         backgroundImage:
//             NetworkImage(Provider.of<Map<String, dynamic>>(context)['profil']),
//       ),
//     );
//   }
// }
