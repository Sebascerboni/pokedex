import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pokedex_mobile/databases/category_database.dart';
import 'package:pokedex_mobile/dtos/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final List<CategoryModel> _categories = [];

  int get totalCategories => _categories.length;

  UnmodifiableListView<CategoryModel> get categoriesGetter =>
      UnmodifiableListView(_categories);

  void addCategory(String name) {
    CategoryModel categoryModel =
        CategoryModel(_categories.length + 1, name, '');
    _categories.add(categoryModel);
    CategoryDatabase.instance.create(categoryModel);
    notifyListeners();
  }

  Future<void> initializeCategories() async {
    List<CategoryModel> categories =
        await CategoryDatabase.instance.readAllCategories();
    _categories.clear();
    _categories.addAll(categories);
    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    _categories.removeWhere((element) => element.id == id);
    await CategoryDatabase.instance.delete(id);
    notifyListeners();
  }

  void clearList() {
    _categories.clear();
    notifyListeners();
  }
}
