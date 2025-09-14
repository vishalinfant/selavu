import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:selavu/screens/widgets/custom_button.dart';
import 'package:selavu/services/category_services.dart';
import 'package:selavu/services/expense_services.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:selavu/utils/app_strings.dart';
import 'package:sizer/sizer.dart';

import '../../models/category_model.dart';
import '../../models/expense_model.dart';
import '../categories/add_category_screen.dart';
import '../widgets/custom_border.dart';
import '../widgets/error_toast_message.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryService = CategoryService();
  final expenseService = ExpenseService();
  List<Category> categories = [];
  String? selectedCategory, selectedDate;
  DateTime? expenseDate;
  final _formKey = GlobalKey<FormState>();

  getCategories() async{
    final list = await categoryService.getAllCategories();
    setState(() {
      categories = list;
    });
  }

  setValues(){
    setState(() {
      amountController.text = widget.expense.amount.toString();
      descriptionController.text = widget.expense.description.toString();
      selectedCategory = widget.expense.category.toString();
      expenseDate = widget.expense.date;
      selectedDate = DateFormat('dd MMMM yyyy').format(widget.expense.date);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
    setValues();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    amountController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                Text("Edit your expense",
                  style: Theme.of(context).textTheme.displayMedium,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 1.5.h,
                        children: [
                          // amount text field
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 1.h
                            ),
                            decoration: BoxDecoration(
                              color: whiteColour,
                                border: shadowBorder(context)
                            ),
                            child: TextFormField(
                              controller: amountController,
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
                                labelText: "Amount *",
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
                          // description text field
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 1.h
                            ),
                            decoration: BoxDecoration(
                              color: whiteColour,
                                border: shadowBorder(context)
                            ),
                            child: TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              onTapOutside: (PointerDownEvent event) {
                                FocusScope.of(context).unfocus();
                              },
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
                                hintText: "Description *",
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
                          // category dropdown
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.5.h
                            ),
                            decoration: BoxDecoration(
                                color: whiteColour,
                                border: shadowBorder(context)
                            ),
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              hint: Text('Select expense category',
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
                          // add new category text route
                          InkWell(
                            onTap: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return AddCategoryScreen();
                                  }
                              ).then((result){
                                if(result is bool){
                                  getCategories();
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.5.h
                              ),
                              child: Text("+ Add new category",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).primaryColor
                              ),),
                            ),
                          ),
                          // expense date
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.5.h
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
                        ],
                      ),
                    ),
                  ),
                ),
                CustomButton(
                    buttonLabel: "Update Expense",
                    onPressed: (){
                      validate();
                    },
                    enable: true
                ),
              ],
            ),
          )
      ),
    );
  }

  validate() async {
    if(_formKey.currentState!.validate()){
      if(selectedCategory == null){
        errorToastMessage("Select a category", context);
      } else if(selectedDate == null){
        errorToastMessage("Select expense date", context);
      } else {
        final expense = Expense(
            id: widget.expense.id,
            amount: double.parse(amountController.text.trim()),
            category: selectedCategory.toString(),
            date: expenseDate!,
            description: descriptionController.text.trim()
        );
        bool result = await expenseService.updateExpense(expense);
        if(result && mounted){
          context.pop(true);
        }
      }
    }
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
