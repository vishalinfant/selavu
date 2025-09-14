import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:selavu/screens/expenses/components/expense_list_item.dart';
import 'package:selavu/screens/widgets/custom_button.dart';
import 'package:selavu/utils/app_strings.dart';
import 'package:sizer/sizer.dart';

import '../../models/category_model.dart';
import '../../models/expense_model.dart';
import '../../services/category_services.dart';
import '../../services/expense_services.dart';
import '../../utils/app_colours.dart';
import '../bottomMenu/bottom_menu.dart';
import '../widgets/custom_border.dart';
import 'delete_expense_sheet.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {

  final expenseService = ExpenseService();
  final categoryService = CategoryService();
  List<Expense> expenses = [];
  List<Category> categories = [];
  double? totalAmount;

  String? selectedCategory, selectedDate;
  DateTime? expenseDate;

  getExpenses() async{
    final list = await expenseService.getAllExpenses();
    setState(() {
      expenses = list;
    });
  }

  getCategories() async{
    final list = await categoryService.getAllCategories();
    setState(() {
      categories = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getExpenses();
    getCategories();
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.5.h
              ),
              child: FadeIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.5.h,
                  children: [
                    Row(
                      spacing: 3.w,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 1.h,
                            children: [
                              Text("Your Expenses",
                                style: Theme.of(context).textTheme.displayLarge,),
                              totalAmount == null
                                  ? FutureBuilder<double>(
                                future: expenseService.getTotalExpenseForCurrentMonth(),
                                builder: (context, expenseSnapshot) {
                                  if (expenseSnapshot.connectionState == ConnectionState.waiting) {
                                    return Text("Loading ...");
                                  }
                                  if (expenseSnapshot.hasError || expenseSnapshot.data == null) {
                                    return Text("Error loading expenses");
                                  }

                                  return  Text("$rupeeSymbol ${expenseSnapshot.data}",
                                    style: Theme.of(context).textTheme.headlineLarge,);

                                },
                              )
                              : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        if(selectedCategory != null || selectedDate != null)...[
                          InkWell(
                            onTap: (){
                              setState(() {
                                selectedCategory = null;
                                selectedDate = null;
                                expenseDate = null;
                                totalAmount = null;
                              });
                              getExpenses();
                            },
                            child: Text("Clear Filters",
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: errorColour
                              ),),
                          ),
                        ] else ...[
                          const SizedBox.shrink()
                        ],
                      ],
                    ),
                    Column(
                      spacing: 1.5.h,
                      children: [
                        Row(
                          spacing: 3.w,
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                ),
                                decoration: BoxDecoration(
                                    color: whiteColour,
                                    border: shadowBorder(context)
                                ),
                                child: DropdownButton<String>(
                                  value: selectedCategory,
                                  hint: Text('Select category',
                                    style: Theme.of(context).textTheme.bodyMedium,),
                                  underline: const SizedBox.shrink(),
                                  isExpanded: true,
                                  icon: Icon(Icons.arrow_drop_down, size: 4.w,),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                  items: categories.map<DropdownMenuItem<String>>((Category value) {
                                    return DropdownMenuItem<String>( // Correct the type here
                                      value: value.name.toString(), // value is a String
                                      child: Text(
                                        value.name.toString(),
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w,
                                  ),
                                  decoration: BoxDecoration(
                                      color: whiteColour,
                                      border: shadowBorder(context)
                                  ),
                                  child: Row(
                                    spacing: 3.w,
                                    children: [
                                      Expanded(
                                        child: Text(selectedDate ?? "Select date",
                                          style: Theme.of(context).textTheme.bodyMedium,),
                                      ),
                                      IconButton(
                                        onPressed: (){
                                          _selectDate(context);
                                        },
                                        icon: Icon(Icons.calendar_month_outlined, color: Theme.of(context).secondaryHeaderColor, size: 5.w,),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),
                        if(selectedCategory != null && selectedDate != null)...[
                          CustomButton(
                              buttonLabel: "Filter expenses",
                              onPressed: () async {
                                final list = await expenseService.getExpensesByCategoryAndDate(selectedCategory.toString(), expenseDate!);
                                setState(() {
                                  expenses = list["expenses"];
                                  totalAmount = list["totalAmount"];
                                });
                              },
                              enable: true
                          ),
                        ] else if(selectedCategory != null)...[
                          CustomButton(
                              buttonLabel: "Filter expense by category",
                              onPressed: () async {
                                final list = await expenseService.getExpensesByCategory(selectedCategory.toString());
                                setState(() {
                                  expenses = list["expenses"];
                                  totalAmount = list["totalAmount"];
                                });
                              },
                              enable: true
                          ),
                        ] else if(selectedDate != null)...[
                          CustomButton(
                              buttonLabel: "Filter expense by date",
                              onPressed: () async {
                                final list = await expenseService.getExpensesByDate(expenseDate!);
                                setState(() {
                                  expenses = list["expenses"];
                                  totalAmount = list["totalAmount"];
                                });
                              },
                              enable: true
                          ),
                        ],
                      ],
                    ),
                    if(totalAmount != null)...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 1.h,
                        children: [
                          Text("Expenses Amount",
                            style: Theme.of(context).textTheme.displayLarge,),
                          Text("$rupeeSymbol $totalAmount",
                            style: Theme.of(context).textTheme.displayLarge,),
                        ],
                      ),
                    ],
                    Expanded(
                      child: expenses.isEmpty
                        ? Center(
                        child: Text("No Expenses added",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).primaryColor
                          ),),
                      )
                      : ListView.separated(
                        separatorBuilder: (context, _){
                          return SizedBox(height: 1.5.h,);
                        },
                        itemCount: expenses.length,
                        itemBuilder: (context, index){
                          final expenseData = expenses[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index + 1 == expenses.length ? 20.h : 0
                            ),
                            child: Dismissible(
                              key: Key(expenseData.key.toString()),
                              direction: DismissDirection.endToStart,
                              background: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: ColoredBox(color: errorColour),
                              ),
                              confirmDismiss: (direction) async {
                                bool? shouldDelete = await showModalBottomSheet<bool>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => DeleteExpenseSheet(),
                                );
                                return shouldDelete ?? false; // Ensure it always returns a boolean
                              },
                              onDismissed: (direction) async {
                                int expenseIndex = index; // Capture index before async call

                                bool result = await expenseService.deleteExpense(expenseData.id);
                                if (result) {
                                  setState(() {
                                    expenses.removeAt(expenseIndex); // Remove item from list
                                  });
                                } else {
                                  // If deletion fails, refresh UI to restore the dismissed item
                                  setState(() {});
                                }
                              },
                              child: ExpenseListItem(
                                  expense: expenseData,
                                onPressed: (){
                                  context.push(
                                      "/editExpenseScreen",
                                      extra: expenseData
                                  ).then((result){
                                    if(result is bool){
                                      getExpenses();
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          onPressed: (){
            context.push("/addExpenseScreen")
            .then((result){
              if(result is bool){
                getExpenses();
              }
            });
          },
          child: Icon(Icons.add, color: blackColour, size: 6.w,),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Open the date picker dialog
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default selected date
      firstDate: DateTime(2000),  // Earliest date user can pick
      lastDate: DateTime(2100), // Latest date user can pick
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: whiteColour,
              headerBackgroundColor: Theme.of(context).secondaryHeaderColor,
              headerHeadlineStyle: Theme.of(context).textTheme.headlineMedium,
              headerHelpStyle: Theme.of(context).textTheme.headlineMedium,
              weekdayStyle: Theme.of(context).textTheme.titleMedium,
              dayStyle: Theme.of(context).textTheme.titleMedium,
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor, // Color of "Cancel" and "OK"
                  textStyle: Theme.of(context).textTheme.titleMedium, // Increase text size
                )),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Format the picked date as "dd MMMM yyyy" and store it
      setState(() {
        selectedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
        expenseDate = pickedDate;
      });
    }
  }

}
