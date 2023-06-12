import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/competition/add_competition_service.dart';
import 'package:footgal/models/team_model.dart';

class AddCompetitionScreen extends ConsumerStatefulWidget {
  const AddCompetitionScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddCompetitionScreenState();
}

class _AddCompetitionScreenState extends ConsumerState<AddCompetitionScreen> {
  File? profilFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController nationaliteController = TextEditingController();
  List<TeamM> teams = [];
  List<TeamM> selectedTeams = [];

  void selectProfilImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profilFile = File(res.files.first.path!);
      });
    }
  }

  void addTeamInList(TeamM name, int index) {
    setState(() {
      selectedTeams.add(name);
    });
  }

  void removeTeam(TeamM name, int index) {
    setState(() {
      selectedTeams.remove(name);
    });
  }

  void addTeam() {
    if (nameController.text.isNotEmpty
        // && nationaliteController.text.isNotEmpty
        ) {
      ref.watch(addCompetServiceProvider).addCompet(
            context: context,
            name: nameController.text.trim(),
            pays: 'Senegal',
            teams: selectedTeams,
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
      body: ListView(
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
          const SizedBox(height: 20),
          ref.watch(getAllTeamsProvider).when(
                data: (data) {
                  teams = data;
                  return Column(
                    children: data
                        .map((e) => CheckboxListTile(
                              value: selectedTeams.contains(e),
                              onChanged: (val) {
                                if (val!) {
                                  addTeamInList(e, 0);
                                } else {
                                  removeTeam(e, 0);
                                }
                              },
                              title: Text(e.name),
                            ))
                        .toList(),
                  );
                },
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
