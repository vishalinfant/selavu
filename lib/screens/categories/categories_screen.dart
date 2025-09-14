import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selavu/models/category_model.dart';
import 'package:selavu/screens/categories/add_category_screen.dart';
import 'package:selavu/screens/categories/components/category_list_item.dart';
import 'package:selavu/screens/widgets/custom_border_button.dart';
import 'package:sizer/sizer.dart';

import '../../services/category_services.dart';
import '../bottomMenu/bottom_menu.dart';
import '../widgets/custom_button.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  final categoryService = CategoryService();
  List<Category> categories = [];

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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        BottomMenu.switchToHome();
      },
      child: Scaffold(
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
                Text("Categories",
                style: Theme.of(context).textTheme.displayLarge,),
                Expanded(
                  child: categories.isEmpty
                  ? Center(
                    child: Text("No categories added",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).primaryColor
                      ),),
                  )
                  : Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: categories.map((category){
                      return CategoryListItem(
                          categoryName: category.name,
                        onPressed: (){
                          context.push("/categoryBasedExpensesScreen",
                              extra: {
                                "category": category.name
                              });
                        },
                      );
                    }).toList(),
                  ),
                ),
                categories.isEmpty
                ? const SizedBox.shrink()
                : CustomBorderButton(
                    buttonLabel: "Manage Category",
                    onPressed: () async{
                      await context.push("/manageCategoryScreen");
                      getCategories();
                    },
                    enable: true
                ),
                CustomButton(
                    buttonLabel: "Add New Category",
                    onPressed: (){
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
                    enable: true
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
