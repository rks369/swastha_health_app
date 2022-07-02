import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/profile_tile.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);

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
            'My Account',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage:
                        Image.network(blocProvider.userModel.profileURL).image,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    blocProvider.userModel.name,
                    style: kHeadingTextStyle,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    blocProvider.userModel.mobile,
                    style: kSubHeadingTextStyle,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: blocProvider.userModel.name,
                      ontap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "BMI: ${blocProvider.userModel.bmi}",
                      ontap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "Water Goal: ${blocProvider.userModel.goalWater}L",
                      ontap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "Step Goal: ${blocProvider.userModel.goalSteps}",
                      ontap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "Sleep Goal: ${blocProvider.userModel.goalSleep}h",
                      ontap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title:
                          "Calorie Goal: ${blocProvider.userModel.goalCalorie}",
                      ontap: () {},
                    ),
                  )
                ],
              ),
            ),
          )),
        ])),
      ),
    );
  }
}
