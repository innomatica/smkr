import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/helpers.dart';

enum ActivityType {
  medication,
  measureBloodGlucoseLevel,
  measureBloodOxygenLevel,
  measureBloodPressureLevel,
  measureBodyTemperature,
  measureBodyWeight,
  exerciseWalking,
  exerciseHiking,
  exerciseSwimming,
  exerciseBicycling,
  activityOther,
}

List<ActivityType> measurementActivityTypes = [
  ActivityType.measureBloodGlucoseLevel,
  ActivityType.measureBloodOxygenLevel,
  ActivityType.measureBloodPressureLevel,
  ActivityType.measureBodyTemperature,
  ActivityType.measureBodyWeight,
];

List<ActivityType> exerciseActivityTypes = [
  ActivityType.exerciseWalking,
  ActivityType.exerciseHiking,
  ActivityType.exerciseSwimming,
  ActivityType.exerciseBicycling,
];

class Activity {
  int id;
  String activityName;
  ActivityType activityType;
  String frequency;
  Map<String, dynamic>? activityInfo;

  Activity({
    required this.id,
    required this.activityName,
    required this.activityType,
    required this.frequency,
    this.activityInfo,
  });

  factory Activity.fromDatabaseJson(Map<String, dynamic> data) {
    return Activity(
      id: data['id'],
      activityName: data['activityName'],
      activityType: ActivityType.values.elementAt(data['activityType']),
      frequency: data['frequency'],
      activityInfo: jsonDecode(data['activityInfo']),
    );
  }

  factory Activity.fromDocument(Map<String, dynamic> document) {
    return Activity(
      id: getDatabaseId(),
      activityName: document['activityName'],
      activityType: document['activityType'],
      frequency: document['frequency'],
      activityInfo: document['activityInfo'] ??
          activityData[document['activityType']]['info'],
    );
  }

  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'activityName': activityName,
      'activityType': activityType.index,
      'frequency': frequency,
      'activityInfo':
          activityInfo != null ? jsonEncode(activityInfo) : jsonEncode({}),
    };
  }

  @override
  String toString() {
    return toDatabaseJson().toString();
  }
}

Map<ActivityType, dynamic> activityData = {
  // ActivityType.medication: {
  //   'menu': '약먹기',
  //   'notification': '약먹을 시간입니다',
  // 'icon': const FaIcon(FontAwesomeIcons.pills),
  // },
  ActivityType.measureBloodPressureLevel: {
    'menu': '혈압 측정하기',
    'notification': '혈압 측정할 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.heartPulse),
    'unit': 'mmHg',
    'unitName': '혈압수치(mmHg)',
    'hint': '120,80',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.measureBodyTemperature: {
    'menu': '체온 측정하기',
    'notification': '체온 측정할 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.thermometer),
    'unit': '\u2103',
    'unitName': '체온(\u2103)',
    'hint': '36.5',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.measureBodyWeight: {
    'menu': '체중 측정하기',
    'notification': '체중 측정할 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.weightScale),
    'unit': 'Kg',
    'unitName': '체중(Kg)',
    'hint': '75.3',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.measureBloodGlucoseLevel: {
    'menu': '혈당 측정하기',
    'notification': '혈당 측정할 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.briefcaseMedical),
    'unit': 'mg/dl',
    'unitName': '혈당수치(mg/dl)',
    'hint': '100',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.exerciseWalking: {
    'menu': '산책하기',
    'notification': '산책 나갈 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.personWalking),
    'uint': '',
    'unitName': '',
    'hint': '',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.exerciseHiking: {
    'menu': '등산하기',
    'notification': '등산할 준비 되셨나요?',
    'icon': const FaIcon(FontAwesomeIcons.personHiking),
    'uint': '',
    'unitName': '',
    'hint': '',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.exerciseSwimming: {
    'menu': '수영하기',
    'notification': '수영하러 갈 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.personSwimming),
    'uint': '',
    'unitName': '',
    'hint': '',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.exerciseBicycling: {
    'menu': '자전거 타기',
    'notification': '자전거 타러 갈 시간입니다',
    'icon': const FaIcon(FontAwesomeIcons.personBiking),
    'uint': '',
    'unitName': '',
    'hint': '',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
  ActivityType.activityOther: {
    'menu': '기타',
    'notification': '기타',
    'icon': const FaIcon(FontAwesomeIcons.personSkiingNordic),
    'uint': '',
    'unitName': '',
    'hint': '',
    'info': <String, dynamic>{
      'test': 'test data',
    },
  },
};

Map<String, dynamic> activityTimes = {
  '하루 한번': {
    'timeStamps': [
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
    ],
    'timeMatch': DateTimeMatch.time,
  },
  '하루 두번': {
    'timeStamps': [
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
    ],
    'timeMatch': DateTimeMatch.time,
  },
  '하루 세번': {
    'timeStamps': [
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 9),
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 14),
      DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day, 21),
    ],
    'timeMatch': DateTimeMatch.time,
  },
  '일주일에 한번': {
    'timeStamps': [
      DateTime(
        // monday
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).day,
        9,
      ),
    ],
    'timeMatch': DateTimeMatch.dayOfWeekAndTime,
  },
  '일주일에 두번': {
    'timeStamps': [
      DateTime(
        // monday
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).day,
        9,
      ),
      DateTime(
        // thursday
        DateTime.now().add(Duration(days: 4 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 4 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 4 - DateTime.now().weekday)).day,
        9,
      ),
    ],
    'timeMatch': DateTimeMatch.dayOfWeekAndTime,
  },
  '일주일에 세번': {
    'timeStamps': [
      DateTime(
        // monday
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 1 - DateTime.now().weekday)).day,
        9,
      ),
      DateTime(
        // wednesday
        DateTime.now().add(Duration(days: 3 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 3 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 3 - DateTime.now().weekday)).day,
        9,
      ),
      DateTime(
        // friday
        DateTime.now().add(Duration(days: 5 - DateTime.now().weekday)).year,
        DateTime.now().add(Duration(days: 5 - DateTime.now().weekday)).month,
        DateTime.now().add(Duration(days: 5 - DateTime.now().weekday)).day,
        9,
      ),
    ],
    'timeMatch': DateTimeMatch.dayOfWeekAndTime,
  },
  '한달에 한번': {
    'timeStamps': [
      DateTime(DateTime.now().year, DateTime.now().month, 1, 9),
    ],
    'timeMatch': DateTimeMatch.dayOfMonthAndTime,
  },
  '한달에 두번': {
    'timeStamps': [
      DateTime(DateTime.now().year, DateTime.now().month, 1, 9),
      DateTime(DateTime.now().year, DateTime.now().month, 15, 9),
    ],
    'timeMatch': DateTimeMatch.dayOfMonthAndTime,
  },
  '한달에 세번': {
    'timeStamps': [
      DateTime(DateTime.now().year, DateTime.now().month, 1, 9),
      DateTime(DateTime.now().year, DateTime.now().month, 11, 9),
      DateTime(DateTime.now().year, DateTime.now().month, 21, 9),
    ],
    'timeMatch': DateTimeMatch.dayOfMonthAndTime,
  },
};

Map<String, int> activityAlarmInterval = {
  '하루 한번': 24,
  '하루 두번': 12,
  '하루 세번': 8,
  '일주일에 한번': 168,
  '일주일에 두번': 84,
  '일주일에 세번': 56,
  '한달에 한번': 720,
  '한달에 두번': 360,
  '한달에 세번': 240,
};

List<String> weekdayNames = ['일', '월', '화', '수', '목', '금', '토'];
