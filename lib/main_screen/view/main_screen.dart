import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_watcher/main_screen/controller/main_screen_controller.dart';
import 'package:products_watcher/main_screen/widget/filter_modal_sheet.dart';
import 'package:products_watcher/main_screen/widget/products_list.dart';

class MainScreen extends StatelessWidget {
  final controller = Get.put(MainScreenController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          title:
              //Title
              Obx(
            () => Container(
              color: Colors.black,
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: Colors.white),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Products: ${controller.products.length}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                controller.loadProducts();
              },
            ),
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.bar_chart_rounded, color: Colors.white),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return FilterModalSheet();
                      },
                      context: context);
                },
              ),
            ),
            Obx(() => controller.currentFilter.value != null
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.white,
                    onPressed: () {
                      controller.setCurrentFilter(null);
                    },
                  )
                : Container()),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ProductsList(
                  products: controller.products,
                ),
        ),
      ),
    );
  }
}
