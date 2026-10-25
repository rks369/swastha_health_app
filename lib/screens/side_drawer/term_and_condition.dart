import 'package:flutter/material.dart';
import 'package:swastha/widgets/legal_page.dart';

class TermAndCondtion extends StatelessWidget {
  const TermAndCondtion({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalPage(
      title: 'Terms & Conditions',
      updated: '25 October 2026',
      intro:
          'These are sample terms for Swastha and are placeholder text only. '
          'Replace them with your own reviewed terms before releasing the '
          'app publicly.',
      sections: [
        LegalSection(
          'Acceptance',
          'By creating an account or using Swastha you agree to these terms. '
              'If you do not agree, please do not use the app.',
        ),
        LegalSection(
          'Not medical advice',
          'Swastha is for general wellness tracking. BMI, goals and '
              'suggestions are estimates and are not a diagnosis or a '
              'substitute for advice from a doctor or other qualified health '
              'professional.',
        ),
        LegalSection(
          'Your account',
          'You are responsible for the accuracy of the details you enter and '
              'for keeping your sign-in secure. You must be old enough to '
              'use the app under the laws where you live.',
        ),
        LegalSection(
          'Acceptable use',
          'Do not misuse the app, attempt to break or reverse engineer it, '
              'or use it to harm others.',
        ),
        LegalSection(
          'Content and music',
          'The relaxing music and breathing guidance are provided for '
              'personal, non-commercial use only.',
        ),
        LegalSection(
          'Availability',
          'We may change, pause or stop features at any time. We do not '
              'guarantee that the app will always be available or error '
              'free.',
        ),
        LegalSection(
          'Limitation of liability',
          'To the extent allowed by law, Swastha is provided as is, and we '
              'are not liable for any loss arising from your use of the app.',
        ),
        LegalSection(
          'Changes to these terms',
          'We may update these terms from time to time. Continued use of the '
              'app after a change means you accept the updated terms.',
        ),
        LegalSection(
          'Contact',
          'support@example.com',
        ),
      ],
    );
  }
}
