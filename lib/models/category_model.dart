import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1) // Unique type ID for Hive
class Category extends HiveObject {
  @HiveField(0)
  final String name;

  Category({required this.name});
}