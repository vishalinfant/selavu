import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:selavu/screens/widgets/custom_button.dart';
import 'package:selavu/services/category_services.dart';
import 'package:sizer/sizer.dart';

import '../../models/category_model.dart';
import '../../core/constants/app_colours.dart';
import '../widgets/custom_border.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  final categoryNameController = TextEditingController();
  final categoryService = CategoryService();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    categoryNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal: 5.w
      ),
      child: Container(
        width: double.maxFinite,
        height: 40.h,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.5.h
        ),
        child: Column(
          spacing: 2.5.h,
          children: [
            Text("A new category ?",
              style: Theme.of(context).textTheme.displayMedium,),
            // category name text field
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
                controller: categoryNameController,
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
                  hintText: "Name *",
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
            const Spacer(),
            CustomButton(
                buttonLabel: "Add",
                onPressed: (){
                  validate();
                },
                enable: true),
          ],
        ),
      ),
    );
  }

  validate() async {
    final category = Category(
      name: categoryNameController.text.trim(),
    );
    await categoryService.addCategory(category);
    if(mounted){
      context.pop(true);
    }
  }

}
