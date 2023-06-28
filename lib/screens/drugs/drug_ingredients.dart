import 'package:flutter/material.dart';

import '../../models/drug.dart';

class DrugIngredients extends StatelessWidget {
  final Drug drug;
  const DrugIngredients({required this.drug, Key? key}) : super(key: key);

  Widget _buildIngredient(BuildContext context) {
    final materials = drug.drugInfo['materials'];
    final mains = drug.drugInfo['ingredients']['main'];
    final additives = drug.drugInfo['ingredients']['additives'];

    return ListView(
      children: [
        ListTile(
          title: const Text('원료성분'),
          subtitle: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: materials.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  materials[index]['성분명'],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(
                  "${materials[index]['분량']} "
                  "${materials[index]['단위']} "
                  "${materials[index]['규격']}   "
                  "${materials[index]['비고']} ",
                ),
              );
            },
          ),
        ),
        ListTile(
          title: const Text('주성분'),
          subtitle: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: mains.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  mains[index],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            },
          ),
        ),
        ListTile(
          title: const Text('첨가물'),
          subtitle: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: additives.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  additives[index],
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('성분정보'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildIngredient(context),
      ),
    );
  }
}
