import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/round_button.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PhysicalHealth extends StatelessWidget {
  const PhysicalHealth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    double _taken = blocProvider.waterModel.takenwater;
    _taken = _taken / 1000;
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
                                    maximum:
                                        blocProvider.waterModel.goalwater + 0.1,
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
                                        value: _taken + 0.0,
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.1,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        color: Colors.blue,
                                      ),
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        positionFactor: 0.1,
                                        angle: 90,
                                        widget: Text('50/100',
                                            style: kHeadingTextStyle.copyWith(
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
                                  pointers: const <GaugePointer>[
                                    RangePointer(
                                      value: 75,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.1,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: Colors.green,
                                    ),
                                  ],
                                )
                              ]),
                        ),
                        Text("taken : ${blocProvider.waterModel.takenwater}"),
                        Text(" Goal: ${blocProvider.waterModel.goalwater}"),
                        RoundedButton(
                            title: 'Add Water',
                            colour: kPrimaryColor,
                            onPressed: () {
                              showBottomSheet(
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
                            })
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

class AddWater extends StatefulWidget {
  const AddWater({Key? key}) : super(key: key);

  @override
  State<AddWater> createState() => _AddWaterState();
}

class _AddWaterState extends State<AddWater> {
  int _taken = 0;
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
                  "Amount (in ML)",
                  style: TextStyle(fontSize: 20.0, color: kPrimaryColor),
                ),
                Text(
                  _taken.toString(),
                  style: const TextStyle(fontSize: 15.0, color: kPrimaryColor),
                ),
                Slider(
                    activeColor: kPrimaryColor,
                    value: _taken.toDouble(),
                    min: 0.0,
                    max: 1000.0,
                    onChanged: (value) {
                      setState(() {
                        //  blocProvider.setWaterTaken(_taken + 0.0);
                        _taken = value.round();
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
                    blocProvider.setWaterTaken(
                        _taken + 0.0 + blocProvider.waterModel.takenwater);
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
