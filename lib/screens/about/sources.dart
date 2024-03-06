import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/settings.dart';

class SourceList extends StatelessWidget {
  const SourceList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          title: Text(
            '공공데이터포털',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('식품의약품안전처 의약품 제품 허가정보\n'
              '식품의약품안전처 의약품개요정보 (e약은요)\n'
              '식품의약품안전처 의약품 행정처분 정보\n'
              '식품의약품안전처 의약품 회수·판매중지 정보'),
          onTap: () async {
            await launchUrl(Uri.parse(urlDataGoKr));
          },
        ),
        ListTile(
          title: Text(
            '의약품안전나라',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('의약품 DUR 정보\n' '의약품 이상사례보고'),
          onTap: () async {
            await launchUrl(Uri.parse(urlNedrugMfdsGoKr));
          },
        ),
        ListTile(
          title: Text(
            '한국의약품안전관리원',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('의약품부작용 신고 및 피해구제 상담전화'),
          onTap: () async {
            await launchUrl(Uri.parse(urlDrugSafeOrKr));
          },
        ),
        ListTile(
          title: Text(
            '위키피디아 한글판',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          subtitle: const Text('의약품 성분 검색'),
          onTap: () async {
            await launchUrl(Uri.parse(urlWikipedia));
          },
        ),
      ],
    );
  }
}
