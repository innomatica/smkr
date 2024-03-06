import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../logic/drug.dart';
import '../../models/activity.dart';
import '../../models/drug.dart';
import '../../models/schedule.dart';
import '../../services/data_go_kr.dart';
import '../../shared/settings.dart';
import '../../shared/helpers.dart';
import 'drug_alarm.dart';
import 'drug_details.dart';

class DrugList extends StatefulWidget {
  const DrugList({super.key});

  @override
  State<DrugList> createState() => _DrugListState();
}

class _DrugListState extends State<DrugList> {
  void _addDrug() async {
    String barcode = '-1';
    String searchName = '';
    List<dynamic>? searchResults;
    final drugBloc = context.read<DrugBloc>();

    if (skipBarcodeScan) {
      await showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              left: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: const InputDecoration(
                          icon: FaIcon(FontAwesomeIcons.barcode),
                          labelText: '바코드 번호를 입력해 주세요',
                        ),
                        onChanged: (value) {
                          barcode = value;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.pop(context, barcode);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      );
    } else {
      // FIXME: use mobile_scanner (https://pub.dev/packages/mobile_scanner)
      barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', "취소 (약이름으로 찾기)", false, ScanMode.DEFAULT);
    }

    if (!mounted) return;

    if (barcode == '-1') {
      await showModalBottomSheet<String?>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              left: 20.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: '약 이름을 입력해 주세요',
                        ),
                        onChanged: (value) {
                          searchName = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () async {
                        Navigator.pop(context, searchName);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );

      if (!mounted) return;

      if (searchName.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 30),
              content: Text("데이터를 가져오고 있습니다...")),
        );
        searchResults = await DataGoKrService.searchDrugsByName(searchName);

        if (!mounted) return;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (searchResults == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("서버 접속에 실패했습니다")),
          );
        } else if (searchResults.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("해당 약이름의 자료가 없습니다")),
          );
        } else {
          _showSelectDrugDialog(searchResults);
        }
      }
      searchName = '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 30),
            content: Text("데이터를 가져오고 있습니다...")),
      );
      final drugDetails =
          await DataGoKrService.getDrugDetailsByBarcode(barcode);
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (drugDetails == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("서버 접속에 실패했습니다")),
        );
      } else if (drugDetails.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("해당 바코드의 자료가 없습니다")),
        );
      } else {
        drugBloc.add(Drug.fromRestApi(drugDetails));
      }
    }
  }

  //
  // Drug Selection Dialog
  //
  Future<void> _showSelectDrugDialog(List searchResults) async {
    final drugBloc = context.read<DrugBloc>();
    await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('원하는 약을 선택해 주세요'),
          children: [
            SizedBox(
              height: 400,
              width: 400,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    color: const Color(0x60ffffff),
                    child: ListTile(
                      title: Text(
                        searchResults[index]['ITEM_NAME'].split('(')[0],
                      ),
                      subtitle: Text(
                        searchResults[index]['EDI_CODE'] ?? '보험코드 없음',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      onTap: () {
                        drugBloc.add(Drug.fromRestApi(searchResults[index]));
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  //
  // generate default schedule
  //
  Schedule _getDefaultSchedule(Drug drug) {
    return Schedule(
      id: drug.id,
      activityId: drug.id,
      activityType: ActivityType.medication,
      scheduleInfo: {
        'drugId': drug.drugId,
        'drugName': drug.drugName,
        'alarmInterval': drugAlarmInterval[drug.frequency],
      },
      alarmTimes: standardRegimen[drug.frequency] ?? [],
      alarmMatch: DateTimeMatch.time,
    );
  }

  //
  // Instruction
  //
  Widget _buildInstruction() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                size: 26.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Text(
                ' 으로 약상자의 바코드를 스캔하세요',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('    \u2731   '),
              Text('약 이름을 누르면 상세 정보를 볼 수 있어요'),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('    \u2731   '),
              Icon(
                Icons.alarm,
                size: 22.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const Text(' 을 누르면 알림을 설정할 수 있어요'),
            ],
          ),
        ],
      ),
    );
  }

  Offset _tapOffset = Offset.zero;

  _onTapDown(TapDownDetails details) {
    _tapOffset = details.globalPosition;
  }

  //
  // Drug Card
  //
  Widget _buildDrugCard(Drug drug) {
    final drugBloc = context.read<DrugBloc>();
    // gesture detector is used to get the coordinate for the popup
    return GestureDetector(
      onTapDown: (TapDownDetails details) => _onTapDown(details),
      // onTap: () {},
      onLongPress: () {
        showMenu(
          color: const Color(0x40ffffff),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          context: context,
          position: RelativeRect.fromLTRB(
              _tapOffset.dx, _tapOffset.dy, _tapOffset.dx, _tapOffset.dy),
          items: [
            PopupMenuItem(
              onTap: () => drugBloc.delete(drug),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const Text('  삭제하기'),
                ],
              ),
            ),
          ],
        );
      },
      child: Card(
        // elevation: 8.0,
        child: ListTile(
          leading: drug.getIcon(),
          title: Text(drug.drugName.split('(')[0]),
          subtitle: Text(drug.companyInfo!.containsKey('companyName')
              ? (drug.companyInfo as Map)['companyName']
              : ''),
          trailing: IconButton(
            icon: Icon(Icons.alarm,
                color: Theme.of(context).colorScheme.tertiary),
            onPressed: () async {
              final schedule =
                  await drugBloc.getSchedule(drug) ?? _getDefaultSchedule(drug);

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DrugAlarm(drug: drug, schedule: schedule),
                ),
              );
            },
          ),
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DrugDetails(drug: drug),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drugs = context.watch<DrugBloc>().drugs;

    return Stack(
      children: [
        drugs.isEmpty
            ? _buildInstruction()
            : ListView.builder(
                itemCount: drugs.length,
                itemBuilder: (context, index) => _buildDrugCard(drugs[index]),
              ),
        Positioned.fill(
          bottom: 16.0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              onPressed: _addDrug,
              child: const Text(
                '+',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
