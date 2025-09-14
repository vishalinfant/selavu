import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selavu/screens/widgets/custom_border.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:sizer/sizer.dart';

class CategoryListItem extends StatelessWidget {
  final String categoryName;
  final Function() onPressed;
  const CategoryListItem({super.key, required this.categoryName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 1.h
        ),
        decoration: BoxDecoration(
          color: whiteColour,
          border: shadowBorder(context)
        ),
        child: Text(categoryName,
        style: Theme.of(context).textTheme.bodyMedium,),
      ),
    );
  }
}
