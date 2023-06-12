import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:footgal/core/common/error_page.dart';
import 'package:footgal/core/common/loader.dart';
import 'package:footgal/core/utils.dart';
import 'package:footgal/features/admin/player/add_player_service.dart';
import 'package:footgal/models/player_model.dart';
import 'package:footgal/models/team_model.dart';

class AddPlayerScreen extends ConsumerStatefulWidget {
  // final String type;
  const AddPlayerScreen({
    super.key,
    // required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPlayerScreenState();
}

class _AddPlayerScreenState extends ConsumerState<AddPlayerScreen> {
  File? profilFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  final dateController = TextEditingController();
  TeamM? selectedTeam;
  String? selectedPosition;
  List<TeamM> teams = [];
  DateTime datetime = DateTime.now();
  List<String> positions = [
    'Gardien',
    'Defenseur',
    'Milieu',
    'Attaquant',
  ];

  void selectProfilImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profilFile = File(res.files.first.path!);
      });
    }
  }

  void _selectedDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.utc(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2023),
    ).then((value) {
      setState(() {
        datetime = value!;
        dateController.text = "${value.day}/${value.month}/${value.year}";
      });
    });
  }

  void addPlayer() {
    if (nameController.text.isNotEmpty && numeroController.text.isNotEmpty) {
      // showSnackBar(context, "D'accord");
      ref.watch(addPlayerServiceProvider).addPlayer(
            context: context,
            date: datetime,
            file: profilFile,
            name: nameController.text.trim(),
            pays: 'Senegal',
            numero: int.parse(numeroController.text.trim()),
            position: selectedPosition ?? positions[0],
            team: selectedTeam ?? teams[0],
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    numeroController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un joueur'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => addPlayer(),
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
              Expanded(
                child: TextField(
                  controller: numeroController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    filled: true,
                    hintText: 'Numero de dosart',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ref.watch(getAllTeamsProvider).when(
                    data: (data) {
                      teams = data;
                      if (data.isEmpty) {
                        return const SizedBox();
                      }
                      return DropdownButton(
                        value: selectedTeam ?? data[0],
                        items: data
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedTeam = val;
                          });
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorPage(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
              DropdownButton(
                value: selectedPosition ?? positions[0],
                items: positions
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedPosition = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Date',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                    labelText:
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  ),
                ),
              ),
              MaterialButton(
                onPressed: _selectedDate,
                color: Colors.black,
                child: const Text(
                  "Choisir date",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
