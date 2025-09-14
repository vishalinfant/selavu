import 'package:hive/hive.dart';

import '../models/category_model.dart';

class CategoryService {

  static const String boxName = 'categories';

  Future<Box<Category>> get _box async =>
      await Hive.openBox<Category>(boxName);

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

  Future<List<Category>> getAllCategories() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<bool> deleteCategory(Category category) async {
    try {
      await category.delete();
      return true;
    } catch (e){
      return false;
    }
  }

}