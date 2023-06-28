import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:smkrapp/api_keys.dart';

enum DurInfoType {
  interaction,
  age,
  pregnancy,
  dosage,
  duration,
  senior,
  interchange,
}

class DataGoKrService {
  static const _scheme = 'https';
  static const _useIROS05 = false;
  // static const _useIROS74 = true;

  static const _apiHostDataGoKr = 'apis.data.go.kr';
  static const _pathDrugDetails =
      _useIROS05 ? _pathIROS05A : _pathIROS398A_2022;
  static const _pathDrugEasyInfo = _pathIROS239A;
  static const _pathDrugRecall = _pathIROS10_2022;
  static const _pathAdminDisposition = _pathIROS50_2022;

  // following APIs do not work at the monent
  // static const _pathDurInteraction = _useIROS74 ? _pathIROS74A : _pathIROS75A;
  // static const _pathDurAge = _useIROS74 ? _pathIROS74B : _pathIROS75B;
  // static const _pathDurPregnancy = _useIROS74 ? _pathIROS74C : _pathIROS75C;
  // static const _pathDurDosage = _useIROS74 ? _pathIROS74D : _pathIROS75D;
  // static const _pathDurDuration = _useIROS74 ? _pathIROS74E : _pathIROS75E;
  // static const _pathDurSenior = _useIROS74 ? _pathIROS74F : _pathIROS75F;
  // static const _pathDurInterchange = _useIROS74 ? _pathIROS74G : _pathIROS75G;

  static const _pathIROS05A =
      '/1471057/MdcinPrductPrmisnInfoService1/getMdcinPrductItem';
  // 식품의약품안전처 의약품 회수·판매중지 서비스
  // discontinue
  // ignore: unused_field
  static const _pathIROS10B =
      '/1471000/MdcinRtrvlSleStpgeInfoService01/getMdcinRtrvlSleStpgeItem';
  // active as of 2022
  static const _pathIROS10_2022 =
      '/1471000/MdcinRtrvlSleStpgeInfoService02/getMdcinRtrvlSleStpgeItem01';

  // 식품의약품안전처 의약품 행정처분 서비스
  // discontinued
  // ignore: unused_field
  static const _pathIROS50 =
      '/1471000/MdcinExaathrService03/getMdcinExaathrList03';
  // active as of 2022
  static const _pathIROS50_2022 =
      '/1471000/MdcinExaathrService04/getMdcinExaathrList04';

  static const _pathIROS239A =
      '/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList';

  // 식품의약품안전처 의약품 제품 허가정보
  // discontinued
  // ignore: unused_field
  static const _pathIROS398A =
      '/1471000/DrugPrdtPrmsnInfoService/getDrugPrdtPrmsnDtlInq';
  // active as of 2002
  static const _pathIROS398A_2022 =
      '/1471000/DrugPrdtPrmsnInfoService02/getDrugPrdtPrmsnDtlInq01';

  // static const _pathIROS74A =
  //     '/1471000/DURIrdntInfoService01/getUsjntTabooInfoList';
  // static const _pathIROS74B =
  //     '/1471000/DURIrdntInfoService01/getSpcifyAgrdeTabooInfoList';
  // static const _pathIROS74C =
  //     '/1471000/DURIrdntInfoService01/getPwnmTabooInfoList';
  // static const _pathIROS74D =
  //     '/1471000/DURIrdntInfoService01/getCpctyAtentInfoList';
  // static const _pathIROS74E =
  //     '/1471000/DURIrdntInfoService01/getMdctnPdAtentInfoList';
  // static const _pathIROS74F =
  //     '/1471000/DURIrdntInfoService01/getOdsnAtentInfoList';
  // static const _pathIROS74G =
  //     '/1471000/DURIrdntInfoService01/getEfcyDplctInfoList';

  // static const _pathIROS75A =
  //     '/1471000/DURPrdlstInfoService01/getUsjntTabooInfoList';
  // static const _pathIROS75B =
  //     '/1471000/DURPrdlstInfoService01/getSpcifyAgrdeTabooInfoList';
  // static const _pathIROS75C =
  //     '/1471000/DURPrdlstInfoService01/getPwnmTabooInfoList';
  // static const _pathIROS75D =
  //     '/1471000/DURPrdlstInfoService01/getCpctyAtentInfoList';
  // static const _pathIROS75E =
  //     '/1471000/DURPrdlstInfoService01/getMdctnPdAtentInfoList';
  // static const _pathIROS75F =
  //     '/1471000/DURPrdlstInfoService01/getOdsnAtentInfoList';
  // static const _pathIROS75G =
  //     '/1471000/DURPrdlstInfoService01/getEfcyDplctInfoList';
  // static const _pathIROS75H =
  //     '/1471000/DURPrdlstInfoService01/getSeobangjeongPartitnAtentInfoList';
  // static const _pathIROS75I =
  //     '/1471000/DURPrdlstInfoService01/getDurPrdlstInfoList';

  static Future<Map<String, dynamic>?> getDrugDetailsByBarcode(
      String barcode) async {
    final drugDetails =
        await _callRestApi(_pathDrugDetails, {'bar_code': barcode});
    if (drugDetails != null) {
      if (drugDetails.isEmpty) {
        return <String, dynamic>{};
      } else {
        return drugDetails[0];
      }
    }
    return null;
  }

  static Future<List<dynamic>?> searchDrugsByName(String drugName) async {
    return await _callRestApi(_pathDrugDetails, {'item_name': drugName});
  }

  static Future<Map<String, dynamic>?> getDrugEasyInfo(String drugId) async {
    final easyInfo = await _callRestApi(_pathDrugEasyInfo, {'itemSeq': drugId});
    if (easyInfo != null) {
      if (easyInfo.isEmpty) {
        return <String, dynamic>{};
      } else {
        return easyInfo[0];
      }
    }
    return null;
  }

  static Future<List<dynamic>?> getDrugRecallInfo(String drugName) async {
    final recallInfo =
        await _callRestApi(_pathDrugRecall, {'Prduct': drugName});
    return recallInfo;
  }

  static Future<List<dynamic>?> getAdminDisposition(String companyName) async {
    final adminInfo =
        await _callRestApi(_pathAdminDisposition, {'entp_name': companyName});
    return adminInfo;
  }

  static Future<List<dynamic>?> _callRestApi(String apiPath, Map query) async {
    final url = Uri(
      scheme: _scheme,
      host: _apiHostDataGoKr,
      path: apiPath,
      queryParameters: {
        'serviceKey': serviceKeyDataGoKr,
        'type': 'json',
        'pageNo': '1',
        'numOfRows': '100',
        ...query,
      },
    );

    final res = await http.get(url);
    // debugPrint('callRestApi.res.statusCode: ${res.statusCode}');
    // debugPrint('callRestApi.res.body: ${res.body}');
    if (res.statusCode != 200) {
      debugPrint('server responded: ${res.statusCode}');
      return null;
    }

    // debugPrint('res: ${res.body}');
    try {
      final header = jsonDecode(res.body)['header'];
      final body = jsonDecode(res.body)['body'];
      // debugPrint(header.toString());
      // debugPrint(body.toString());
      var result = <Map>[];
      if (header['resultCode'] == '00') {
        if (body['totalCount'] > 0) {
          for (final item in body['items']) {
            result.add(item);
          }
        }
        return result;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
