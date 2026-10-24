import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/authentication/user_detail.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

class VerifyOTP extends StatefulWidget {
  static const String id = 'VerifyPassword';
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final TextEditingController otp = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(alignment: Alignment.topLeft, child: BackButton()),
                const SizedBox(height: 18),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verification',
                  style: kHeadingTextStyle,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Enter the 6-digit code we sent you',
                  style: kSubHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: TextFormField(
                      controller: otp,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.length != 6) {
                          return 'Enter the 6-digit code';
                        }
                        return null;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          counter: const Offstage(), labelText: 'OTP'),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                BlocConsumer<AuthCubit, Authstate>(
                  listener: ((context, state) {
                    if (state == Authstate.loggedIn) {
                      changeScreenClearStack(context, const Home());
                    } else if (state == Authstate.unRegistered) {
                      changeScreenReplacement(context, const UserDetail());
                    } else if (state == Authstate.error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              BlocProvider.of<AuthCubit>(context).error ??
                                  'Something went wrong. Please try again.'),
                        ),
                      );
                    }
                  }),
                  builder: ((context, state) {
                    if (state == Authstate.loading) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      );
                    }
                    return RoundedButton(
                        title: 'Verify',
                        colour: kPrimaryColor,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<AuthCubit>(context)
                                .verifyOTP(otp.text);
                          }
                        });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
