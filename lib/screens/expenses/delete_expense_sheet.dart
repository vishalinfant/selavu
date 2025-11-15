import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_colours.dart';

class DeleteExpenseSheet extends StatefulWidget {
  const DeleteExpenseSheet({super.key});

  @override
  State<DeleteExpenseSheet> createState() => _DeleteExpenseSheetState();
}

class _DeleteExpenseSheetState extends State<DeleteExpenseSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 20.h,
      padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.5.h
      ),
      decoration: BoxDecoration(
        color: whiteColour,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Delete Note?',
            style: Theme.of(context).textTheme.headlineLarge,),
          SizedBox(height: 0.5.h,),
          Text('Are you sure you want to delete this note?',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: secondaryTextColor
            ),),
          SizedBox(height: 1.5.h,),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.pop(false),
                child: Text('Cancel',
                style: Theme.of(context).textTheme.bodyMedium,),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: errorColour
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
