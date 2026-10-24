import 'package:flutter/material.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/widgets/quick_add_sheet.dart';

class AddWater extends StatelessWidget {
  const AddWater({super.key});

  @override
  Widget build(BuildContext context) {
    return QuickAddSheet(
      title: 'How much water did you drink?',
      unit: 'ml',
      quickAmounts: const [100, 200, 250, 500],
      maxAmount: 3000,
      onSave: (amount) => SQLHelper.addIntake(
        DataModel(
          SQLHelper.todayKey(),
          DateTime.now().weekday,
          amount,
          0,
          0,
          0,
        ),
      ),
    );
  }
}
