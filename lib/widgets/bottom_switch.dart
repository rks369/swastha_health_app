import 'package:flutter/material.dart';
import 'package:swastha/utils/styles.dart';

class BottomSwitchItem {
  final IconData icon;
  final String label;

  const BottomSwitchItem({required this.icon, required this.label});
}

/// Floating pill switch with a sliding highlight behind the selected item.
class BottomSwitch extends StatelessWidget {
  final List<BottomSwitchItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomSwitch({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  static const _height = 68.0;
  static const _padding = 6.0;
  static const _itemWidth = 104.0;
  static const _borderWidth = 1.0;

  @override
  Widget build(BuildContext context) {
    final width = _itemWidth * items.length + (_padding + _borderWidth) * 2;
    return Container(
      width: width,
      height: _height,
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(_height),
        border: Border.all(color: kBorder, width: _borderWidth),
        boxShadow: [
          BoxShadow(
            color: kInk.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment(
              items.length == 1 ? 0 : -1 + 2 * currentIndex / (items.length - 1),
              0,
            ),
            child: Container(
              width: _itemWidth,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(_height),
              ),
            ),
          ),
          Row(
            children: [
              for (var i = 0; i < items.length; i++)
                SizedBox(
                  width: _itemWidth,
                  child: _SwitchTile(
                    item: items[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final BottomSwitchItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SwitchTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? kWhite : kSecondaryColor;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(BottomSwitch._height),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, size: 22, color: color),
            const SizedBox(height: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
