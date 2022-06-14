import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/round_button.dart';

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
