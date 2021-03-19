import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibelit/config/styles.dart';


enum ToastType {SUCCESS, ERROR, INFO}

class ToastUtils {
  static int toastDuration = 2;

  static void showSuccessToast(BuildContext context, String msg) {
    FlutterToast(context).showToast(child: _getToastWidget(msg, ToastType.SUCCESS), gravity: ToastGravity.BOTTOM);
  }

  static void showErrorToast(BuildContext context, String msg) {
    FlutterToast(context).showToast(child: _getToastWidget(msg, ToastType.ERROR), gravity: ToastGravity.BOTTOM);
  }

  static void showInfoToast(BuildContext context, String msg) {
    FlutterToast(context).showToast(child: _getToastWidget(msg, ToastType.INFO), gravity: ToastGravity.BOTTOM);
  }

  static Widget _getToastWidget(String msg, ToastType type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(type == ToastType.SUCCESS ? Icons.check : type == ToastType.ERROR ? Icons.error_outline : Icons.info, color: type == ToastType.ERROR ? Colors.red : Styles.txtColor, size: 48,),
          SizedBox(
            width: 12.0,
          ),
          Flexible(
            child: Text(msg, style: TextStyle(color: type == ToastType.ERROR ? Colors.red : Styles.txtColor, fontSize: 24)),
          ),
        ],
      ),
    );
  }
}