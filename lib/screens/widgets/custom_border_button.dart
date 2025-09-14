import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBorderButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressed;
  final bool enable;
  const CustomBorderButton({super.key, required this.buttonLabel, required this.onPressed, required this.enable});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onPressed();
      },
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.5.h
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor,)
        ),
        child: Center(
          child: Text(buttonLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).primaryColor
          ),),
        ),
      ),
    );
  }
}
