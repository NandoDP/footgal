import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/team/add_team_service.dart';
import 'package:footgal/models/competition.dart';

class AddTeamScreen extends ConsumerStatefulWidget {
  // final String type;
  const AddTeamScreen({
    super.key,
    // required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTeamScreenState();
}

class _AddTeamScreenState extends ConsumerState<AddTeamScreen> {
  File? profilFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController nationaliteController = TextEditingController();
  // final dateController = TextEditingController();
  // TeamM? selectedTeam;
  // String? selectedPosition;
  List<CompetitionM> competitions = [];
  // DateTime datetime = DateTime.now();
  // List<String> positions = [
  //   'Gardien',
  //   'Defenseur',
  //   'Milieu',
  //   'Attaquant',
  // ];

  void selectProfilImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profilFile = File(res.files.first.path!);
      });
    }
  }

  void addTeam() {
    if (nameController.text.isNotEmpty
        // && nationaliteController.text.isNotEmpty
        ) {
      ref.watch(addTeamServiceProvider).addTeam(
            context: context,
            name: nameController.text.trim(),
            pays: 'Senegal',
            competitions: competitions,
            file: profilFile,
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    nationaliteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un joueur'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => addTeam(),
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 244, 243, 243),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: selectProfilImage,
            child: profilFile != null
                ? CircleAvatar(
                    backgroundImage: FileImage(profilFile!),
                    radius: 45,
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 45,
                  ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Name complet',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Expanded(
              //   child: TextField(
              //     controller: nationaliteController,
              //     decoration: const InputDecoration(
              //       filled: true,
              //       hintText: 'Nationalité',
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 10),
            ],
          ),
          // const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     ref.watch(getAllTeamsProvider).when(
          //           data: (data) {
          //             teams = data;
          //             if (data.isEmpty) {
          //               return const SizedBox();
          //             }
          //             return DropdownButton(
          //               value: selectedTeam ?? data[0],
          //               items: data
          //                   .map(
          //                     (e) => DropdownMenuItem(
          //                       value: e,
          //                       child: Text(e.name),
          //                     ),
          //                   )
          //                   .toList(),
          //               onChanged: (val) {
          //                 setState(() {
          //                   selectedTeam = val;
          //                 });
          //               },
          //             );
          //           },
          //           error: (error, stackTrace) => ErrorPage(
          //             error: error.toString(),
          //           ),
          //           loading: () => const Loader(),
          //         ),
          //     DropdownButton(
          //       value: selectedPosition ?? positions[0],
          //       items: positions
          //           .map(
          //             (e) => DropdownMenuItem(
          //               value: e,
          //               child: Text(e),
          //             ),
          //           )
          //           .toList(),
          //       onChanged: (val) {
          //         setState(() {
          //           selectedPosition = val;
          //         });
          //       },
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     SizedBox(
          //       width: 200,
          //       child: TextField(
          //         controller: dateController,
          //         readOnly: true,
          //         decoration: InputDecoration(
          //           filled: true,
          //           hintText: 'Date',
          //           border: InputBorder.none,
          //           contentPadding: const EdgeInsets.all(18),
          //           labelText:
          //               '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          //         ),
          //       ),
          //     ),
          //     MaterialButton(
          //       onPressed: _selectedDate,
          //       color: Colors.black,
          //       child: const Text(
          //         "Choisir date",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 20,
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
