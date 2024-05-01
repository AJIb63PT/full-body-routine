import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:hive/hive.dart';
import '../data/database.dart';
// import '../controller/app_controller.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  final _myBox = Hive.box('myBox');
  ExerciseDataBase db = ExerciseDataBase();
  RxString oldVersion = "".obs;
  RxString currentVersion = "".obs;
  RxString newAppUrl = "".obs;

  Future<void> checkLatestVersion() async {
    const repositoryOwner = 'AJIb63PT';
    const repositoryName = 'full-body-routine';
    final response = await http.get(Uri.parse(
      'https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest',
    ));
    print('response');

    print(response.body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final tagName = data['tag_name'];
      oldVersion.value = tagName;
      final assets = data['assets'] as List<dynamic>;
      print('assets');
      print(assets);
      for (final asset in assets) {
        // добавить проверку на устройство
        final assetName = asset['name'];
        final assetDownloadUrl = asset['browser_download_url'];
        print('`1`1`1`1`1`1`1`1`1`1`1`1`1`1`1`');
        print(asset);

        newAppUrl.value = assetDownloadUrl;
      }

      if (currentVersion.value != oldVersion.value) {
        // checkUpdate();
      }
    } else {
      print(
          'Failed to fetch GitHub release info. Status code: ${response.statusCode}');
    }
  }

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
    // AppController appController = Get.put(AppController());
    checkLatestVersion();
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
            final snackBar = SnackBar(
              content: Text('New Update Available'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  launchUrl(
                    Uri.parse(newAppUrl.value),
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              duration: Duration(days: 1),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          child: const Icon(Icons.add),
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
          title: const Text(' Новый Вес тела'),
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
}
