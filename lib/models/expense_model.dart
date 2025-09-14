import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0) // Unique type ID for Hive
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String description;

  Expense({
    String? id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  }): id = id ?? const Uuid().v4();
}