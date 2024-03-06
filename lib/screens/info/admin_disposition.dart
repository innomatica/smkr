import 'package:flutter/material.dart';

class AdminDisposiiton extends StatelessWidget {
  final List<dynamic> adminInfo;
  const AdminDisposiiton({required this.adminInfo, super.key});

  Widget _buildAdminInfo() {
    return ListView.builder(
      itemCount: adminInfo.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(adminInfo[index]['ENTP_NAME']),
          subtitle: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                title: Text(
                  '주소',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(adminInfo[index]['ADDR']),
              ),
              ListTile(
                title: Text(
                  '행정처분명',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(adminInfo[index]['ADM_DISPS_NAME']
                    .replaceAll('○', '')
                    .trim()),
              ),
              ListTile(
                title: Text(
                  '제품명',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(adminInfo[index]['ITEM_NAME']),
              ),
              ListTile(
                title: Text(
                  '위반법명',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(adminInfo[index]['BEF_APPLY_LAW']
                    .replaceAll('○', '')
                    .trim()),
              ),
              ListTile(
                title: Text(
                  '위반내용',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                subtitle: Text(
                    adminInfo[index]['EXPOSE_CONT'].replaceAll('○', '').trim()),
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
        title: const Text('제약사 행정처분 기록'),
      ),
      body: _buildAdminInfo(),
    );
  }
}
