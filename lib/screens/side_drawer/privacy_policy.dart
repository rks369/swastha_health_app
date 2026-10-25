import 'package:flutter/material.dart';
import 'package:swastha/widgets/legal_page.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(
      title: 'Privacy Policy',
      updated: '25 October 2026',
      intro:
          'This is a sample privacy policy for Swastha and is placeholder '
          'text only. Replace it with your own reviewed policy before '
          'releasing the app publicly.',
      sections: [
        LegalSection(
          'Information we collect',
          'When you sign up we collect your phone number or Google account '
              'details, your name, date of birth and gender. When you use the '
              'app we store the height, weight, water, sleep, calorie and '
              'step values you enter or that your phone records.',
        ),
        LegalSection(
          'How we use it',
          'Your information is used to show your daily progress, set '
              'suggested goals, calculate your BMI and display your history. '
              'We do not use it for advertising.',
        ),
        LegalSection(
          'Where it is stored',
          'Your profile and weight history are stored in Google Firebase '
              '(Authentication and Cloud Firestore). Daily water, sleep, '
              'calorie and step logs are stored on your device.',
        ),
        LegalSection(
          'Step counting',
          'Swastha asks for the Activity Recognition permission to read your '
              'phone\'s step sensor. You can deny or revoke it at any time in '
              'your phone settings; step counting will then stop.',
        ),
        LegalSection(
          'Sharing',
          'We do not sell your personal information. Data is shared only '
              'with the service providers needed to run the app, such as '
              'Firebase, or when the law requires it.',
        ),
        LegalSection(
          'BMI for other people',
          'Values you enter when calculating BMI for someone else are used '
              'only to show the result and are not saved.',
        ),
        LegalSection(
          'Your choices',
          'You can edit your name and goals in My Account. To delete your '
              'account and data, contact us at the address below.',
        ),
        LegalSection(
          'Contact',
          'support@example.com',
        ),
      ],
    );
  }
}
