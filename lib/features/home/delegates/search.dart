import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SearchAllDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchAllDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox();
  }

  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SearchCommunityDelegate extends SearchDelegate {
//   final WidgetRef ref;
//   SearchCommunityDelegate(this.ref);

//   // var searchAPost = false;
//   // var searchAUser = false;
//   // var searchACommunity = true;

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//         },
//         icon: const Icon(Icons.close),
//       ),
//       // PopupMenuButton(
//       //   onSelected: (value) {
//       //     searchACommunity = 0 == value;
//       //     searchAPost = 1 == value;
//       //     searchAUser = 2 == value;
//       //   },
//       //   itemBuilder: (context) => [
//       //     const PopupMenuItem(
//       //       value: 0,
//       //       child: Text('Communauté'),
//       //     ),
//       //     const PopupMenuItem(
//       //       value: 1,
//       //       child: Text('Poste'),
//       //     ),
//       //     const PopupMenuItem(
//       //       value: 2,
//       //       child: Text('Utilisateur'),
//       //     ),
//       //   ],
//       // ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return null;
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return const SizedBox();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return const SizedBox();
//     // if (searchACommunity) {
//     //   return ref.watch(searchCommunityProvider(query)).when(
//     //         data: (communities) => ListView.builder(
//     //           itemCount: communities.length,
//     //           itemBuilder: (BuildContext context, int index) {
//     //             final community = communities[index];
//     //             return ListTile(
//     //               leading: CircleAvatar(
//     //                 backgroundImage: NetworkImage(community.avatar),
//     //               ),
//     //               title: Text('c/${community.name}'),
//     //               onTap: () => navigateToCommunity(context, community.name),
//     //             );
//     //           },
//     //         ),
//     //         error: (error, stackTrace) => ErrorText(error: error.toString()),
//     //         loading: () => const Loader(),
//     //       );
//     // } else if (searchAUser) {
//     //   return ref.watch(searchUserProvider(query)).when(
//     //         data: (users) => ListView.builder(
//     //           itemCount: users.length,
//     //           itemBuilder: (BuildContext context, int index) {
//     //             final user = users[index];
//     //             return ListTile(
//     //               leading: CircleAvatar(
//     //                 backgroundImage: NetworkImage(user.profilePic),
//     //               ),
//     //               title: Text('u/${user.name}'),
//     //               onTap: () => navigateToUserProfile(context, user.uid),
//     //             );
//     //           },
//     //         ),
//     //         error: (error, stackTrace) => ErrorText(error: error.toString()),
//     //         loading: () => const Loader(),
//     //       );
//     // } else {
//     //   return ref.watch(searchPostProvider(query)).when(
//     //         data: (users) => ListView.builder(
//     //           itemCount: users.length,
//     //           itemBuilder: (BuildContext context, int index) {
//     //             final user = users[index];
//     //             return PostCard(poste: user);
//     //           },
//     //         ),
//     //         error: (error, stackTrace) => ErrorText(error: error.toString()),
//     //         loading: () => const Loader(),
//     //       );
//     // }
//   }

//   // void navigateToCommunity(BuildContext context, String communityName) {
//   //   Routemaster.of(context).push('/r/$communityName');
//   // }

//   // void navigateToUserProfile(BuildContext context, String uid) {
//   //   Routemaster.of(context).push('/u/$uid');
//   // }
// }
