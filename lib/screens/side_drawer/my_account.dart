import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/profile_tile.dart';
import 'package:swastha/widgets/round_button.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);
    final controller = TextEditingController();

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
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return editDialog(
                                  title: "Edit your name:",
                                  tlabel: "Name",
                                  onupdate: () {});
                            });
                      },
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
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return editDialog(
                                  title: "Edit your water goal (in L):",
                                  tlabel: "Water Goal",
                                  onupdate: () {});
                            });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "Step Goal: ${blocProvider.userModel.goalSteps}",
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return editDialog(
                                  title: "Edit your step goal:",
                                  tlabel: "Step Goal",
                                  onupdate: () {});
                            });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title: "Sleep Goal: ${blocProvider.userModel.goalSleep}h",
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return editDialog(
                                  title: "Edit your sleep goal (in h):",
                                  tlabel: "Sleep Goal",
                                  onupdate: () {});
                            });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: ProfileTile(
                      title:
                          "Calorie Goal: ${blocProvider.userModel.goalCalorie}",
                      ontap: () {
                        showDialog(
                            context: context,
                            builder: (builder) {
                              return editDialog(
                                  title: "Edit your calorie goal (in L):",
                                  tlabel: "Calorie Goal",
                                  onupdate: () {
                                    // FirebaseFirestore.instance
                                    //     .collection(blocProvider.userModel.uid)
                                    //     .doc()
                                    //     .update({
                                    //       'goalCalorie':
                                    //     });
                                  });
                            });
                      },
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

class editDialog extends StatelessWidget {
  final String title;
  final String tlabel;
  final onupdate;
  const editDialog(
      {Key? key,
      required this.title,
      required this.tlabel,
      required this.onupdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            decoration: kTextFieldDecoration.copyWith(
                label: Text(tlabel), counter: const Offstage()),
          ),
        ),
        Center(
          child: RoundedButton(
              title: "Update", colour: kPrimaryColor, onPressed: onupdate),
        )
      ],
    );
  }
}
