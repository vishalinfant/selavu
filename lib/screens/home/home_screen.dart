import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in.dart';
import 'package:go_router/go_router.dart';
import 'package:selavu/services/expense_services.dart';
import 'package:selavu/core/constants/app_colours.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/route_names.dart';
import '../../models/category_model.dart';
import '../../models/expense_model.dart';
import '../../services/category_services.dart';
import '../bottomMenu/bottom_menu.dart';
import '../categories/components/category_list_item.dart';
import '../expenses/components/expense_list_item.dart';
import '../expenses/delete_expense_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final expenseService = ExpenseService();
  List<Expense> expenses = [];
  final categoryService = CategoryService();
  List<Category> categories = [];

  getCategories() async{
    final list = await categoryService.getAllCategories();
    setState(() {
      categories = list;
    });
  }

  getExpenses() async{
    final list = await expenseService.getHomeExpenses();
    setState(() {
      expenses = list;
    });
  }

  Future<String> getSalaryAmount() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("salary") ?? "0";
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
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                FadeIn(
                  child: Container(
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
                                Row(
                                  spacing: 3.w,
                                  children: [
                                    Expanded(
                                      child: Column(
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
                                            child: Icon(Icons.arrow_upward_rounded, color: whiteColour, size: isWeb ? 2.w : 5.w,),
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
                                            child: Icon(Icons.arrow_downward_rounded, color: whiteColour, size: isWeb ? 2.w : 5.w,),
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
                ),
                Expanded(
                  child: FadeIn(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.5.h
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          spacing: 2.5.h,
                          children: [
                            categories.isEmpty
                                ? const SizedBox.shrink()
                                : SizedBox(
                              width: double.maxFinite,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2.5.h,
                                children: [
                                  Text("Categories",
                                    style: Theme.of(context).textTheme.titleLarge,),
                                  Wrap(
                                    spacing: 2.w,
                                    runSpacing: 1.h,
                                    children: categories.map((category){
                                      return CategoryListItem(
                                        categoryName: category.name,
                                        onPressed: () async{
                                          await context.push(RouteNames.categoryBasedExpensesScreen,
                                              extra: {
                                                "category": category.name
                                              });
                                          getExpenses();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            expenses.isEmpty
                                ? Column(
                              children: [
                                Text("Start recording your expenses by adding the\n'+'\nbutton below ",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,),
                              ],
                            )
                                : Row(
                              children: [
                                Expanded(
                                  child: Text("Recent expenses",
                                    style: Theme.of(context).textTheme.titleLarge,),
                                ),
                                InkWell(
                                  onTap: (){
                                    BottomMenu.switchToExpenses();
                                    HapticFeedback.lightImpact();
                                  },
                                  child: Text("View all",
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Theme.of(context).primaryColor
                                    ),),
                                ),
                              ],
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, _){
                                return SizedBox(height: 1.5.h,);
                              },
                              itemCount: expenses.length,
                              itemBuilder: (context, index){
                                final expenseData = expenses[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: index + 1 == expenses.length ? 10.h : 8.0),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: LayoutBuilder(
            builder: (context, constraints) {
              bool isWeb = constraints.maxWidth > 800;
              return FloatingActionButton(
                backgroundColor: Theme.of(context).secondaryHeaderColor,
                  onPressed: (){
                    context.push(RouteNames.addExpenseScreen).then((result){
                      if(result is bool){
                        getExpenses();
                      }
                    });
                  },
                child: Icon(Icons.add, color: blackColour, size: isWeb ? 2.w : 6.w,),
              );
            }
          ),
        );
      }
    );
  }
}
