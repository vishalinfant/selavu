import 'package:flutter/material.dart';
import 'package:selavu/core/constants/app_colours.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_border.dart';

class SuggestedCategoryListItem extends StatelessWidget {
  final String categoryName;
  final Function() addCategory;
  const SuggestedCategoryListItem({super.key, required this.categoryName, required this.addCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2.w,
      ),
      decoration: BoxDecoration(
        color: whiteColour,
          border: shadowBorder(context)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(categoryName,
          style: Theme.of(context).textTheme.labelMedium,),
          IconButton(
            padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: (){
                addCategory();
              },
              icon: Icon(Icons.add_circle, color: Theme.of(context).primaryColor, size: 4.w,),
          ),
        ],
      ),
    );
  }
}
