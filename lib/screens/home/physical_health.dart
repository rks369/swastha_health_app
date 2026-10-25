import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/models/metric.dart';
import 'package:swastha/screens/dashboards/metric_dashboard.dart';
import 'package:swastha/screens/home/physical/add_calories.dart';
import 'package:swastha/screens/home/physical/add_sleep.dart';
import 'package:swastha/screens/home/physical/add_water.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/services/step_tracker.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/dashboard_tile.dart';
import 'package:swastha/widgets/progress_rings.dart';

class PhysicalHealth extends StatefulWidget {
  const PhysicalHealth({super.key});

  @override
  State<PhysicalHealth> createState() => _PhysicalHealthState();
}

class _PhysicalHealthState extends State<PhysicalHealth> {
  bool loading = true;
  bool stepsAllowed = true;

  @override
  void initState() {
    super.initState();
    StepTracker.instance.steps.addListener(onSteps);
    loadData();
    startStepTracking();
  }

  @override
  void dispose() {
    StepTracker.instance.steps.removeListener(onSteps);
    super.dispose();
  }

  Future<void> loadData() async {
    final cubit = BlocProvider.of<AuthCubit>(context);
    final data = await cubit.getDataFromSQL();
    cubit.setDataModel(data);
    if (!mounted) return;
    setState(() => loading = false);
  }

  static bool _askedThisSession = false;

  Future<void> startStepTracking() async {
    final granted = await Permission.activityRecognition.isGranted;
    if (!granted && !_askedThisSession) {
      _askedThisSession = true;
      if (!mounted) return;
      final agreed = await showActivityPermissionDialog();
      if (!mounted) return;
      if (agreed != true) {
        setState(() => stepsAllowed = false);
        return;
      }
    }
    final allowed = await StepTracker.instance.start();
    if (!mounted) return;
    setState(() => stepsAllowed = allowed);
  }

  Future<bool?> showActivityPermissionDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.directions_run, color: kPrimaryColor, size: 32),
        title: const Text('Allow physical activity?'),
        content: const Text(
          'Swastha uses your phone\'s step sensor to count your daily steps. '
          'Your steps are stored only on this device.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }

  void onSteps() {
    if (!mounted) return;
    final cubit = BlocProvider.of<AuthCubit>(context);
    setState(() => cubit.dataModel.steps = StepTracker.instance.steps.value);
  }

  Future<void> showSheet(Widget sheet) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => sheet,
    );
    if (saved == true) await loadData();
  }

  SpeedDialChild sheetAction(IconData icon, String label, Widget sheet) {
    return SpeedDialChild(
      child: Icon(icon),
      foregroundColor: Colors.white,
      backgroundColor: kPrimaryColor,
      label: label,
      onPressed: () => showSheet(sheet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    final user = cubit.userModel;
    final data = cubit.dataModel;

    return AppPage(
      title: 'Physical Health',
      showBack: false,
      floatingActionButton: SpeedDial(
        closedForegroundColor: kWhite,
        openForegroundColor: kPrimaryColor,
        closedBackgroundColor: kPrimaryColor,
        openBackgroundColor: kWhite,
        labelsBackgroundColor: kWhite,
        labelsStyle: const TextStyle(color: kInk, fontWeight: FontWeight.w500),
        speedDialChildren: [
          sheetAction(Icons.water_drop, 'Add Water', const AddWater()),
          sheetAction(Icons.hotel, 'Add Sleep', const AddSleep()),
          sheetAction(Icons.local_dining, 'Add Calories', const AddCalories()),
        ],
        child: const Icon(Icons.add),
      ),
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
              child: Column(
                children: [
                  if (!stepsAllowed) stepPermissionBanner(),
                  ProgressRings(data: data, user: user),
                  const SizedBox(height: 8),
                  for (final metric in Metric.values)
                    DashboardTile(
                      metric: metric,
                      value: metric.today(data),
                      goal: metric.goal(user),
                      onTap: () => changeScreen(
                        context,
                        MetricDashboard(metric: metric),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget stepPermissionBanner() {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: ListTile(
        leading: const Icon(Icons.directions_run, color: kPrimaryColor),
        title: const Text(
          'Allow activity recognition to count your steps',
          style: TextStyle(fontSize: 14),
        ),
        trailing: TextButton(
          onPressed: () async {
            final granted = await StepTracker.instance.start();
            if (!granted) await openAppSettings();
            if (!mounted) return;
            setState(() => stepsAllowed = granted);
          },
          child: const Text('Allow'),
        ),
      ),
    );
  }
}
