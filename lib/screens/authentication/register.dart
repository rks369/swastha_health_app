import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/authentication/user_detail.dart';
import 'package:swastha/screens/authentication/verify_otp.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/circular_login_component.dart';
import 'package:swastha/widgets/round_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController phone = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocConsumer<AuthCubit, Authstate>(
              listener: ((context, state) {
                if (state == Authstate.loggedIn) {
                  changeScreenClearStack(context, const Home());
                } else if (state == Authstate.otpSend) {
                  changeScreenReplacement(context, const VerifyOTP());
                } else if (state == Authstate.unRegistered) {
                  changeScreenReplacement(context, const UserDetail());
                } else if (state == Authstate.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(BlocProvider.of<AuthCubit>(context).error ??
                          'Something went wrong. Please try again.'),
                    ),
                  );
                }
              }),
              builder: (context, state) {
                final loading = state == Authstate.loading;
                return Column(
                  children: [
                    const Align(
                        alignment: Alignment.topLeft, child: BackButton()),
                    const SizedBox(height: 18),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Get Into Swastha',
                      style: kHeadingTextStyle,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Sign in to start your health journey',
                      style: kSubHeadingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15.0),
                        child: TextFormField(
                          controller: phone,
                          enabled: !loading,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter A Number';
                            }
                            if (value.length < 10) {
                              return 'Phone Number Should be 10 Digits';
                            }
                            return null;
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              prefixIcon: const Icon(
                                Icons.smartphone,
                                color: kPrimaryColor,
                              ),
                              counter: const Offstage(),
                              hintText: 'Enter Your Mobile Number',
                              labelText: 'Enter Your Mobile Number'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      const Text(
                        'Sign in with',
                        style: kSubHeadingTextStyle,
                      ),
                      Semantics(
                        button: true,
                        label: 'Sign in with Google',
                        child: CircularLoginOption(
                          icon: Image.asset('assets/images/google.png'),
                          onTap: BlocProvider.of<AuthCubit>(context)
                              .signInWithGoogle,
                        ),
                      ),
                      RoundedButton(
                          title: 'Continue',
                          colour: kPrimaryColor,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<AuthCubit>(context)
                                  .sendOTP('+91${phone.text}');
                            }
                          }),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
