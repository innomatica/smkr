import 'package:flutter/material.dart';

class DrugRecall extends StatelessWidget {
  final List<dynamic> recallInfo;
  const DrugRecall({required this.recallInfo, super.key});

  Widget _buildRecallInfo() {
    return ListView.builder(
      itemCount: recallInfo.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(recallInfo[index]['PRDUCT']),
          subtitle: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                title: Text(
                  '제약사',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(recallInfo[index]['ENTRPS']),
              ),
              ListTile(
                title: Text(
                  '연락처',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(recallInfo[index]['ENTRPS_TELNO']),
              ),
              ListTile(
                title: Text(
                  '회수사유',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(recallInfo[index]['RTRVL_RESN']),
              ),
              ListTile(
                title: Text(
                  '제조번호',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(recallInfo[index]['MNFCTUR_NO']),
              ),
              ListTile(
                title: Text(
                  '회수명령일자',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(recallInfo[index]['RECALL_COMMAND_DATE']),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('의약품 회수·판매중지 정보'),
      ),
      body: _buildRecallInfo(),
    );
  }
}
