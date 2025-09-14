import 'package:hive/hive.dart';
import 'package:selavu/models/expense_model.dart';

class ExpenseService {
 static const String boxName = 'expenses';

 Future<Box<Expense>> get _box async => await Hive.openBox<Expense>(boxName);

 /// Add a new expense
 Future<bool> addNewExpense(Expense newExpense) async {
  final box = await _box;
  try {
   await box.put(newExpense.id, newExpense); // Store with unique ID
   return true;
  } catch (e){
   return false;
  }
 }

 /// Update an existing expense using its unique ID
 Future<bool> updateExpense(Expense updatedExpense) async {
  final box = await _box;

  if (!box.containsKey(updatedExpense.id)) {
   return false; // Expense not found
  }

  await box.put(updatedExpense.id, updatedExpense);
  return true; // Update successful
 }

 /// Get all expenses
 Future<List<Expense>> getAllExpenses() async {
  final box = await _box;
  return box.values.toList();
 }

 /// Get last 3 expenses for the home screen
 Future<List<Expense>> getHomeExpenses() async {
  final box = await _box;
  List<Expense> expenses = box.values.toList();

  return expenses.length > 3
      ? expenses.sublist(expenses.length - 3) // Get the last 3 items
      : expenses;
 }

 /// Get expenses filtered by category and calculate total amount
 Future<Map<String, dynamic>> getExpensesByCategory(String category) async {
  final box = await _box;
  List<Expense> expenses = box.values
      .where((expense) => expense.category == category)
      .toList();

  double totalAmount = expenses.fold(0, (sum, item) => sum + item.amount);

  return {
   "expenses": expenses,
   "totalAmount": totalAmount,
  };
 }

 /// Get expenses filtered by a specific date and calculate total amount
 Future<Map<String, dynamic>> getExpensesByDate(DateTime date) async {
  final box = await _box;
  List<Expense> expenses = box.values
      .where((expense) =>
  expense.date.year == date.year &&
      expense.date.month == date.month &&
      expense.date.day == date.day)
      .toList();

  double totalAmount = expenses.fold(0, (sum, item) => sum + item.amount);

  return {
   "expenses": expenses,
   "totalAmount": totalAmount,
  };
 }

 /// Get expenses filtered by category and a specific date, and calculate total amount
 Future<Map<String, dynamic>> getExpensesByCategoryAndDate(
     String category, DateTime date) async {
  final box = await _box;
  List<Expense> expenses = box.values
      .where((expense) =>
  expense.category == category &&
      expense.date.year == date.year &&
      expense.date.month == date.month &&
      expense.date.day == date.day)
      .toList();

  double totalAmount = expenses.fold(0, (sum, item) => sum + item.amount);

  return {
   "expenses": expenses,
   "totalAmount": totalAmount,
  };
 }

 /// Delete an expense using its unique ID
 Future<bool> deleteExpense(String id) async {
  final box = await _box;
  if (box.containsKey(id)) {
   await box.delete(id);
   return true; // Successfully deleted
  }
  return false; // Expense not found
 }

 /// Get total expense amount for the current month
 Future<double> getTotalExpenseForCurrentMonth() async {
  final box = await _box;
  DateTime now = DateTime.now();

  double totalAmount = box.values
      .where((expense) =>
  expense.date.year == now.year && expense.date.month == now.month)
      .fold(0, (sum, expense) => sum + expense.amount);

  return totalAmount;
 }
}