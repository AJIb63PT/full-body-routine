import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:full_body_routine/pages/week.dart';
import 'package:full_body_routine/pages/workout.dart';
import 'package:full_body_routine/pages/profile.dart';
// import 'package:full_body_routine/pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  var box = await Hive.openBox('myBox');

  List workoutExcises = [
    'Squad',
    'Bringing Leg',
    'Shoulders',
    'Hug',
    'Pull ups Lower Block',
    'Pull ups',
    'Triceps',
    'Biceps',
    'Abs'
  ];

  runApp(MultiProvider(
      providers: [
        Provider(create: (context) => workoutExcises),
        ChangeNotifierProvider(create: (context) => ProfileInfo()),
        ChangeNotifierProvider(create: (context) => CurrentWeek()),
        ChangeNotifierProvider(create: (context) => CurrentDay()),
      ],
      child: MaterialApp(
        title: 'Full Body Routine',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WeekPage(),
          '/workout': (context) => const WorkoutPage(),
          '/profile': (context) => const ProfilePage(),
          // '/settings': (context) => const SettingsPage(),
        },
      )));
}

class ProfileInfo extends ChangeNotifier {
  String bodyWeight = '80';

  String wSquad = '80';
  String wBringing = '45';
  String wShoulders = '6';
  String wHug = '35';
  String wPullLB = '65';
  String wTriceps = '35';
  String wBiceps = '10';

  List workoutExcisesVar = [
    'wSquad',
    'wBringing',
    'wShoulders',
    'wHug',
    'wPullLB',
    'bodyWeight',
    'wTriceps',
    'wBiceps',
    'bodyWeight'
  ];

  void setWeight(String name, String value) {
    switch (name) {
      case 'Squad':
        wSquad = value;
        break;
      case 'Bringing Leg':
        wBringing = value;
        break;
      case 'Shoulders':
        wShoulders = value;
        break;
      case 'Hug':
        wHug = value;
        break;
      case 'Pull ups Lower Block':
        wPullLB = value;
        break;
      case 'Pull ups':
        bodyWeight = value;
        break;
      case 'Abs':
        bodyWeight = value;
        break;
      case 'Triceps':
        wTriceps = value;
        break;
      case 'Biceps':
        wTriceps = value;
        break;
      default:
        print('no case');
        break;
    }
    notifyListeners();
  }
}

class CurrentWeek extends ChangeNotifier {
  final _myBox = Hive.box('myBox');
  int counter = 1;
  void addCounter() {
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != counter) {
      counter = _myBox.get('CurrentWeek');
    }
    counter++;
    _myBox.put('CurrentWeek', counter);

    notifyListeners();
  }

  void minusCounter() {
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != counter) {
      counter = _myBox.get('CurrentWeek');
    }
    counter--;
    _myBox.put('CurrentWeek', counter);
    notifyListeners();
  }
}

class CurrentDay extends ChangeNotifier {
  String day = '';

  void setDay(val) {
    day = val;
    notifyListeners();
  }
}
