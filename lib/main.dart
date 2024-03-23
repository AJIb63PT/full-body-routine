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

  runApp(MultiProvider(
      providers: [
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

  String wSquad = '85';
  String wBringing = '40';
  String wGoodMorning = '40';
  String wCalf = '50';
  String wShoulders = '6';
  String wHug = '45';
  String wPullLB = '65';
  String wTriceps = '13';
  String wBiceps = '12';

  List<String> workoutExcises = [
    'Exercise',
    'Squad',
    'Bringing Leg',
    'Good Morning',
    'Shoulders',
    'Calf',
    'Hug',
    'Pull ups Lower Block',
    'Pull ups',
    'Triceps',
    'Biceps',
    'Abs'
  ];

  List<String> Col_2() {
    return [
      'Weight, kg',
      wSquad,
      wBringing,
      wGoodMorning,
      wShoulders,
      wCalf,
      wHug,
      wPullLB,
      bodyWeight,
      wTriceps,
      wBiceps,
      bodyWeight
    ];
  }

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
        wBiceps = value;
        break;
      case 'Calf':
        wCalf = value;
        break;
      default:
        print('no case');
        break;
    }
    notifyListeners();
  }
}

class Excise {
  String title;
  String weight;
  int index;
  String sets;
  String repeats;

  Excise({
    this.index = 0,
    required this.title,
    this.weight = '0',
    this.sets = '0',
    this.repeats = '0',
  });
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
