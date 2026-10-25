import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/app_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Resources',
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ResrouceTile(
            title: "National Mental Health Program",
            link: "www.nhp.gov.in",
            ontap: () {
              launchUrl(
                Uri.parse(
                  "https://www.nhp.gov.in/national-mental-health-programme_pg",
                ),
              );
            },
          ),
          ResrouceTile(
            title: "Very Well Mind",
            link: "www.verywellmind.com",
            ontap: () {},
          ),
          ResrouceTile(
            title: "Better Help",
            link: "www.betterhelp.com",
            ontap: () {},
          ),
          ResrouceTile(
            title: "Calm Sage",
            link: "www.calmsage.com",
            ontap: () {},
          ),
        ],
      ),
    );
  }
}

class ResrouceTile extends StatelessWidget {
  final String title;
  final String link;
  final Function()? ontap;
  const ResrouceTile({
    super.key,
    required this.title,
    required this.link,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: ontap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.language,
                    color: kPrimaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: kInk,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(link, style: kNormalTextStyle),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_outward,
                  color: kSecondaryColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
