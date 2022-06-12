import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String RangeTitle;
  final double maxrange;
  final double interval;
  final double valuerange;
  const DashboardTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.RangeTitle,
      required this.maxrange,
      required this.interval,
      required this.valuerange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            RangeTitle,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 20),
                          ),
                        ],
                      ),
                      Container(
                        child: SfLinearGauge(
                            showTicks: false,
                            interval: interval,
                            minimum: 0.0,
                            maximum: maxrange,
                            orientation: LinearGaugeOrientation.horizontal,
                            animateAxis: true,
                            animateRange: true,
                            barPointers: [
                              LinearBarPointer(
                                thickness: 12,
                                value: valuerange,
                                color: kPrimaryColor,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                              )
                            ],
                            majorTickStyle: LinearTickStyle(length: 10),
                            axisLabelStyle:
                                TextStyle(fontSize: 12.0, color: Colors.black),
                            axisTrackStyle: LinearAxisTrackStyle(
                                color: kGrey,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                thickness: 15.0,
                                borderColor: Colors.grey)),
                        margin: EdgeInsets.all(10),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
