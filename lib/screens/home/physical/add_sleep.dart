import 'package:flutter/material.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/widgets/quick_add_sheet.dart';

class AddSleep extends StatelessWidget {
  const AddSleep({super.key});

  @override
  Widget build(BuildContext context) {
    return QuickAddSheet(
      title: 'How long did you sleep?',
      unit: 'h',
      quickAmounts: const [1, 2, 4, 6, 8],
      maxAmount: 24,
      onSave: (amount) => SQLHelper.addIntake(
        DataModel(
          SQLHelper.todayKey(),
          DateTime.now().weekday,
          0,
          0,
          amount,
          0,
        ),
      ),
    );
  }
}
