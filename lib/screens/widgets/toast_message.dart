import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

toastMessage(String message, context,
    {bool isLong = false, bool isError = false, bool isTop = false}) {
  toastification.show(
    context: context,
    type: isError ? ToastificationType.error : ToastificationType.success,
    style: ToastificationStyle.fillColored,
    title: Text(message,
        maxLines: 5,
        style: isError ? Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xffffffff))
            : Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xffffffff)
        )),
    animationBuilder: (context, animation, alignment, child,) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    primaryColor: isError ? const Color(0xffE74C3C) : Theme.of(context).primaryColor,
    alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
    closeButtonShowType: CloseButtonShowType.none,
    closeOnClick: false,
    autoCloseDuration: Duration(seconds: isLong ? 5 : 2),
    borderRadius: BorderRadius.circular(12.0),
    dragToClose: false,
    showProgressBar: false,
    applyBlurEffect: false,
  );
}