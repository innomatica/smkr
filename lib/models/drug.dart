import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/helpers.dart';

class Drug {
  int id;
  String drugId; // ITEM_SEQ (품목기준코드)
  String drugName; // ITEM_NAME (품목명)
  String drugType; // ETC_OTC_CODE (전문일반)
  String frequency; // (주기)
  Map drugInfo; //
  // barCodes; // BAR_CODE (표준코드)
  // dose; // (용량)
  // category; // CLASS_NO (분류)
  // form; // CHART (성상)
  // ingredients; // MATERIAL_NAME (주성분)
  // status; // CANCEL_NAME (상태)
  // storage; // STORAGE_METHOD (저장방법)
  // expiry; // VALID_TERM (유효기간)
  // package; // PACK_UNIT (포장단위)
  // ediCode; // EDI_CODE (보험코드)
  Map? companyInfo;
  // companyName: ENTP_NAME (업체명)
  // companyId: ENTP_NO (업체허가번호)
  // sector: INDUTY_TYPE (업종구분)
  // manufacturer: CNSGN_MANUF (위탁제조업체)
  Map? prescriptionInfo; // (처방전)
  Map? recallInfo; // (리콜)
  Map? efficacyInfo; // EE_DOC_DATA (효능효과)
  Map? dosageInfo; // UD_DOC_DATA (용법용량)
  Map? warningInfo; // NB_DOC_DATA (주의사항)
  Map? durInfo; // DUR
  Map? consumerInfo; // e약은요

  Drug({
    required this.id,
    required this.drugId,
    required this.drugName,
    required this.drugType,
    required this.frequency,
    required this.drugInfo,
    this.companyInfo,
    this.prescriptionInfo,
    this.recallInfo,
    this.efficacyInfo,
    this.dosageInfo,
    this.warningInfo,
    this.durInfo,
    this.consumerInfo,
  });

  factory Drug.fromDatabaseJson(Map<String, dynamic> data) {
    return Drug(
      id: data['id'],
      drugId: data['drugId'],
      drugName: data['drugName'],
      drugType: data['drugType'],
      frequency: data['frequency'],
      drugInfo: jsonDecode(data['drugInfo']),
      companyInfo: jsonDecode(data['companyInfo']) ?? {},
      prescriptionInfo: jsonDecode(data['prescriptionInfo']) ?? {},
      recallInfo: jsonDecode(data['recallInfo']) ?? {},
      efficacyInfo: jsonDecode(data['efficacyInfo']) ?? {},
      dosageInfo: jsonDecode(data['dosageInfo']) ?? {},
      warningInfo: jsonDecode(data['warningInfo']) ?? {},
      durInfo: jsonDecode(data['durInfo']) ?? {},
      consumerInfo: jsonDecode(data['consumerInfo']) ?? {},
    );
  }

