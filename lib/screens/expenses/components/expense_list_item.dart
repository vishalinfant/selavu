import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selavu/models/expense_model.dart';
import 'package:selavu/screens/widgets/custom_border.dart';
import 'package:selavu/core/constants/app_colours.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_strings.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final Function() onPressed;
  const ExpenseListItem({super.key, required this.expense, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: whiteColour,
          border: shadowBorder(context)
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.5.h
        ),
        child: Row(
          spacing: 3.w,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 1.5.h,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0.5.h,
                    children: [
                      Text("Category",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: secondaryTextColor
                        ),),
                      Text(expense.category,
                        style: Theme.of(context).textTheme.bodyLarge,),
                    ],
                  ),
                  Text(expense.description,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: secondaryTextColor
                    ),),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 2.h,
              children: [
                Text(formatDate(expense.date),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: secondaryTextColor
                  ),),
                Text("$rupeeSymbol ${expense.amount}",
                  style: Theme.of(context).textTheme.titleLarge,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime pickedDate){
    return DateFormat('dd MMMM yyyy').format(pickedDate).toString();
  }
}
