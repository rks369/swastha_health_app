import 'package:flutter/material.dart';
import 'package:swastha/models/on_boarding_slider.dart';
import 'package:swastha/screens/authentication/register.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';
import 'package:swastha/widgets/slide_tile.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String id = 'OnBoardingScreen';
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<SliderModel> slides = [];
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: slides.length,
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          itemBuilder: (context, index) {
            return SlideTile(
                imageAssetPath: slides[index].imageAssetPath,
                title: slides[index].title,
                description: slides[index].description);
          }),
      bottomSheet: SizedBox(
        height: 160,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < slides.length; i++)
                  currentIndex == i
                      ? pageIndexIndicator(true)
                      : pageIndexIndicator(false)
              ],
            ),
            RoundedButton(
              title: currentIndex != slides.length - 1 ? 'Next' : 'Get Started',
              colour: kPrimaryColor,
              onPressed: () {
                if (currentIndex != slides.length - 1) {
                  pageController.animateToPage(currentIndex + 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                } else {
                  changeScreen(context, const Register());
                }
              },
            ),
            GestureDetector(
              child: Text(
                currentIndex == 0 ? 'Skip' : 'Back',
                textAlign: TextAlign.center,
                style: kLinkTextStyle,
              ),
              onTap: () {
                if (currentIndex == 0) {
                  pageController.animateToPage(slides.length - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                } else {
                  pageController.animateToPage(currentIndex - 1,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an Account ? ',
                  style: kNormalTextStyle,
                ),
                GestureDetector(
                  child: const Text('Sign in', style: kLinkTextStyle),
                  onTap: () {
                    changeScreen(context, const Register());
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 6.0,
      width: isCurrentPage ? 20.0 : 6.0,
      decoration: BoxDecoration(
          color: isCurrentPage ? kPrimaryColor : kBorder,
          borderRadius: BorderRadius.circular(6)),
    );
  }
}
