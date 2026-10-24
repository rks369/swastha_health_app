import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swastha/database/sql_helper.dart';

/// Counts today's steps from the hardware step counter.
///
/// The sensor reports steps since boot, so a per-day baseline is kept in the
/// database. Steps taken while the app was closed are picked up on the next
/// event because the sensor keeps counting.
class StepTracker {
  StepTracker._();
  static final StepTracker instance = StepTracker._();

  static const _dateKey = 'step_date';
  static const _baseKey = 'step_base';

  final ValueNotifier<int> steps = ValueNotifier<int>(0);
  StreamSubscription<StepCount>? _subscription;
  Future<void> _queue = Future.value();

  Future<bool> start() async {
    if (_subscription != null) return true;

    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) return false;

    _subscription = Pedometer.stepCountStream.listen(
      (event) => _queue = _queue.then((_) => _onStepCount(event)),
      onError: (Object error) => debugPrint('Step counter error: $error'),
    );
    return true;
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _onStepCount(StepCount event) async {
    final total = event.steps;
    final today = SQLHelper.todayKey();

    final storedDate = await SQLHelper.getMeta(_dateKey);
    var base = int.tryParse(await SQLHelper.getMeta(_baseKey) ?? '') ?? total;

    if (storedDate != today) {
      base = total;
    } else if (total < base) {
      // The counter reset after a reboot; keep what was already counted today.
      final saved =
          (await SQLHelper.getTodayData()).first['steps'] as int? ?? 0;
      base = total - saved;
    }

    await SQLHelper.setMeta(_dateKey, today);
    await SQLHelper.setMeta(_baseKey, base.toString());

    final todaySteps = total - base;
    await SQLHelper.setSteps(todaySteps);
    steps.value = todaySteps;
  }
}
