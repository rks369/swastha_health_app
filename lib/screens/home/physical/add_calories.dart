import 'package:flutter/material.dart';
import 'package:swastha/database/sql_helper.dart';
import 'package:swastha/models/data_model.dart';
import 'package:swastha/widgets/quick_add_sheet.dart';

class AddCalories extends StatelessWidget {
  const AddCalories({super.key});

  @override
  Widget build(BuildContext context) {
    return QuickAddSheet(
      title: 'How many calories did you eat?',
      unit: 'kcal',
      quickAmounts: const [50, 100, 250, 500],
      maxAmount: 3000,
      onSave: (amount) => SQLHelper.addIntake(
        DataModel(
          SQLHelper.todayKey(),
          DateTime.now().weekday,
          0,
          amount,
          0,
          0,
        ),
      ),
    );
  }
}
