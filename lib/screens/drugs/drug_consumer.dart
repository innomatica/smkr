import 'package:flutter/material.dart';

import '../../models/drug.dart';

class DrugConsumerInfo extends StatelessWidget {
  final Drug drug;
  const DrugConsumerInfo({required this.drug, super.key});

  @override
  Widget build(BuildContext context) {
    final info = drug.consumerInfo!;
    return Scaffold(
      appBar: AppBar(title: Text(drug.drugName.split('(')[0])),
      body: ListView(
        children: [
          info['efcyQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약의 효능은 무엇입니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['efcyQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '\n')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['useMethodQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약은 어떻게 사용합니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['useMethodQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .replaceAll('<sup>', '')
                      .replaceAll('</sup>', '')
                      .replaceAll('<sub>', '')
                      .replaceAll('</sub>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['atpnWarnQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약을 사용하기 전에 알아야 할 내용은 무엇입니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['atpnWarnQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['atpnQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약의 사용상 주의사항은 무엇입니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['atpnQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['intrcQesitm'] != null
              ? ListTile(
                  title: Text(
                    '주의해야 할 약 또는 음식은 무엇입니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['intrcQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['seQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약은 어떤 이상반응이 나타날 수 있습니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['seQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
          info['depositMethodQesitm'] != null
              ? ListTile(
                  title: Text(
                    '이 약은 어떻게 보관해야 합니까?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  subtitle: Text(info['depositMethodQesitm']
                      .replaceAll('<p>', '')
                      .replaceAll('</p>', '')
                      .trim()))
              : const SizedBox(width: 0, height: 0),
        ],
      ),
    );
  }
}
