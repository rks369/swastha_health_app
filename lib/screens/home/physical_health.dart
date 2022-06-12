import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/home/add_water.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/dashboard_tile.dart';
import 'package:swastha/widgets/round_button.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PhysicalHealth extends StatefulWidget {
  const PhysicalHealth({Key? key}) : super(key: key);

  @override
  State<PhysicalHealth> createState() => _PhysicalHealthState();
}

class _PhysicalHealthState extends State<PhysicalHealth> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  double miles = 0.0;
  double duration = 0.0;
  double calories = 0.0;
  double addValue = 0.025;
  int steps = 0;
  double previousDistacne = 0.0;
  double distance = 0.0;
  @override
  void initState() {
    // TODO: implement initState
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
    return StreamBuilder<AccelerometerEvent>(
        stream: SensorsPlatform.instance.accelerometerEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            x = snapshot.data!.x;
            y = snapshot.data!.y;
            z = snapshot.data!.z;
            distance = getValue(x, y, z);
            if (distance > 6) {
              steps++;
            }
            calories = calculateCalories(steps);
            duration = calculateDuration(steps);
            miles = calculateMiles(steps);
          }
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
                      color: kWhite, fontSize: 20, fontWeight: FontWeight.bold),
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
                                            cornerStyle: CornerStyle.bothCurve,
                                            color: Colors.blue.withOpacity(0.3),
                                            thicknessUnit: GaugeSizeUnit.factor,
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
                                            )
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
                                          color: Colors.green.withOpacity(0.3),
                                          thicknessUnit: GaugeSizeUnit.factor,
                                        ),
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: steps * 1.0,
                                            cornerStyle: CornerStyle.bothCurve,
                                            width: 0.1,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            color: Colors.green,
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              Text(
                                  "taken : ${blocProvider.waterModel.takenwater}"),
                              Text(
                                  " Goal: ${blocProvider.waterModel.goalwater}"),
                              RoundedButton(
                                  title: 'Add Water',
                                  colour: kPrimaryColor,
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (builder) {
                                          return const AddWater();
                                        });
                                  }),
                              RoundedButton(
                                  title: 'Set Goal',
                                  colour: kPrimaryColor,
                                  onPressed: () {
                                    showBottomSheet(
                                        context: context,
                                        builder: (builder) {
                                          return const SetWaterGoal();
                                        });
                                  }),
                              DashboardTile(
                                icon: Icons.water_drop,
                                title: "Water: ",
                                RangeTitle:
                                    "${blocProvider.waterModel.takenwater / 1000}L/${blocProvider.waterModel.goalwater.toInt()}L",
                                maxrange: blocProvider.waterModel.goalwater,
                                interval: blocProvider.waterModel.goalwater / 3,
                                valuerange:
                                    blocProvider.waterModel.takenwater / 1000,
                              ),
                              DashboardTile(
                                icon: Icons.directions_run,
                                title: "Steps: ",
                                RangeTitle: "1000/6000",
                                maxrange: 6000.0,
                                interval: 2000.0,
                                valuerange: 1000.0,
                              ),
                              DashboardTile(
                                icon: Icons.hotel,
                                title: "Sleep: ",
                                RangeTitle: "3h/9h",
                                maxrange: 9.0,
                                interval: 3.0,
                                valuerange: 3.0,
                              ),
                              DashboardTile(
                                icon: Icons.hotel,
                                title: "Calorie: ",
                                RangeTitle: "2000/3000",
                                maxrange: 3000.0,
                                interval: 1000.0,
                                valuerange: 2000.0,
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
        });
  }

  double getValue(double x, double y, double z) {
    double magnitude = sqrt(x * x + y * y + z * z);
    getPreviousValue();
    double modDistance = magnitude - previousDistacne;
    setPreviousValue(magnitude);
    return modDistance;
  }

  void setPreviousValue(double distance) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble("preValue", distance);
  }

  void getPreviousValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      previousDistacne = pref.getDouble("preValue") ?? 0.0;
    });
  }

  // void calculate data
  double calculateMiles(int steps) {
    double milesValue = (2.2 * steps) / 5280;
    return milesValue;
  }

  double calculateDuration(int steps) {
    double durationValue = (steps * 1 / 1000);
    return durationValue;
  }

  double calculateCalories(int steps) {
    double caloriesValue = (steps * 0.0566);
    return caloriesValue;
  }
}

class SetWaterGoal extends StatefulWidget {
  const SetWaterGoal({Key? key}) : super(key: key);

  @override
  State<SetWaterGoal> createState() => _SetWaterGoalState();
}

class _SetWaterGoalState extends State<SetWaterGoal> {
  int _goal = 3;
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    return Container(
      color: kWhite,
      height: 350,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Enter Amount of Water: ",
            style: kSubHeadingTextStyle,
          ),
          UserCard(
            colour: kWhite,
            cardChild: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Amount (in L)",
                  style: TextStyle(fontSize: 20.0, color: kPrimaryColor),
                ),
                Text(
                  _goal.toString(),
                  style: const TextStyle(fontSize: 15.0, color: kPrimaryColor),
                ),
                Slider(
                    activeColor: kPrimaryColor,
                    value: _goal.toDouble(),
                    min: 0.0,
                    max: 10.0,
                    onChanged: (value) {
                      setState(() {
                        // blocProvider.setWaterGoal(_goal + 0.0);
                        _goal = value.round();
                      });
                    })
              ],
            ),
            onPress: () {},
          ),
          Center(
            child: RoundedButton(
                title: "Done",
                colour: kPrimaryColor,
                onPressed: () {
                  setState(() {
                    blocProvider.setWaterGoal(_goal + 0.0);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                  changeScreen(context, const Home());
                }),
          ),
          Center(
            child: RoundedButton(
                title: "Exit",
                colour: kPrimaryColor,
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
