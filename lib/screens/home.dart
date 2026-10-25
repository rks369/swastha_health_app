import 'package:flutter/material.dart';
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
import 'package:swastha/widgets/bottom_switch.dart';
import 'package:swastha/widgets/profile_avatar.dart';
import 'package:swastha/widgets/drawer_list_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = [const PhysicalHealth(), const MentalHealth()];

  void openFromDrawer(Widget screen) {
    Navigator.pop(context);
    changeScreen(context, screen);
  }

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: kWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
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
                Text(blocProvider.userModel.mobile, style: kNormalTextStyle),
                const SizedBox(height: 20.0),
                const Divider(),
                DrawerListTile(
                  title: 'My Account',
                  icon: Icons.person_outline,
                  onPress: () => openFromDrawer(const MyAccount()),
                ),
                DrawerListTile(
                  title: 'BMI Calculator',
                  icon: Icons.monitor_heart_outlined,
                  onPress: () => openFromDrawer(const BMICalculator()),
                ),
                DrawerListTile(
                  title: 'Weight & BMI History',
                  icon: Icons.show_chart,
                  onPress: () => openFromDrawer(const WeightHistory()),
                ),
                DrawerListTile(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onPress: () => openFromDrawer(const PrivacyPolicy()),
                ),
                DrawerListTile(
                  title: 'Term & Conditions',
                  icon: Icons.description_outlined,
                  onPress: () => openFromDrawer(const TermAndCondtion()),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        heroTag: null,
        tooltip: 'Menu',
        backgroundColor: kWhite,
        shape: const CircleBorder(side: BorderSide(color: kBorder)),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
        child: const Icon(Icons.menu, color: kInk),
      ),
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Center(
          heightFactor: 1,
          child: BottomSwitch(
            currentIndex: index,
            onTap: (value) => setState(() => index = value),
            items: const [
              BottomSwitchItem(icon: Icons.fitness_center, label: 'Physical'),
              BottomSwitchItem(icon: Icons.psychology_outlined, label: 'Mental'),
            ],
          ),
        ),
      ),
    );
  }
}
