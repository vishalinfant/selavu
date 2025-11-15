import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_strings.dart';
import '../../services/expense_services.dart';
import '../../core/constants/app_colours.dart';
import '../../services/notification_service.dart';
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
  String? _selectedTimeText; // to hold picked time string

  Future<void> _pickTime() async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      // Schedule notification
      await NotificationService().scheduleDailyNotification(picked);

      // Convert to readable string
      final String formatted = picked.format(context);

      setState(() {
        _selectedTimeText = formatted; // update state
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("schedule_time", _selectedTimeText.toString());
    }
  }

  Future<String> getSalaryAmount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String salary = prefs.getString("salary") ?? "0";
    salaryController.text = salary;
    return salary;
  }

  setDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String scheduleTime = prefs.getString("schedule_time") ?? "0";
    setState(() {
      _selectedTimeText = scheduleTime;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setDate();
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
            child: SingleChildScrollView(
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.5.h
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 1.h,
                      children: [
                        Text("Salary Amount",
                          style: Theme.of(context).textTheme.bodyLarge),
                        Container(
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
                              hintText: "Salary Amount *",
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
                    ),
                  ),
                  // reminder notifications
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 2.5.h
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 1.h,
                      children: [
                        Text("Reminder Notifications",
                            style: Theme.of(context).textTheme.bodyLarge),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h
                          ),
                          decoration: BoxDecoration(
                            color: whiteColour,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(_selectedTimeText == null || _selectedTimeText == "0"
                                    ? "No time selected yet"
                                    : "Scheduled daily at $_selectedTimeText"),
                              ),
                              IconButton(
                                  onPressed: _pickTime,
                                  icon: Icon(Icons.schedule)
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  updateSalaryAmount() async {
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("salary", salaryController.text.trim());
    getSalaryAmount();
  }

}
