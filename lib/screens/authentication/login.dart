import 'package:flutter/material.dart';
import 'package:swastha/screens/home/physical_health.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/circular_login_component.dart';
import 'package:swastha/widgets/round_button.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const Align(alignment: Alignment.topLeft, child: BackButton()),
              const SizedBox(
                height: 18,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(
                height: 48.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextFormField(
                  onChanged: (value) {},
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
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
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                child: TextField(
                  obscureText: true,
                  onChanged: (value) {},
                  decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      hintText: 'Enter Your Password',
                      labelText: 'Enter Your Password'),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                "Sign in with",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularLoginOption(
                      icon: Image.asset('assets/images/google.png'),
                      onTap: () {
                        changeScreen(context, const PhysicalHealth());
                      },
                    ),
                    CircularLoginOption(
                      icon: Image.asset('assets/images/fb.jpg'),
                      onTap: () {
                        changeScreen(context, const PhysicalHealth());
                      },
                    ),
                    CircularLoginOption(
                      icon: Image.asset('assets/images/twitter.png'),
                      onTap: () {
                        changeScreen(context, const PhysicalHealth());
                      },
                    )
                  ],
                ),
              ),
              RoundedButton(
                  title: 'Continue',
                  colour: kPrimaryColor,
                  onPressed: () {
                    changeScreen(context, const PhysicalHealth());
                  })
            ],
          ),
        ),
      ),
    );
  }
}
