import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:full_body_routine/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    List<String> Col_1 = Provider.of<ProfileInfo>(context).workoutExcises;
    List<String> Col_2 = Provider.of<ProfileInfo>(context).Col_2();
    List<Excise> excises = [];

    for (var i = 1; i < Col_1.length; i++) {
      excises.add(Excise(
        index: i,
        title: Col_1[i],
        weight: Col_2[i],
      ));
    }
    @override
    initState() {
      super.initState();

      setState(() {});
    }

    InkWell buildListItem(Excise item) {
      return InkWell(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(item.title),
              subtitle: Text('${item.weight} kg'),
            )),
        onTap: () {
          _dialogBuilder(context, item);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: excises.map((item) => buildListItem(item)).toList(),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Excise item) {
    String inputValue = '';
    Function setWeight =
        Provider.of<ProfileInfo>(context, listen: false).setWeight;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change weight'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Enter your ${item.title}',
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
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                setWeight(item.title, inputValue);
              },
            ),
          ],
        );
      },
    );
  }
}
