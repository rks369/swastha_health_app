import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/database_helper.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/round_button.dart';

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
                // Slider(
                //     activeColor: kPrimaryColor,
                //     value: _taken.toDouble(),
                //     min: 0.0,
                //     max: 1000.0,
                //     onChanged: (value) {
                //       setState(() {
                //         //  blocProvider.setWaterTaken(_taken + 0.0);
                //         _taken = value.round();
                //       });
                //     })
              ],
            ),
            onPress: () {},
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.add_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken += 100;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const InkWell(
                  child: Icon(
                    Icons.local_drink,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text("100 ml"),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken -= 100;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.add_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken += 200;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const InkWell(
                  child: Icon(
                    Icons.local_drink,
                    color: Colors.blueAccent,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text("200 ml"),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken -= 200;
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: const Icon(
                    Icons.add_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken += 250;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const InkWell(
                  child: Icon(
                    Icons.local_drink,
                    color: Colors.blueAccent,
                    size: 60,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text("250 ml"),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.blueAccent,
                  ),
                  onTap: () {
                    setState(() {
                      _taken -= 250;
                    });
                  },
                ),
              ],
            ),
          ]),
          Center(
            child: RoundedButton(
                title: "Done",
                colour: kPrimaryColor,
                onPressed: () async {
                  int res = await SQLHelper.createItem(
                      _taken, DateFormat('dd/MM/yyyy').format(DateTime.now()));
                  print(res);
                  List resList = await SQLHelper.getItem(
                      DateFormat('dd/MM/yyyy').format(DateTime.now()));

                  blocProvider.setWaterTaken((resList[0]['waterTaken'] * 1.0));
                  print(resList);
                  // setState(() async {

                  //   blocProvider.setWaterTaken(
                  //       _taken + 0.0 + blocProvider.waterModel.takenwater);
                  //   await DataBaseHelper.instance
                  //       .insert({DataBaseHelper.columnname: _taken});
                  //   List<Map<String, dynamic>> queryrows =
                  //       await DataBaseHelper.instance.queryAll();
                  //   print(queryrows);
                  //   Navigator.pop(context);
                  //   Navigator.pop(context);
                  // });
                  changeScreen(context, const Home());
                }),
          ),
        ],
      ),
    );
  }
}
