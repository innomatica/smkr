import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/settings.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          title: Text(
            '책임의 한계',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text("\u2022 이 프로그램의 개발하고 제공한 주체"
              " (이하 '개발자')는 이 프로그램이 직접, 또는 간접적으로"
              " 제공하는 모든 자료의  정확성, 저작권 준수 여부,"
              " 적법성 또는 도덕성에 대해 아무런 책임을 지지 않습니다.\n\n"
              " \u2022 이 프로그램을 사용하는 주체(이하 '사용자')는 자료에 대한"
              " 신뢰 여부가 전적으로 이용자의 책임임을 인정합니다.\n\n"
              " \u2022 개발자는 또한 이 프로그램의 기능에 대해서 아무런 보장을"
              " 하지 않습니다.\n\n"),
        ),
        ListTile(
          title: Text(
            '법적고지 전문',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('여기를 클릭해 주세요'),
          onTap: () {
            launchUrl(Uri.parse(urlDisclaimer));
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
