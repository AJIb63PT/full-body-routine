import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _myBox = Hive.box('myBox');
  final _controllerE = TextEditingController();
  final _controllerW = TextEditingController();
  ExerciseDataBase db = ExerciseDataBase();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Профиль'),
        ),
        body: InkWell(
          child: Container(
              padding: const EdgeInsets.all(5),
              child: const Row(children: [
                SizedBox(
                    width: 250,
                    child: ListTile(
                      title: Text('asd кг'),
                      subtitle: Text('1231'),
                    )),
                SizedBox(width: 8),
              ])),
          onTap: () {},
        ));
  }
}
