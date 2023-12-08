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

class Item {
  Item(
    this.id,
    this.title,
    this.weight,
    // this.setData,
  );

  int id;
  String title;
  String weight;
  // Function setData;
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String bodyWeight = Provider.of<ProfileInfo>(context).bodyWeight;

    String wSquad = Provider.of<ProfileInfo>(context).wSquad;
    String wBringing = Provider.of<ProfileInfo>(context).wBringing;
    String wShoulders = Provider.of<ProfileInfo>(context).wShoulders;
    String wHug = Provider.of<ProfileInfo>(context).wHug;
    String wPullLB = Provider.of<ProfileInfo>(context).wPullLB;
    String wTriceps = Provider.of<ProfileInfo>(context).wTriceps;
    String wBiceps = Provider.of<ProfileInfo>(context).wBiceps;

    List firstCol = [
      // 'Exercise',
      ...Provider.of<List>(context)
    ];
    List secondCol = [
      // 'Weight, kg',
      wSquad,
      wBringing,
      wShoulders,
      wHug,
      wPullLB,
      bodyWeight,
      wTriceps,
      wBiceps,
      bodyWeight
    ];
    List items = [];
    for (var i = 0; i < firstCol.length; i++) {
      items.add(Item(
        i,
        firstCol[i],
        secondCol[i],
      ));
    }

    @override
    initState() {
      super.initState();

      setState(() {});
    }

    InkWell buildListItem(Item item) {
      return InkWell(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.weight + ' kg'),
            )),
        onTap: () {
          print("tapped on container");
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
        children: items.map((item) => buildListItem(item)).toList(),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Item item) {
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
              labelText: 'Enter your ' + item.title,
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
