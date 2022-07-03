import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/screens/home/physical_health.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';
import 'package:swastha/widgets/round_button.dart';

class AddCalories extends StatefulWidget {
  const AddCalories({Key? key}) : super(key: key);

  @override
  State<AddCalories> createState() => _AddCaloriesState();
}

class _AddCaloriesState extends State<AddCalories> {
  int _taken = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);

    return Container(
      color: kWhite,
      height: 450,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Enter Amount of Calories : ",
            style: kSubHeadingTextStyle,
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  initialValue: '0',
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Enter Caloreis', hintText: 'Caloreis'),
                  onChanged: (value) {
                    _taken = int.parse(value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "It Can't Be Empty";
                    } else if (value.length > 3) {
                      return 'it must me less than 999';
                    } else {
                      return null;
                    }
                  },
                ),
              )),
          Center(
            child: RoundedButton(
                title: "Done",
                colour: kPrimaryColor,
                onPressed: () async {
                  // List resList = await SQLHelper.getItem(
                  //     DateFormat('dd/MM/yyyy').format(DateTime.now()));

                  // blocProvider.setWaterTaken((resList[0]['waterTaken'] * 1.0));
                  if (_formKey.currentState!.validate()) {
                    print(_taken);
                    setState(() async {
                      await SQLHelper.insertData(DataModel(
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          0,
                          _taken,
                          0,
                          0));
                      final result = await SQLHelper.getItems();
                      changeScreenReplacement(context, PhysicalHealth());
                    });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
