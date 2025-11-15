import 'package:flutter/material.dart';
import 'package:selavu/core/constants/app_colours.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_border.dart';

class ManageCategoryListItem extends StatelessWidget {
  final String categoryName;
  final Function() removeCategory;
  const ManageCategoryListItem({super.key, required this.categoryName, required this.removeCategory});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
      ),
      decoration: BoxDecoration(
        color: whiteColour,
          border: shadowBorder(context)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(categoryName,
          style: Theme.of(context).textTheme.bodyMedium,),
          IconButton(
              onPressed: (){
                removeCategory();
              },
              icon: Icon(Icons.remove_circle, color: errorColour, size: 4.w,),
          ),
        ],
      ),
    );
  }
}
