import 'package:flutter/material.dart';

import 'app_info.dart';
import 'attribution.dart';
import 'disclaimer.dart';
import 'privacy.dart';
import 'sources.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  final List<bool> _expandedFlag = [
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('관련 정보'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _expandedFlag[index] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(title: Text('자료출처'));
                },
                body: const SourceList(),
                isExpanded: _expandedFlag[0],
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(title: Text('법적고지'));
                },
                body: const Disclaimer(),
                isExpanded: _expandedFlag[1],
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(title: Text('개인정보 보호'));
                },
                body: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Privacy(),
                ),
                isExpanded: _expandedFlag[2],
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(title: Text('감사'));
                },
                body: const Attribution(),
                isExpanded: _expandedFlag[3],
                canTapOnHeader: true,
              ),
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return const ListTile(title: Text('버전, 문의'));
                },
                body: const AppInfo(),
                isExpanded: _expandedFlag[4],
                canTapOnHeader: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
