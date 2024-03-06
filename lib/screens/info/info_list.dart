import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../logic/drug.dart';
import '../../services/data_go_kr.dart';
import '../../shared/settings.dart';
import 'admin_disposition.dart';
import 'drug_recalls.dart';

class InfoList extends StatefulWidget {
  const InfoList({super.key});

  @override
  State<InfoList> createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  Future<void> _launchDelegate(String target) async {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height / 2;
    final drugs = context.read<DrugBloc>().drugs;

    final items = <PopupMenuItem>[];
    for (final drug in drugs) {
      items.add(PopupMenuItem(
        child: Text(drug.drugName.split('(')[0]),
        onTap: () async {
          if (target == urlDurInfo) {
            Clipboard.setData(
              ClipboardData(text: drug.drugName.split('(')[0]),
            ).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('약 이름이 클립보드에 복사되었습니다'),
              ));
            });
            await Future.delayed(const Duration(seconds: 2));
            await launchUrl(Uri.parse(target));
          } else if (target == urlWikipedia) {
            if (drug.drugInfo['ingredients']['main'].length == 1) {
              var mainIngredients = drug.drugInfo['ingredients']['main'][0];
              if (mainIngredients.contains(']')) {
                mainIngredients = mainIngredients.split(']')[1];
              }
              Clipboard.setData(
                ClipboardData(text: mainIngredients),
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('약 주성분이 클립보드에 복사되었습니다'),
                ));
              });
            } else {
              Clipboard.setData(
                ClipboardData(text: drug.drugName.split('(')[0]),
              ).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('약 이름이 클립보드에 복사되었습니다'),
                ));
              });
            }
            await Future.delayed(const Duration(seconds: 2));
            await launchUrl(Uri.parse(target));
          } else if (target == 'IROS10B') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('자료를 검색하고 있습니다...')));
            final res = await DataGoKrService.getDrugRecallInfo(drug.drugName);

            if (!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            if (res == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('서버 오류입니다')));
            } else {
              if (res.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('해당 자료가 없습니다'),
                ));
              } else {
                debugPrint(res.toString());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DrugRecall(recallInfo: res),
                  ),
                );
              }
            }
          } else if (target == 'IROS50') {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('자료를 검색하고 있습니다...')));
            final res = await DataGoKrService.getAdminDisposition(
                drug.companyInfo!['companyName']);

            if (!mounted) return;
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            if (res == null) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('서버 오류입니다')));
            } else {
              if (res.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('해당 자료가 없습니다'),
                ));
              } else {
                debugPrint(res.toString());
                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminDisposiiton(adminInfo: res),
                  ),
                );
              }
            }
          }
        },
      ));
    }

    if (items.isNotEmpty) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            centerX - 100, centerY - 100, centerX + 100, centerY + 100),
        initialValue: const PopupMenuItem(child: Text('initial item')),
        items: items,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('현재 등록된 약이 없습니다'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.circleExclamation,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('의약품 회수·판매중지 조회'),
            onTap: () async {
              _launchDelegate('IROS10B');
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('제약사 행정처분 기록 조회'),
            onTap: () {
              _launchDelegate('IROS50');
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.userShield,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('의약품 안전사용정보(DUR)'),
            onTap: () async {
              _launchDelegate(urlDurInfo);
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.penToSquare,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('의약품 이상사례보고'),
            onTap: () {
              launchUrl(Uri.parse(urlAdverseEffectReport));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.headset,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('의약품부작용 신고 및 피해구제 상담전화'),
            onTap: () {
              launchUrl(Uri(
                scheme: 'tel',
                path: phoneAdverseEffectReport,
              ));
              // launch("tel:" + Uri.encodeComponent(phoneAdverseEffectReport));
            },
          ),
          ListTile(
            leading: FaIcon(
              FontAwesomeIcons.wikipediaW,
              size: 20.0,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('위키피디아 검색'),
            onTap: () {
              _launchDelegate(urlWikipedia);
            },
          ),
        ],
      ),
    );
  }
}
