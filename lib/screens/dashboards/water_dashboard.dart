import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/graph/barchartwidget.dart';
import 'package:swastha/screens/home/physical/set_water_goal.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WaterDashboard extends StatefulWidget {
  const WaterDashboard({Key? key}) : super(key: key);

  @override
  State<WaterDashboard> createState() => _WaterDashboardState();
}

class _WaterDashboardState extends State<WaterDashboard> {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          backgroundColor: kWhite,
          mini: true,
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          )),
      body: Container(
        decoration: const BoxDecoration(color: kPrimaryColor),
        child: SafeArea(
            child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Water Dashboard',
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
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: SizedBox(
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
                              maximum:
                                  int.parse(blocProvider.userModel.goalWater) +
                                      0.0,
                              showLabels: false,
                              showTicks: false,
                              axisLineStyle: AxisLineStyle(
                                thickness: 0.2,
                                cornerStyle: CornerStyle.bothCurve,
                                color: Colors.blue.withOpacity(0.3),
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  value: taken + 0.0,
                                  cornerStyle: CornerStyle.bothCurve,
                                  width: 0.2,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: Colors.blue,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  positionFactor: 0.1,
                                  angle: 90,
                                  widget: Text(
                                      '${taken}/${blocProvider.userModel.goalWater}L',
                                      style: kHeadingTextStyle.copyWith(
                                          color: Colors.blue, fontSize: 24.0)),
                                ),
                              ]),
                        ]),
                  ),
                ),
                const Text(
                  "Weekly Static:",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 300,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    color: const Color(0xff020227),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: BarChartWidget(),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ])),
      ),
    );
  }
}
