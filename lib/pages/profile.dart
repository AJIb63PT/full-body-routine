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
  );

  int id;
  String title;
  String weight;
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

    List firstCol = ['Exercise', ...Provider.of<List>(context)];
    List secondCol = [
      'Weight, kg',
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

    TableRow buildTableRow(Item item) {
      return TableRow(
          key: ValueKey(item.id),
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(item.title),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(item.weight),
              ),
            ),
          ]);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile'),
      ),
      body: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: items.map((item) => buildTableRow(item)).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.create),
      ),
    );
  }
}
