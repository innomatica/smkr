import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/activity.dart';
import '../../models/activity.dart';
import '../../models/schedule.dart';
import 'activity_alarm.dart';
import 'activity_details.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  ActivityType? _value;

  void _addActivity() async {
    final dropdownItems = <DropdownMenuItem<ActivityType>>[];
    for (final key in activityData.keys) {
      if ((key != ActivityType.medication) &&
          (key != ActivityType.activityOther)) {
        dropdownItems.add(DropdownMenuItem(
          value: key,
          child: Text(activityData[key]['menu']),
        ));
      }
    }

    await showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      context: context,
      builder: (context) {
        final activityBloc = context.read<ActivityBloc>();
        return StatefulBuilder(builder: (context, setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20.0),
              DropdownButton<ActivityType>(
                hint: const Text('할 일을 선택해 주세요'),
                value: _value,
                items: dropdownItems,
                onChanged: (ActivityType? selected) {
                  setModalState(() {
                    _value = selected;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 200.0,
                child: OutlinedButton(
                  onPressed: () {
                    if (_value != null) {
                      activityBloc.add(
                        Activity.fromDocument({
                          'activityName': activityData[_value]['menu'],
                          'activityType': _value!,
                          'frequency': activityTimes.entries.first.key,
                        }),
                      );
                      Navigator.pop(context);
                    }
                    _value = null;
                  },
                  child: const Text('할 일 등록'),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          );
        });
      },
    );
  }

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
                ' 으로 할 일을 등록하세요',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
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
          const SizedBox(height: 8.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('    \u2731   '),
              const Text('할 일 이름을'),
              Text(
                ' 길~게 ',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              const Text('누르면 삭제할 수 있어요'),
            ],
          ),
        ],
      ),
    );
  }

  Schedule _getDefaultSchedule(Activity activity) {
    return Schedule(
      id: activity.id,
      activityId: activity.id,
      activityType: activity.activityType,
      scheduleInfo: {
        'activityName': activity.activityName,
        'alarmInterval': activityAlarmInterval[activity.frequency],
      },
      alarmTimes: activityTimes[activity.frequency]['timeStamps'],
      alarmMatch: activityTimes[activity.frequency]['timeMatch'],
    );
  }

  Offset _tapOffset = Offset.zero;

  _onTapDown(TapDownDetails details) {
    _tapOffset = details.globalPosition;
  }

  Widget _buildActivityCard(Activity activity) {
    final activityBloc = context.read<ActivityBloc>();
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
              onTap: () => activityBloc.delete(activity),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.secondary,
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
          leading: activityData[activity.activityType]['icon'],
          title: Text(activity.activityName),
          subtitle: Text(activity.frequency),
          trailing: IconButton(
            icon: Icon(Icons.alarm,
                color: Theme.of(context).colorScheme.tertiary),
            onPressed: () async {
              final schedule = await activityBloc.getSchedule(activity) ??
                  _getDefaultSchedule(activity);

              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityAlarm(
                    activity: activity,
                    schedule: schedule,
                  ),
                ),
              );
            },
          ),
          onTap: () {
            if (measurementActivityTypes.contains(activity.activityType)) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityDetails(activity: activity),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityBloc>().activities;

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: activities.isEmpty
            ? _buildInstruction()
            : ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) =>
                    _buildActivityCard(activities[index]),
              ),
      ),
      Positioned.fill(
        bottom: 16.0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: _addActivity,
            child: const Text(
              '+',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
          ),
        ),
      ),
    ]);
  }
}
