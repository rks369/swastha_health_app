import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swastha/screens/authentication/bmi_reg.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final TextEditingController name = TextEditingController(
    text: FirebaseAuth.instance.currentUser?.displayName ?? '',
  );
  final TextEditingController dobText = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DateTime? dob;
  String? gender;

  @override
  void dispose() {
    name.dispose();
    dobText.dispose();
    super.dispose();
  }

  Future<void> pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select Date of Birth',
    );
    if (picked == null) return;
    setState(() {
      dob = picked;
      dobText.text = DateFormat('dd MMM yyyy').format(picked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Align(alignment: Alignment.topLeft, child: BackButton()),
                const SizedBox(height: 18),
                Image.asset('assets/images/logo.png', width: 72, height: 72),
                const SizedBox(height: 24),
                const Text('Complete Registration', style: kHeadingTextStyle),
                const SizedBox(height: 8),
                const Text(
                  "Complete Your Profile",
                  style: kSubHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: TextFormField(
                          controller: name,
                          keyboardType: TextInputType.name,
                          onChanged: (value) {},
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Name';
                            }
                            if (value.length < 3) {
                              return 'Name Should Be At Least 3 Letters';
                            }
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: kSecondaryColor,
                            ),
                            hintText: 'Enter Your Name',
                            labelText: 'Enter Your Name',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: TextFormField(
                          controller: dobText,
                          readOnly: true,
                          onTap: pickDob,
                          validator: (value) {
                            if (dob == null)
                              return 'Please Select Your Date of Birth';
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                            prefixIcon: const Icon(
                              Icons.cake_outlined,
                              color: kSecondaryColor,
                            ),
                            hintText: 'Date of Birth',
                            labelText: 'Date of Birth',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      emptySelectionAllowed: true,
                      showSelectedIcon: false,
                      segments: const [
                        ButtonSegment(
                          value: 'Male',
                          icon: Icon(Icons.male),
                          label: Text('Male'),
                        ),
                        ButtonSegment(
                          value: 'Female',
                          icon: Icon(Icons.female),
                          label: Text('Female'),
                        ),
                      ],
                      selected: gender == null ? {} : {gender!},
                      onSelectionChanged: (value) => setState(
                        () => gender = value.isEmpty ? null : value.first,
                      ),
                    ),
                  ),
                ),
                RoundedButton(
                  title: 'Continue',
                  colour: kPrimaryColor,
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    if (gender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Select Your Gender'),
                        ),
                      );
                      return;
                    }
                    changeScreen(
                      context,
                      BMIReg(
                        name: name.text,
                        profileURL:
                            FirebaseAuth.instance.currentUser?.photoURL ?? '',
                        dob: dob!,
                        gender: gender!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
