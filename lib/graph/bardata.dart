import 'package:flutter/material.dart';
import 'package:swastha/graph/data.dart';

class BarData {
  static int interval = 5;

  static List<Data> barData = const [
    Data(
      id: 0,
      name: 'Mon',
      y: 15,
      color: Color(0xff19bfff),
    ),
    Data(
      name: 'Tue',
      id: 1,
      y: 12,
      color: Color(0xffff4d94),
    ),
    Data(
      name: 'Wed',
      id: 2,
      y: 11,
      color: Color(0xff2bdb90),
    ),
    Data(
      name: 'Thu',
      id: 3,
      y: 10,
      color: Color(0xffffdd80),
    ),
    Data(
      name: 'Fri',
      id: 4,
      y: 5,
      color: Color(0xff2bdb90),
    ),
    Data(
      name: 'Sat',
      id: 5,
      y: 17,
      color: Color(0xffffdd80),
    ),
    Data(
      name: 'Sun',
      id: 6,
      y: 5,
      color: Color(0xffff4d94),
    ),
  ];
}
