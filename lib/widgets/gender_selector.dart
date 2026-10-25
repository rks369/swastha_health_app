import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/card.dart';

/// Male / Female choice shown as two selectable cards.
class GenderSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderCard(
            label: 'Male',
            icon: Icons.male,
            selected: selected == 'Male',
            margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            onTap: () => onChanged('Male'),
          ),
        ),
        Expanded(
          child: _GenderCard(
            label: 'Female',
            icon: Icons.female,
            selected: selected == 'Female',
            margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
            onTap: () => onChanged('Female'),
          ),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final EdgeInsetsGeometry margin;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.margin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: UserCard(
        colour: selected ? kPrimaryColor.withValues(alpha: 0.06) : kWhite,
        borderColor: selected ? kPrimaryColor : kBorder,
        margin: margin,
        onPress: onTap,
        cardChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: selected ? kPrimaryColor : kSecondaryColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? kPrimaryColor : kSecondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
