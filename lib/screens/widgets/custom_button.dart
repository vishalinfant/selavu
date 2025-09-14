import 'package:flutter/material.dart';
import 'package:selavu/screens/widgets/custom_border.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressed;
  final bool enable;
  const CustomButton({super.key, required this.buttonLabel, required this.onPressed, required this.enable});

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
          vertical: 2.5.h
        ),
        decoration: BoxDecoration(
          color: blackColour,
          // border: shadowButtonBorder(context)
        ),
        child: Center(
          child: Text(buttonLabel,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: whiteColour
          ),),
        ),
      ),
    );
  }
}
