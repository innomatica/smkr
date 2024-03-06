import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/drug.dart';
import '../../models/drug.dart';
import '../../services/data_go_kr.dart';
import 'drug_consumer.dart';
import 'drug_ingredients.dart';
import 'drug_xml.dart';

class DrugDetails extends StatefulWidget {
  final Drug drug;
  const DrugDetails({required this.drug, super.key});

  @override
  State<DrugDetails> createState() => _DrugDetailsState();
}

class _DrugDetailsState extends State<DrugDetails> {
  @override
  Widget build(BuildContext context) {
    final drugBloc = context.read<DrugBloc>();

    Future<bool> getDrugEasyInfo() async {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 30),
        content: Text("데이터를 가져오고 있습니다..."),
      ));

      final easyInfo =
          await DataGoKrService.getDrugEasyInfo(widget.drug.drugId);

      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (easyInfo == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("서버 접속에 실패했습니다"),
        ));
        return false;
      } else {
        if (easyInfo.isEmpty) {
          widget.drug.consumerInfo!['no data'] = 'no data';
        } else {
          widget.drug.consumerInfo = easyInfo;
        }
        drugBloc.update(widget.drug);
        return true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drug.drugName.split("(")[0]),
        actions: [
          TextButton.icon(
            onPressed: () async {
              drugBloc.delete(widget.drug);
              Navigator.pop(context);
            },
            icon:
                Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            label: Text(
              '삭제',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('보험코드'),
            subtitle: Text(
              widget.drug.drugInfo.containsKey('ediCode')
                  ? widget.drug.drugInfo['ediCode']
                  : '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          // ListTile(
          //   title: const Text('품목기준코드'),
          //   subtitle: Text(
          //     drug.drugId,
          //     style: TextStyle(
          //       color: Theme.of(context).colorScheme.secondary,
          //     ),
          //   ),
          // ),
          ListTile(
            title: const Text('제약사 / 제조사'),
            subtitle: Text(
              "${widget.drug.companyInfo?['companyName'] ?? ''}"
              " / ${widget.drug.companyInfo?['manufacturer'] ?? ''}",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            title: const Text('전문 / 일반 구분'),
            subtitle: Text(
              widget.drug.drugType,
              style: TextStyle(
                color: widget.drug.drugType.contains('전문')
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          // ListTile(
          //   title: const Text('성상'),
          //   subtitle: Text(drug.drugInfo['form'] ?? ''),
          // ),
          ListTile(
            title: const Text('보관방법'),
            subtitle: Text(
              (widget.drug.drugInfo['storage'] ?? '').trim(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          ListTile(
            title: const Text('유효기간'),
            subtitle: Text(
              widget.drug.drugInfo['expiry'] ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: OutlinedButton(
              child: const Text('성분정보'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return DrugIngredients(drug: widget.drug);
                  }),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: OutlinedButton(
              child: const Text('효능효과'),
              onPressed: () {
                if ((widget.drug.efficacyInfo != null) &&
                    (widget.drug.efficacyInfo as Map).containsKey('xml')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DrugXml(
                          xml: widget.drug.efficacyInfo!['xml'] ?? '');
                    }),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: OutlinedButton(
              child: const Text('용법용량'),
              onPressed: () {
                if ((widget.drug.dosageInfo != null) &&
                    (widget.drug.dosageInfo as Map).containsKey('xml')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DrugXml(xml: widget.drug.dosageInfo!['xml'] ?? '');
                    }),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: OutlinedButton(
              child: const Text('주의사항'),
              onPressed: () {
                if ((widget.drug.warningInfo != null) &&
                    (widget.drug.warningInfo as Map).containsKey('xml')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return DrugXml(
                          xml: widget.drug.warningInfo!['xml'] ?? '');
                    }),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: OutlinedButton(
              child: const Text('e약은요 (친근한 설명)'),
              onPressed: () async {
                if ((widget.drug.consumerInfo == null) ||
                    (widget.drug.consumerInfo!.isEmpty)) {
                  await getDrugEasyInfo();
                }
                if (!context.mounted) return;

                if (widget.drug.consumerInfo!.isNotEmpty) {
                  if (widget.drug.consumerInfo!.containsKey('no data')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('이 약은 해당 정보가 없습니다'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DrugConsumerInfo(drug: widget.drug);
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40.0),
          //   child: OutlinedButton(
          //     child: const Text('DUR (안전사용정보)'),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return DrugDurInfo(drug: drug);
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
