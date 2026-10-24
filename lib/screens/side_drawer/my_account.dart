import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:swastha/widgets/profile_avatar.dart';
import 'package:swastha/widgets/round_button.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final AuthCubit cubit = BlocProvider.of<AuthCubit>(context);

  late final name = TextEditingController(text: cubit.userModel.name);
  late final waterGoal = TextEditingController(text: cubit.userModel.goalWater);
  late final stepGoal = TextEditingController(text: cubit.userModel.goalSteps);
  late final sleepGoal = TextEditingController(text: cubit.userModel.goalSleep);
  late final calorieGoal = TextEditingController(
    text: cubit.userModel.goalCalorie,
  );

  @override
  void dispose() {
    name.dispose();
    waterGoal.dispose();
    stepGoal.dispose();
    sleepGoal.dispose();
    calorieGoal.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    showProgressDialog(context);
    try {
      await cubit.updateUserDetails(
        name.text.trim(),
        cubit.userModel.bmi,
        waterGoal.text.trim(),
        stepGoal.text.trim(),
        sleepGoal.text.trim(),
        calorieGoal.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
      changeScreenClearStack(context, const Home());
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save changes. Try again.')),
      );
    }
  }

  Widget field(
    TextEditingController controller,
    String label, {
    bool number = true,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.name,
        inputFormatters: number
            ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))]
            : null,
        validator:
            validator ??
            (value) {
              final parsed = double.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return 'Please enter a valid $label';
              }
              return null;
            },
        decoration: kTextFieldDecoration.copyWith(
          hintText: 'Enter $label',
          label: Text(label),
          counter: const Offstage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = cubit.userModel;
    final dob = user.dobDate;

    return AppPage(
      title: 'My Account',
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              ProfileAvatar(name: user.name, url: user.profileURL, radius: 60),
              const SizedBox(height: 15.0),
              Text(user.name, style: kHeadingTextStyle),
              const SizedBox(height: 5.0),
              Text(user.mobile, style: kSubHeadingTextStyle),
              const SizedBox(height: 5.0),
              Text(
                [
                  user.gender,
                  if (dob != null) DateFormat('dd MMM yyyy').format(dob),
                  'BMI ${user.bmi}',
                ].join('  •  '),
                style: kNormalTextStyle,
              ),
              const SizedBox(height: 20.0),
              field(
                name,
                'Name',
                number: false,
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return 'Name should be at least 3 letters';
                  }
                  return null;
                },
              ),
              field(waterGoal, 'Water Goal (L)'),
              field(stepGoal, 'Step Goal'),
              field(sleepGoal, 'Sleep Goal (h)'),
              field(calorieGoal, 'Calorie Goal (kcal)'),
              RoundedButton(
                title: 'Save Changes',
                colour: kPrimaryColor,
                onPressed: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
