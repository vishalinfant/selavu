import 'package:hive/hive.dart';

import '../models/category_model.dart';

abstract class CategoryRepository {

  static const String boxName = 'categories';

  Future<bool> addCategory(Category newCategory);
  Future<List<Category>> getAllCategories();
  Future<bool> deleteCategory(Category category);

}

class CategoryRepositoryImpl implements CategoryRepository {

  static const String boxName = 'categories';

  Future<Box<Category>> get _box async =>
      await Hive.openBox<Category>(boxName);

  @override
  Future<bool> addCategory(Category newCategory) async {
    final box = await _box;
    try {
      if(box.values.toList().contains(newCategory)){
        return false;
      } else {
        await box.add(newCategory);
        return true;
      }
    } catch (e){
      return false;
    }
  }

  @override
  Future<List<Category>> getAllCategories() async {
    final box = await _box;
    return box.values.toList();
  }

  @override
  Future<bool> deleteCategory(Category category) async {
    try {
      await category.delete();
      return true;
    } catch (e){
      return false;
    }
  }

}