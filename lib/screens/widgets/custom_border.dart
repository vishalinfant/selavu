import 'package:flutter/material.dart';

import '../../core/constants/app_colours.dart';

OutlineInputBorder focusedBorder(BuildContext context){
  return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent, width: 0.5),
      borderRadius: BorderRadius.circular(5.0)
  );
}

OutlineInputBorder errorBorder(BuildContext context){
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.5),
      borderRadius: BorderRadius.circular(5.0)
  );
}

OutlineInputBorder enabledBorder(BuildContext context){
  return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent, width: 0.5),
      borderRadius: BorderRadius.circular(5.0)
  );
}

Border shadowBorder(BuildContext context){
  return const Border(
    top: BorderSide(width: 1.0, style: BorderStyle.solid, color: blackColour), // Top border
    left: BorderSide(width: 1.0, style: BorderStyle.solid, color: blackColour), // Left border
    bottom: BorderSide(width: 3.0, style: BorderStyle.solid, color: blackColour), // Bottom border
    right: BorderSide(width: 3.0, style: BorderStyle.solid, color: blackColour), // Right border
  );
}

Border shadowButtonBorder(BuildContext context){
  return Border(
    top: BorderSide(width: 1.0, style: BorderStyle.solid, color: Theme.of(context).secondaryHeaderColor), // Top border
    left: BorderSide(width: 1.0, style: BorderStyle.solid, color: Theme.of(context).secondaryHeaderColor), // Left border
    bottom: BorderSide(width: 3.0, style: BorderStyle.solid, color: Theme.of(context).secondaryHeaderColor), // Bottom border
    right: BorderSide(width: 3.0, style: BorderStyle.solid, color: Theme.of(context).secondaryHeaderColor), // Right border
  );
}