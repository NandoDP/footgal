import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/common/select_date_button.dart';
import 'package:footgal/core/constant/constants.dart';
import 'package:footgal/core/provider/date_provider.dart';
import 'package:footgal/features/auth/controller/auth_controller.dart';
import 'package:footgal/features/home/delegates/search.dart';
import 'package:footgal/features/home/screens/matchs/match_services.dart';
// import 'package:footgal/my_flutter_app_icons.dart';
import 'package:routemaster/routemaster.dart';
// import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _page = 0;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 250));
    final curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = Tween<double>(begin: 0, end: 1).animate(curve);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigateToTeam(String team) {
    Routemaster.of(context).push('/t/${team.split(' ').join('-')}');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentDate = ref.watch(dateProvider.notifier);
    final date = ref.watch(dateProvider);
    final avantDer =
        DateTime.now().add(const Duration(days: -14)).difference(date).inDays ==
            0;
    final der =
        DateTime.now().add(const Duration(days: -7)).difference(date).inDays ==
            0;
    final cette = DateTime.now().difference(date).inDays == 0;
    final proch =
        DateTime.now().add(const Duration(days: 7)).difference(date).inDays ==
            0;
    return Scaffold(
      appBar: _page == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              title: const Text(
                'FOOTGAL',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchAllDelegate(ref),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                ref.watch(getTeamProvider(user.yourTeam)).when(
                      data: (team) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => navigateToTeam(team.name),
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(146, 158, 158, 158),
                            radius: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                ),
                              ),
                              child: badges.Badge(
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: Colors.white,
                                  padding: EdgeInsets.all(1),
                                ),
                                position: badges.BadgePosition.topEnd(
                                    top: -10, end: -7),
                                badgeContent: const Text(
                                  "❤",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 10,
                                  backgroundImage:
                                      NetworkImage(team.profilePic),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      error: (error, stackTrace) => ErrorPage(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    )
              ],
            )
          : _page == 1
              ? AppBar(
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(40),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SelectDateButton(
                            onTap: currentDate.avantDerSem,
                            text: 'Sem X aaa - Y bbb',
                            color: avantDer
                                ? Colors.black
                                : const Color.fromARGB(255, 196, 195, 195),
                          ),
                          const SizedBox(width: 8),
                          SelectDateButton(
                            onTap: currentDate.semDer,
                            text: "Semaine der",
                            color: der
                                ? Colors.black
                                : const Color.fromARGB(255, 196, 195, 195),
                          ),
                          const SizedBox(width: 8),
                          SelectDateButton(
                            onTap: currentDate.cetteSem,
                            text: 'Cette semaine',
                            color: cette
                                ? Colors.black
                                : const Color.fromARGB(255, 196, 195, 195),
                          ),
                          const SizedBox(width: 8),
                          SelectDateButton(
                            onTap: currentDate.semProc,
                            text: 'Semaine proch',
                            color: proch
                                ? Colors.black
                                : const Color.fromARGB(255, 196, 195, 195),
                          ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 1,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                    )
                  ],
                  title: const Text(
                    'Matchs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
      // _page == 2
      //     ? AppBar(
      //         backgroundColor: Colors.white,
      //         elevation: 1,
      //         title: const TextField(
      //           decoration: InputDecoration(
      //             prefixIcon: Icon(
      //               Icons.search,
      //               color: Colors.black,
      //             ),
      //             filled: true,
      //             hintText: 'Recherche',
      //             border: InputBorder.none,
      //           ),
      //         ),
      //       )
      //     : null,
      body: Constants.tabWidgets[_page],
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      floatingActionButton: user.isAdmin
          ? FloatingActionBubble(
              items: <Bubble>[
                Bubble(
                  title: "Joueur",
                  iconColor: Colors.white,
                  bubbleColor: Colors.black,
                  icon: Icons.storage,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Routemaster.of(context).push('/add-player');
                  },
                ),
                Bubble(
                  title: "Equipe",
                  iconColor: Colors.white,
                  bubbleColor: Colors.black,
                  icon: Icons.bed,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Routemaster.of(context).push('/add-team');
                  },
                ),
                Bubble(
                  title: "Match",
                  iconColor: Colors.white,
                  bubbleColor: Colors.black,
                  icon: Icons.bed,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    // Routemaster.of(context).push('/add-match');
                  },
                ),
                Bubble(
                  title: "Competition",
                  iconColor: Colors.white,
                  bubbleColor: Colors.black,
                  icon: Icons.bed,
                  titleStyle:
                      const TextStyle(fontSize: 16, color: Colors.white),
                  onPress: () {
                    Routemaster.of(context).push('/add-competition');
                  },
                ),
              ],
              animation: _animation,
              onPress: () => _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),
              iconColor: Colors.black,
              iconData: Icons.add,
              backGroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            // icon: Icon(MyFlutterApp.stade),
            icon: Image.asset(
              Constants.footballIconPath,
              color: _page == 1 ? null : Colors.grey,
            ),
            label: 'Matchs',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.tv_rounded),
            label: 'TV',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_3_outlined),
            label: 'Profil',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}
