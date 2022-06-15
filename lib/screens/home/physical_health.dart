import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/screens/dashboards/calorie_dashboard.dart';
import 'package:swastha/screens/dashboards/sleep_dashboard.dart';
import 'package:swastha/screens/dashboards/steps_dashboard.dart';
import 'package:swastha/screens/dashboards/water_dashboard.dart';
import 'package:swastha/screens/home/add_water.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/dashboard_tile.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

double x = 0.0;
double y = 0.0;
double z = 0.0;

int steps = 0;
double previousDistacne = 0.0;
double distance = 0.0;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();

  return true;
}

void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually
  SharedPreferences preferences = await SharedPreferences.getInstance();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    previousDistacne = preferences.getDouble("preValue") ?? 0.0;
    double modDistance = magnitude - previousDistacne;
    preferences.setDouble("preValue", magnitude);
    return modDistance;
  }

  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    SensorsPlatform.instance.accelerometerEvents.listen((event) {
      x = event.x;
      y = event.y;
      z = event.z;
      distance = getValue(x, y, z);
      if (distance > 6) {
        steps++;
      }
      preferences.setInt('steps', steps);
    });

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Steps Count $steps",
        content: "Keep Moving",
      );
      service.setAsForegroundService();
    }

    /// you can see this log in logcat

    // test using external plugin
  });
}

class PhysicalHealth extends StatefulWidget {
  const PhysicalHealth({Key? key}) : super(key: key);

  @override
  State<PhysicalHealth> createState() => _PhysicalHealthState();
}

class _PhysicalHealthState extends State<PhysicalHealth> {
  @override
  void initState() {
    settaken();
    super.initState();
  }

  void settaken() async {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    List resList = await SQLHelper.getItem(
        DateFormat('dd/MM/yyyy').format(DateTime.now()));
    blocProvider.setWaterTaken(resList[0]['waterTaken'] * 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    double taken = blocProvider.waterModel.takenwater;
    taken = taken / 1000;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return const AddWater();
                });
          }),
      body: StreamBuilder<AccelerometerEvent>(
          stream: null,
          builder: (context, snapshot) {
            return Container(
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: SafeArea(
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Physical Health',
                    style: TextStyle(
                        color: kWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                          color: kGrey,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            color: kGrey,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.width / 2,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: SfRadialGauge(
                                      enableLoadingAnimation: true,
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                            startAngle: 90,
                                            endAngle: 90,
                                            canScaleToFit: false,
                                            minimum: 0,
                                            maximum: blocProvider
                                                    .waterModel.goalwater +
                                                0.1,
                                            showLabels: false,
                                            showTicks: false,
                                            axisLineStyle: AxisLineStyle(
                                              thickness: 0.1,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              color:
                                                  Colors.blue.withOpacity(0.3),
                                              thicknessUnit:
                                                  GaugeSizeUnit.factor,
                                            ),
                                            pointers: <GaugePointer>[
                                              RangePointer(
                                                value: taken + 0.0,
                                                cornerStyle:
                                                    CornerStyle.bothCurve,
                                                width: 0.1,
                                                sizeUnit: GaugeSizeUnit.factor,
                                                color: Colors.blue,
                                              ),
                                            ],
                                            annotations: <GaugeAnnotation>[
                                              GaugeAnnotation(
                                                positionFactor: 0.1,
                                                angle: 90,
                                                widget: Text('$steps/100',
                                                    style: kHeadingTextStyle
                                                        .copyWith(
                                                            color: Colors.blue,
                                                            fontSize: 24.0)),
                                              ),
                                            ]),
                                        RadialAxis(
                                          startAngle: 90,
                                          endAngle: 90,
                                          radiusFactor: .80,
                                          canScaleToFit: false,
                                          minimum: 0,
                                          maximum: 100.0,
                                          showLabels: false,
                                          showTicks: false,
                                          axisLineStyle: AxisLineStyle(
                                            thickness: 0.1,
                                            cornerStyle: CornerStyle.bothCurve,
                                            color:
                                                Colors.green.withOpacity(0.3),
                                            thicknessUnit: GaugeSizeUnit.factor,
                                          ),
                                          pointers: <GaugePointer>[
                                            RangePointer(
                                              value: steps * 1.0,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              width: 0.1,
                                              sizeUnit: GaugeSizeUnit.factor,
                                              color: Colors.green,
                                            ),
                                          ],
                                        )
                                      ]),
                                ),
                                InkWell(
                                  child: DashboardTile(
                                    icon: Icons.water_drop,
                                    title: "Water: ",
                                    rangeTitle:
                                        "${blocProvider.waterModel.takenwater / 1000}L/${blocProvider.waterModel.goalwater.toInt()}L",
                                    maxrange: blocProvider.waterModel.goalwater,
                                    interval:
                                        blocProvider.waterModel.goalwater / 3,
                                    valuerange:
                                        blocProvider.waterModel.takenwater /
                                            1000,
                                  ),
                                  onTap: () {
                                    changeScreen(
                                        context, const WaterDashboard());
                                  },
                                ),
                                InkWell(
                                  child: DashboardTile(
                                    icon: Icons.directions_run,
                                    title: "Steps: ",
                                    rangeTitle: "$steps/6000",
                                    maxrange: 100.0,
                                    interval: 2000.0,
                                    valuerange: steps * 1.0,
                                  ),
                                  onTap: () {
                                    changeScreen(context, StepDashboard());
                                  },
                                ),
                                InkWell(
                                  child: DashboardTile(
                                    icon: Icons.hotel,
                                    title: "Sleep: ",
                                    rangeTitle: "4h/9h",
                                    maxrange: 9.0,
                                    interval: 3.0,
                                    valuerange: 4.0,
                                  ),
                                  onTap: () {
                                    changeScreen(context, SleepDashboard());
                                  },
                                ),
                                InkWell(
                                  child: DashboardTile(
                                    icon: Icons.local_dining,
                                    title: "Calorie: ",
                                    rangeTitle: "2000/3000",
                                    maxrange: 3000.0,
                                    interval: 1000.0,
                                    valuerange: 2000.0,
                                  ),
                                  onTap: () {
                                    changeScreen(context, CalorieDashboard());
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            );
          }),
    );
  }
}
