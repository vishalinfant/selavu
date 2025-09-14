import 'package:hive/hive.dart';

import '../models/expense_model.dart';

abstract class ExpenseRepository {
  Future<bool> addNewExpense(Expense newExpense);
  Future<bool> updateExpense(Expense updatedExpense);
  Future<List<Expense>> getAllExpenses();
  Future<List<Expense>> getHomeExpenses();
  Future<Map<String, dynamic>> getExpensesByCategory(String category);
  Future<Map<String, dynamic>> getExpensesByDate(DateTime date);
  Future<Map<String, dynamic>> getExpensesByCategoryAndDate(
      String category, DateTime date);
  Future<bool> deleteExpense(String id);
  Future<double> getTotalExpenseForCurrentMonth();
}

class ExpenseRepositoryImpl implements ExpenseRepository {

  static const String boxName = 'expenses';

  Future<Box<Expense>> get _box async => await Hive.openBox<Expense>(boxName);

  /// Add a new expense
  @override
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
  @override
  Future<bool> updateExpense(Expense updatedExpense) async {
    final box = await _box;

    if (!box.containsKey(updatedExpense.id)) {
      return false; // Expense not found
    }

    await box.put(updatedExpense.id, updatedExpense);
    return true; // Update successful
  }

  /// Get all expenses
  @override
  Future<List<Expense>> getAllExpenses() async {
    final box = await _box;
    return box.values.toList();
  }

  /// Get last 3 expenses for the home screen
  @override
  Future<List<Expense>> getHomeExpenses() async {
    final box = await _box;
    List<Expense> expenses = box.values.toList();

    return expenses.length > 3
        ? expenses.sublist(expenses.length - 3) // Get the last 3 items
        : expenses;
  }

  /// Get expenses filtered by category and calculate total amount
  @override
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
  @override
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
  @override
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
  @override
  Future<bool> deleteExpense(String id) async {
    final box = await _box;
    if (box.containsKey(id)) {
      await box.delete(id);
      return true; // Successfully deleted
    }
    return false; // Expense not found
  }

  /// Get total expense amount for the current month
  @override
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