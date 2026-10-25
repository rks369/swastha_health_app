import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';

class LegalSection {
  final String title;
  final String body;

  const LegalSection(this.title, this.body);
}

class LegalPage extends StatelessWidget {
  final String title;
  final String updated;
  final String intro;
  final List<LegalSection> sections;

  const LegalPage({
    super.key,
    required this.title,
    required this.updated,
    required this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: title,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('Last updated: $updated', style: kNormalTextStyle),
          const SizedBox(height: 12),
          Text(intro, style: _bodyStyle),
          for (final section in sections) ...[
            const SizedBox(height: 24),
            Text(
              section.title,
              style: const TextStyle(
                color: kInk,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(section.body, style: _bodyStyle),
          ],
        ],
      ),
    );
  }

  static const _bodyStyle = TextStyle(
    color: kSecondaryColor,
    fontSize: 14,
    height: 1.5,
  );
}
