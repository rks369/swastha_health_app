import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/Bloc/breath_cubit.dart';
import 'package:swastha/firebase_options.dart';
import 'package:swastha/screens/authentication/user_detail.dart';
import 'package:swastha/screens/home.dart';
import 'package:swastha/screens/on_boarding.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) => AuthCubit())),
        BlocProvider(create: ((context) => BreathCubit())),
      ],
      child: MaterialApp(
        title: 'Swastha',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: ColoredBox(
            color: kWhite,
            child: SafeArea(child: child!),
          ),
        ),
        home: BlocBuilder<AuthCubit, Authstate>(
          buildWhen: (previous, current) =>
              previous == Authstate.init || previous == Authstate.loadFailed,
          builder: (context, state) {
            switch (state) {
              case Authstate.loggedIn:
                return const Home();
              case Authstate.loggedOut:
                return const OnBoardingScreen();
              case Authstate.unRegistered:
                return const UserDetail();
              case Authstate.loadFailed:
                return const _LoadFailed();
              default:
                return const Scaffold(
                  body: Center(
                    child: SpinKitFadingCube(color: kPrimaryColor),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 56, color: kPrimaryColor),
            const SizedBox(height: 16),
            const Text('Could not load your profile',
                style: kSubHeadingTextStyle),
            const SizedBox(height: 8),
            RoundedButton(
              title: 'Retry',
              colour: kPrimaryColor,
              onPressed: BlocProvider.of<AuthCubit>(context).retry,
            ),
          ],
        ),
      ),
    );
  }
}
