import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_strings.dart';
import '../../models/expense_model.dart';
import '../../services/expense_services.dart';
import '../../core/constants/app_colours.dart';
import 'components/expense_list_item.dart';
import 'delete_expense_sheet.dart';

class CategoryBasedExpensesScreen extends StatefulWidget {
  final String category;
  const CategoryBasedExpensesScreen({super.key, required this.category});

  @override
  State<CategoryBasedExpensesScreen> createState() => _CategoryBasedExpensesScreenState();
}

class _CategoryBasedExpensesScreenState extends State<CategoryBasedExpensesScreen> {

  final expenseService = ExpenseService();
  List<Expense> expenses = [];
  double? totalAmount;

  getCategoryBasedExpenses() async{
    final list = await expenseService.getExpensesByCategory(widget.category.toString());
    setState(() {
      expenses = list["expenses"];
      totalAmount = list["totalAmount"];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryBasedExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.5.h
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.5.h,
              children: [
                CircleAvatar(
                  radius: 5.w,
                  backgroundColor: Colors.black12,
                  child: IconButton(
                      onPressed: (){
                        context.pop();
                      },
                      icon: Icon(Icons.arrow_back, color: blackColour, size: 5.w,)),
                ),
                Row(
                  spacing: 3.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(widget.category,
                        style: Theme.of(context).textTheme.displayMedium,),
                    ),
                    if(totalAmount != null)...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 1.h,
                        children: [
                          Text("Expenses Amount",
                            style: Theme.of(context).textTheme.bodyMedium,),
                          Text("$rupeeSymbol $totalAmount",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).primaryColor
                            ),),
                        ],
                      ),
                    ],
                  ],
                ),
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
                                  getCategoryBasedExpenses();
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
          )
      ),
    );
  }
}
