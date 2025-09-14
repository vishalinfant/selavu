import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../services/expense_services.dart';
import '../../utils/app_colours.dart';
import '../../utils/app_strings.dart';
import '../bottomMenu/bottom_menu.dart';
import '../widgets/custom_border.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final salaryController = TextEditingController();
  final expenseService = ExpenseService();

  Future<String> getSalaryAmount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("salary") ?? "0";
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    salaryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        BottomMenu.switchToHome();
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.5.h,
              children: [
                // dashboard
                Container(
                  width: double.maxFinite,
                  color: blackColour,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 5.h,
                  ),
                  child: FutureBuilder<String>(
                    future: getSalaryAmount(), // Get salary from SharedPreferences
                    builder: (context, salarySnapshot) {
                      if (salarySnapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading ...");
                      }
                      if (salarySnapshot.hasError || salarySnapshot.data == null) {
                        return Text("Error loading salary");
                      }

                      double salary = double.tryParse(salarySnapshot.data!) ?? 0.0;

                      return FutureBuilder<double>(
                        future: expenseService.getTotalExpenseForCurrentMonth(),
                        builder: (context, expenseSnapshot) {
                          if (expenseSnapshot.connectionState == ConnectionState.waiting) {
                            return Text("Loading ...");
                          }
                          if (expenseSnapshot.hasError || expenseSnapshot.data == null) {
                            return Text("Error loading expenses");
                          }

                          double totalExpenses = expenseSnapshot.data ?? 0.0;
                          double remainingAmount = salary - totalExpenses;

                          return Column(
                            spacing: 2.5.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 0.5.h,
                                children: [
                                  Text(
                                    "Your total balance",
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: whiteColour),
                                  ),
                                  Text(
                                    "$rupeeSymbol ${remainingAmount.toStringAsFixed(2)}",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: remainingAmount >= 0 ? whiteColour : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                spacing: 3.w,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      spacing: 2.w,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: Icon(Icons.arrow_upward_rounded, color: whiteColour, size: 5.w,),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Monthly Salary",
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: whiteColour),
                                              ),
                                              Text(
                                                "$rupeeSymbol ${salary.toStringAsFixed(2)}",
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: whiteColour),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      spacing: 2.w,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: errorColour,
                                          child: Icon(Icons.arrow_downward_rounded, color: whiteColour, size: 5.w,),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "This Month",
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: whiteColour),
                                              ),
                                              Text(
                                                "- $rupeeSymbol ${totalExpenses.toStringAsFixed(2)}",
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                    color: errorColour),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                // amount text field
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.5.h
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 1.h
                  ),
                  decoration: BoxDecoration(
                    color: whiteColour,
                  ),
                  child: TextFormField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    onTapOutside: (PointerDownEvent event) {
                      FocusScope.of(context).unfocus();
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.titleMedium,
                    cursorColor: Theme.of(context).primaryColor,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      prefixText: "$rupeeSymbol ",
                      prefixStyle: Theme.of(context).textTheme.titleMedium,
                      labelText: "Salary Amount *",
                      suffix: GestureDetector(
                        onTap: (){
                          updateSalaryAmount();
                        },
                        child: Text("Update".toUpperCase(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).primaryColor
                        ),),
                      ),
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: errorColour
                      ),
                      alignLabelWithHint: true,
                      errorBorder: errorBorder(context),
                      focusedErrorBorder: errorBorder(context),
                      focusedBorder: focusedBorder(context),
                      enabledBorder: enabledBorder(context),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  updateSalaryAmount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("salary", salaryController.text.trim());
    FocusScope.of(context).unfocus();
  }

}
