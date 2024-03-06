import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/settings.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          title: Text(
            '개인정보의 수집',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('이 프로그램은 일체의 개인정보를 수집하지'
              ' 않습니다. 사용자가 생성한 모든 데이터는 오로지 사용자 기기'
              ' 안에 저장되며 프로그램 삭제시 같이 삭제됩니다.'),
        ),
        ListTile(
          title: Text(
            '개인정보 보호정책 전문',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('여기를 클릭해 주세요'),
          onTap: () {
            launchUrl(Uri.parse(urlPrivacyPolicy));
          },
        ),
        ListTile(
          title: Text(
            '작성 기준 일자',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('2022년 2월 1일'),
        ),
      ],
    );
  }
}
