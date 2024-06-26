import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';
import '../utils/check_latest_version.dart';

import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _myBox = Hive.box('myBox');
  ExerciseDataBase db = ExerciseDataBase();

  @override
  void initState() {
    if (_myBox.get("EXERCISES_LIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String bodyWeight = Provider.of<BodyWeightValue>(
      context,
    ).value;
    if (_myBox.get('BodyWeight') != null &&
        _myBox.get('BodyWeight') != bodyWeight) {
      bodyWeight = _myBox.get('BodyWeight');
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Профиль'),
        ),
        body: InkWell(
          child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(children: [
                SizedBox(
                    width: 250,
                    child: ListTile(
                      title: const Text('Вес тела, кг'),
                      subtitle: Text(bodyWeight),
                    )),
              ])),
          onTap: () {
            _dialogBuilder(context);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _snackBarBuilder(context);
          },
          child: const Icon(Icons.update),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    String inputValue = '';
    Function setWeight =
        Provider.of<BodyWeightValue>(context, listen: false).setBodyWeight;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Новый Вес тела'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.]+'))
            ],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'кг',
            ),
            onChanged: (text) {
              inputValue = text;
            },
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Сохранить'),
              onPressed: () {
                Navigator.of(context).pop();
                setWeight(inputValue);
                for (var i = 0; i < db.excisesList.length; i++) {
                  if (db.excisesList[i][3] == 'true') {
                    db.excisesList[i][1] =
                        Provider.of<BodyWeightValue>(context, listen: false)
                            .value;
                  }
                }
                db.updateDataBase();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _snackBarBuilder(BuildContext context) async {
    CheckLatestVersionRes res = await checkLatestVersion();

    final snackBar = SnackBar(
      content: Text(res.statusText),
      action: SnackBarAction(
        label: res.hasUpdate ? 'Скачать' : 'Закрыть',
        onPressed: () {
          res.hasUpdate
              ? launchUrl(
                  Uri.parse(res.newAppUrl),
                  mode: LaunchMode.externalApplication,
                )
              : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      duration: const Duration(minutes: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
