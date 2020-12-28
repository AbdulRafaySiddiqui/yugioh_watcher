import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dialog extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String content;
  const Dialog({
    Key key,
    this.title,
    this.content,
    this.titleColor = Colors.red,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  title ?? "Error",
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 20.0,
                  bottom: 10.0,
                ),
                child: Text(content),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: RawMaterialButton(
                  splashColor: Colors.orange[700],
                  fillColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: Text("Close"),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
