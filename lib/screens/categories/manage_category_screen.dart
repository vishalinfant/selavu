import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../models/category_model.dart';
import '../../services/category_services.dart';
import '../../utils/app_colours.dart';
import 'components/manage_category_list_item.dart';
import 'components/suggested_category_list_item.dart';

class ManageCategoryScreen extends StatefulWidget {
  const ManageCategoryScreen({super.key});

  @override
  State<ManageCategoryScreen> createState() => _ManageCategoryScreenState();
}

class _ManageCategoryScreenState extends State<ManageCategoryScreen> {

  final categoryService = CategoryService();
  List<Category> categories = [];
  List<Category> suggestedCategories = [
    Category(name: "Food & Dining"),
    Category(name: "Groceries"),
    Category(name: "Transport"),
    Category(name: "Entertainment"),
    Category(name: "Shopping"),
    Category(name: "Health & Fitness"),
    Category(name: "Education"),
    Category(name: "Bills & Utilities"),
    Category(name: "Rent"),
    Category(name: "Travel"),
    Category(name: "Insurance"),
    Category(name: "Savings & Investments"),
    Category(name: "Gifts & Donations"),
    Category(name: "Personal Care"),
    Category(name: "Miscellaneous"),
  ];

  getCategories() async{
    final list = await categoryService.getAllCategories();
    setState(() {
      categories = list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 800;
          return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5.w,
                    vertical: 2.5.h
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.5.h,
                  children: [
                    isWeb ? const SizedBox.shrink() : CircleAvatar(
                      radius: isWeb ? 2.w : 5.w,
                      backgroundColor: Colors.black12,
                      child: IconButton(
                          onPressed: (){
                            context.pop();
                          },
                          icon: Icon(Icons.arrow_back, color: blackColour, size: isWeb ? 2.w : 5.w,)),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2.5.h,
                          children: [
                            Text("Suggested categories",
                              style: Theme.of(context).textTheme.displayMedium,),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: suggestedCategories.map((category){
                                return SuggestedCategoryListItem(
                                  categoryName: category.name,
                                  addCategory: () async {
                                    bool result = await categoryService.addCategory(category);
                                    if(result){
                                      getCategories();
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                            Text("Manage your categories",
                              style: Theme.of(context).textTheme.displayMedium,),
                            Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: categories.map((category){
                                return ManageCategoryListItem(
                                  categoryName: category.name,
                                  removeCategory: () async {
                                    bool result = await categoryService.deleteCategory(category);
                                    if(result){
                                      getCategories();
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        }
      ),
    );
  }
}
