import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

/// Bottom sheet to log an amount using quick-add chips or a typed value.
/// Pops with `true` once [onSave] succeeds.
class QuickAddSheet extends StatefulWidget {
  final String title;
  final String unit;
  final List<int> quickAmounts;
  final int maxAmount;
  final Future<void> Function(int amount) onSave;

  const QuickAddSheet({
    super.key,
    required this.title,
    required this.unit,
    required this.quickAmounts,
    required this.maxAmount,
    required this.onSave,
  });

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool saving = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void add(int amount) {
    final current = int.tryParse(controller.text) ?? 0;
    final next = (current + amount).clamp(0, widget.maxAmount);
    controller.text = next == 0 ? '' : next.toString();
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      await widget.onSave(int.parse(controller.text));
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  color: kInk,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  for (final amount in widget.quickAmounts)
                    ActionChip(
                      label: Text('+$amount ${widget.unit}'),
                      onPressed: saving ? null : () => add(amount),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: kTextFieldDecoration.copyWith(
                  labelText: 'Amount (${widget.unit})',
                  suffixIcon: IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clear,
                  ),
                ),
                validator: (value) {
                  final amount = int.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter an amount';
                  }
                  if (amount > widget.maxAmount) {
                    return 'Must be at most ${widget.maxAmount} ${widget.unit}';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              saving
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    )
                  : RoundedButton(
                      title: 'Done',
                      colour: kPrimaryColor,
                      onPressed: save,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
