import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_watcher/dialog_service.dart/dialog_service.dart';
import 'package:products_watcher/main_screen/controller/main_screen_controller.dart';
import 'package:products_watcher/main_screen/models/filter_model.dart';

class FilterModalSheet extends StatefulWidget {
  FilterModalSheet({Key key}) : super(key: key);

  @override
  _FilterModalSheetState createState() => _FilterModalSheetState();
}

class _FilterModalSheetState extends State<FilterModalSheet> {
  @override
  void initState() {
    super.initState();
    var filter = controller.currentFilter.value;
    if (filter == null) return;
    searchTextController.text = filter.searchText;
    minPriceController.text = filter.minPrice?.toString();
    maxPriceController.text = filter.maxPrice?.toString();
    notSearchText.value = filter.notSearchText;
    notInRange.value = filter.notInRange;
  }

  final MainScreenController controller = Get.find();
  final TextEditingController searchTextController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController filterNameController = TextEditingController();
  final notSearchText = false.obs;
  final notInRange = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.grey[600],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Filters list
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => DropdownButtonFormField(
                    dropdownColor: Colors.grey[800],
                    iconEnabledColor: Colors.white,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Filter",
                    ),
                    isExpanded: true,
                    items: controller.filters.value
                        .map(
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(
                              i.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                    value: controller.selectedFilter.value,
                    onTap: () => FocusManager.instance.primaryFocus.unfocus(),
                    onChanged: (value) {
                      controller.selectedFilter.value = value;

                      searchTextController.text =
                          controller.selectedFilter.value.searchText;
                      minPriceController.text =
                          controller.selectedFilter.value.minPrice?.toString();
                      maxPriceController.text =
                          controller.selectedFilter.value.maxPrice?.toString();
                      notInRange.value =
                          controller.selectedFilter.value.notInRange;
                      notSearchText.value =
                          controller.selectedFilter.value.notSearchText;

                      controller.currentFilter.value = FilterModel(
                        searchText: controller.selectedFilter.value.searchText,
                        minPrice: controller.selectedFilter.value.minPrice,
                        maxPrice: controller.selectedFilter.value.maxPrice,
                        notInRange: controller.selectedFilter.value.notInRange,
                        notSearchText:
                            controller.selectedFilter.value.notSearchText,
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => controller.isDeletingFilter.value
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: IconButton(
                          color: Colors.red,
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (controller.selectedFilter != null) {
                              controller.deleteFilter(
                                  controller.selectedFilter.value.name);
                              controller.selectedFilter.value = null;
                              filterNameController.text = "";
                              searchTextController.text = "";
                              minPriceController.text = "";
                              maxPriceController.text = "";
                            }
                          },
                        ),
                      ),
              ),
            ],
          ),
          //Search Text
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchTextController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "Search Text",
                  ),
                ),
              ),
              Obx(
                () => Checkbox(
                    value: notSearchText.value,
                    onChanged: (value) => notSearchText.value = value),
              ),
            ],
          ),
          // SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: minPriceController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "Min Price",
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: maxPriceController,
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "Max Price",
                  ),
                ),
              ),
              Obx(
                () => Checkbox(
                    value: notInRange.value,
                    onChanged: (value) => notInRange.value = value),
              ),
            ],
          ),
          SizedBox(height: 10),
          RawMaterialButton(
            fillColor: Colors.orange,
            splashColor: Colors.orange[700],
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Text("Filter"),
            onPressed: () {
              FilterModel filter;
              if (searchTextController.text != null &&
                  minPriceController.text != null &&
                  maxPriceController.text != null) {
                var min = double.tryParse(minPriceController.text);
                var max = double.tryParse(maxPriceController.text);
                filter = FilterModel(
                    searchText: searchTextController.text,
                    minPrice: min,
                    maxPrice: max,
                    notSearchText: notSearchText.value,
                    notInRange: notInRange.value);
              }
              controller.selectedFilter.value = null;
              controller.setCurrentFilter(filter);
              filterNameController.clear();
              Get.back();
              return;
            },
          ),
          //save
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: filterNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: "Filter Name"),
                ),
              ),
              Divider(),
              Obx(
                () => controller.isAddingFilter.value
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.save),
                          onPressed: () {
                            if (filterNameController.text == null ||
                                filterNameController.text.isEmpty) {
                              Get.find<DialogService>()
                                  .showErrorDialog("Filter name is required!");
                              return;
                            } else if (searchTextController.text.isEmpty &&
                                minPriceController.text.isEmpty &&
                                maxPriceController.text.isEmpty) {
                              Get.find<DialogService>().showErrorDialog(
                                  "Atleast one filter value must be provided!");
                              return;
                            }

                            var min = double.tryParse(minPriceController.text);
                            var max = double.tryParse(maxPriceController.text);
                            var filter = FilterModel(
                              searchText: searchTextController.text,
                              minPrice: min,
                              maxPrice: max,
                              name: filterNameController.text,
                              notSearchText: notSearchText.value,
                              notInRange: notInRange.value,
                            );

                            controller.addFilter(filter);
                          },
                        ),
                      ),
              )
            ],
          )
        ],
      ),
    );
  }
}
