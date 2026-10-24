import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

/// Profile photo, falling back to the user's initials.
class ProfileAvatar extends StatefulWidget {
  final String name;
  final String url;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.name,
    required this.url,
    this.radius = 40,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool imageFailed = false;

  String get initials {
    final parts = widget.name.trim().split(RegExp(r'\s+'));
    if (parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.url.isNotEmpty && !imageFailed;
    return Semantics(
      label: 'Profile picture of ${widget.name}',
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: kPrimaryColor,
        backgroundImage: hasImage ? NetworkImage(widget.url) : null,
        onBackgroundImageError: hasImage
            ? (_, _) => setState(() => imageFailed = true)
            : null,
        child: hasImage
            ? null
            : Text(
                initials,
                style: TextStyle(
                  color: kWhite,
                  fontSize: widget.radius * 0.7,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
