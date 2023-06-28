import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/drug.dart';
import '../models/schedule.dart';
import '../services/notification.dart';
import '../services/sqlite.dart';
import '../shared/settings.dart';

class DrugBloc extends ChangeNotifier {
  final _db = SqliteService();
  final _ns = NotificationService();

  List<Drug> _drugs = <Drug>[];

  DrugBloc() {
    refresh();
  }

  List<Drug> get drugs {
    return _drugs;
  }

  Future refresh() async {
    _drugs = await _db.getDrugs();
    notifyListeners();
  }

  //
  // Drug
  //
  Future add(Drug drug) async {
    await _db.addDrug(drug);
    refresh();
  }

  Future update(Drug drug) async {
    await _db.updateDrug(drug);
    refresh();
  }

  Future delete(Drug drug) async {
    final schedule = await getSchedule(drug);
    if (schedule != null) {
      await _ns.cancelScheduleNotifications(schedule);
    }
    await _db.deleteScheduleById(drug.id);
    await _db.deleteDrugById(drug.id);
    refresh();
  }

  Future<List<Drug>> getDrugs() async {
    final drugs = await _db.getDrugs();
    return drugs;
  }

  //
  // Schedule belongs to drugs
  //
  Future addSchedule(Schedule schedule) async {
    await _db.addSchedule(schedule);
    useInboxNotification
        ? await _ns.scheduleInboxNotifications(schedule)
        : await _ns.scheduleNotifications(schedule);
    refresh();
  }

  Future updateSchedule(Schedule schedule) async {
    await _db.updateSchedule(schedule);
    useInboxNotification
        ? await _ns.scheduleInboxNotifications(schedule)
        : await _ns.scheduleNotifications(schedule);
    refresh();
  }

  Future deleteSchedule(Schedule schedule) async {
    await _ns.cancelScheduleNotifications(schedule);
    await _db.deleteScheduleById(schedule.id);
    refresh();
  }

  Future<Schedule?> getSchedule(Drug drug) async {
    final schedule = await _db.getScheduleById(drug.id);
    return schedule;
  }
}
