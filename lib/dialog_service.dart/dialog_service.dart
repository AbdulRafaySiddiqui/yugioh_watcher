import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:products_watcher/dialog_service.dart/dialog.dart';

class DialogService extends GetxService {
  bool isDialogOpen = false;
  Future<void> _showDialog({
    String title,
    @required String message,
  }) async {
    if (isDialogOpen) {
      print(message);
      return;
    }
    isDialogOpen = true;
    await Get.dialog(
      Dialog(
        title: title,
        content: message ?? "PANIC!!!!!!!!!!!!!!",
      ),
    );
    isDialogOpen = false;
    return;
  }

  //utiity function
  Future<void> showErrorDialog(dynamic exception) async {
    try {
      print(exception);
      await _showDialog(
        message: exception is String ? exception : exception.message,
      );
    } catch (e) {
      await _showDialog(message: "Something went wrong :(");
    }
  }
}
