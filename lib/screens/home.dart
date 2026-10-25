import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swastha/Bloc/auth_cubit.dart';
import 'package:swastha/screens/authentication/register.dart';
import 'package:swastha/screens/home/mental_health.dart';
import 'package:swastha/screens/home/physical_health.dart';
import 'package:swastha/screens/side_drawer/bmi_calculator.dart';
import 'package:swastha/screens/side_drawer/my_account.dart';
import 'package:swastha/screens/side_drawer/privacy_policy.dart';
import 'package:swastha/screens/side_drawer/weight_history.dart';
import 'package:swastha/screens/side_drawer/term_and_condition.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/profile_avatar.dart';
import 'package:swastha/widgets/drawer_list_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final advancedDrawerController = AdvancedDrawerController();

  @override
  void dispose() {
    advancedDrawerController.dispose();
    super.dispose();
  }

  final List<Widget> pages = [const PhysicalHealth(), const MentalHealth()];
  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);

    return AdvancedDrawer(
      backdropColor: kSurface,
      controller: advancedDrawerController,
      drawer: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                ProfileAvatar(
                  name: blocProvider.userModel.name,
                  url: blocProvider.userModel.profileURL,
                  radius: 48,
                ),
                const SizedBox(height: 16.0),
                Text(
                  blocProvider.userModel.name,
                  style: kHeadingTextStyle.copyWith(fontSize: 22.0),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'BMI ${blocProvider.userModel.bmi}',
                  style: kSubHeadingTextStyle,
                ),
                const SizedBox(height: 2.0),
                Text(
                  blocProvider.userModel.mobile,
                  style: kNormalTextStyle,
                ),
                const SizedBox(height: 20.0),
                const Divider(),
                DrawerListTile(
                  title: 'My Account',
                  icon: Icons.person_outline,
                  onPress: () {
                    changeScreen(context, const MyAccount());
                  },
                ),
                DrawerListTile(
                  title: 'BMI Calculator',
                  icon: Icons.monitor_heart_outlined,
                  onPress: () {
                    changeScreen(context, const BMICalculator());
                  },
                ),
                DrawerListTile(
                  title: 'Weight & BMI History',
                  icon: Icons.show_chart,
                  onPress: () {
                    changeScreen(context, const WeightHistory());
                  },
                ),
                DrawerListTile(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onPress: () {
                    changeScreen(context, const PrivacyPolicy());
                  },
                ),
                DrawerListTile(
                  title: 'Term & Conditions',
                  icon: Icons.description_outlined,
                  onPress: () {
                    changeScreen(context, const TermAndCondtion());
                  },
                ),
                BlocConsumer<AuthCubit, Authstate>(
                  listener: (context, state) {
                    if (state == Authstate.loggedOut) {
                      changeScreenReplacement(context, const Register());
                    }
                  },
                  builder: (context, state) {
                    if (state == Authstate.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return DrawerListTile(
                      title: 'Logout',
                      icon: Icons.logout,
                      onPress: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Log out?'),
                            content: const Text(
                              'You will need to sign in again.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Log out'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) blocProvider.logOut();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          heroTag: null,
          tooltip: 'Menu',
          backgroundColor: kWhite,
          shape: const CircleBorder(side: BorderSide(color: kBorder)),
          onPressed: () {
            advancedDrawerController.showDrawer();
          },
          child: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: advancedDrawerController,
            builder: (_, value, _) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  color: kInk,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          onTap: ((value) {
            setState(() {
              index = value;
            });
          }),
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Physical',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology_outlined),
              activeIcon: Icon(Icons.psychology),
              label: 'Mental',
            ),
          ],
        ),
      ),
    );
  }
}