  factory Drug.fromRestApi(Map<String, dynamic> item) {
    return Drug(
      id: getDatabaseId(),
      drugId: item['ITEM_SEQ'],
      drugName: item['ITEM_NAME'],
      drugType: item['ETC_OTC_CODE'],
      frequency: standardRegimen.entries.first.key,
      drugInfo: {
        'barCodes': item['BAR_CODE'].split(','),
        'dose': '일회분',
        'category': item['CLASS_NO'] ?? '',
        'form': item['CHART'] ?? '',
        'materials': _decodeMaterials(item['MATERIAL_NAME']),
        'ingredients': _decodeIngredients(
          item['MAIN_ITEM_INGR'],
          item['INGR_NAME'],
        ),
        'status': item['CANCEL_NAME'] ?? '',
        'storage': item['STORAGE_METHOD'] ?? '',
        'expiry': item['VALID_TERM'] ?? '',
        'package': item['PACK_UNIT'] ?? '',
        'ediCode': item['EDI_CODE'] ?? '보험코드 없음',
      },
      companyInfo: {
        'companyName': item['ENTP_NAME'],
        'companyId': item['ENTP_NO'],
        'sector': item['INDUTY_TYPE'] ?? '',
        'manufacturer': item['CNSGN_MANUF'] ?? item['ENTP_NAME'],
      },
      efficacyInfo: {
        'xml': item['EE_DOC_DATA'],
      },
      dosageInfo: {
        'xml': item['UD_DOC_DATA'],
      },
      warningInfo: {
        'xml': item['NB_DOC_DATA'],
      },
      durInfo: {},
      consumerInfo: {},
    );
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'drugId': drugId,
      'drugName': drugName,
      'drugType': drugType,
      'frequency': frequency,
      'drugInfo': jsonEncode(drugInfo),
      'companyInfo': jsonEncode(companyInfo ?? {}),
      'prescriptionInfo': jsonEncode(prescriptionInfo ?? {}),
      'recallInfo': jsonEncode(recallInfo ?? {}),
      'efficacyInfo': jsonEncode(efficacyInfo ?? {}),
      'dosageInfo': jsonEncode(dosageInfo ?? {}),
      'warningInfo': jsonEncode(warningInfo ?? {}),
      'durInfo': jsonEncode(durInfo ?? {}),
      'consumerInfo': jsonEncode(consumerInfo ?? {}),
    };
  }

  static List<Map> _decodeMaterials(String materials) {
    final result = <Map>[];
    final items = materials.split(';');

    for (final item in items) {
      final descriptions = item.split('|');
      var body = {};
      for (final description in descriptions) {
        final name = description.split(':')[0].trim();
        final value = description.split(':')[1].trim();
        body[name] = value;
      }
      // avoid duplicated entries
      if (result.every((element) => element['성분명'] != body['성분명'])) {
        result.add(body);
      }
      body = {};
    }
    // debugPrint(result.toString());
    return result;
  }

  static Map<String, dynamic> _decodeIngredients(
    String main,
    String additives,
  ) {
    final result = {'main': [], 'additives': []};
    // avoid duplicated entries
    for (final item in main.split('|')) {
      if (result['main']!.every((element) => element != item)) {
        result['main']!.add(item);
      }
    }
    for (final item in additives.split('|')) {
      if (result['additives']!.every((element) => element != item)) {
        result['additives']!.add(item);
      }
    }
    // debugPrint(result.toString());
    return result;
  }

  @override
  String toString() {
    return toDatabaseJson().toString();
  }

  Widget getIcon({Color? color, double? size}) {
    String dosageForm = drugInfo['form'] ?? '';

    if (dosageForm.contains('정제') ||
        dosageForm.contains('제피정') ||
        dosageForm.contains('코팅정') ||
        dosageForm.contains('캡슐') ||
        dosageForm.contains('캅셀') ||
        dosageForm.contains('삼중정') ||
        dosageForm.contains('당의정') ||
        dosageForm.contains('환제')) {
      return FaIcon(FontAwesomeIcons.pills, color: color, size: size);
    } else if (dosageForm.contains('주사') || dosageForm.contains('앰플')) {
      return FaIcon(FontAwesomeIcons.syringe, color: color, size: size);
    } else if (dosageForm.contains('에어로솔')) {
      return FaIcon(FontAwesomeIcons.sprayCan, color: color, size: size);
    } else if (dosageForm.contains('과립') ||
        dosageForm.contains('분말') ||
        dosageForm.contains('가루')) {
      return FaIcon(FontAwesomeIcons.mortarPestle, color: color, size: size);
    } else if (dosageForm.contains('반창고')) {
      return FaIcon(FontAwesomeIcons.bandage, color: color, size: size);
    } else if (dosageForm.contains('연고')) {
      return FaIcon(FontAwesomeIcons.handHoldingDroplet,
          color: color, size: size);
    } else if (dosageForm.contains('액제') ||
        dosageForm.contains('엑스제') ||
        dosageForm.contains('엑기스') ||
        dosageForm.contains('시럽') ||
        dosageForm.contains('용액') ||
        dosageForm.contains('액')) {
      return FaIcon(FontAwesomeIcons.wineBottle, color: color, size: size);
    } else {
      return FaIcon(FontAwesomeIcons.prescriptionBottleMedical,
          color: color, size: size);
    }
  }
}

Map<String, List<DateTime>> standardRegimen = {
  '하루 한번': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
  ],
  '하루 두번': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '하루 세번': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 14),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '하루 네번': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '하루 다섯번': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 5),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '매 3시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 3),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 15),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '매 4시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 1),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 5),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 13),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '매 6시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 24),
  ],
  '매 8시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 16),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 24),
  ],
  '매 12시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '매 24시간 마다': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
  ],
  '잠자기 전': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
  '밥 먹기 전': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
  ],
  '밥 먹기 전과 잠자기 전': [
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 17),
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
  ],
};

Map<String, int> drugAlarmInterval = {
  '하루 한번': 24,
  '하루 두번': 12,
  '하루 세번': 8,
  '하루 네번': 6,
  '하루 다섯번': 5,
  '매 3시간 마다': 3,
  '매 4시간 마다': 4,
  '매 6시간 마다': 6,
  '매 8시간 마다': 8,
  '매 12시간 마다': 12,
  '매 24시간 마다': 24,
  '잠자기 전': 24,
  '밥 먹기 전': 8,
  '밥 먹기 전과 잠자기 전': 6,
};
