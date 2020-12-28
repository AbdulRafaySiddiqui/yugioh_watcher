import 'package:flutter/material.dart';
import 'package:products_watcher/main_screen/models/product_model.dart';
import 'package:products_watcher/main_screen/widget/product_item.dart';

class ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  final ScrollController _scrollController = ScrollController();

  ProductsList({Key key, @required this.products}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: ListView.separated(
        controller: _scrollController,
        itemCount: products.length,
        itemBuilder: (context, i) => ProductItem(
          product: products[i],
        ),
        separatorBuilder: (BuildContext context, int index) =>
            Divider(color: Colors.grey[600]),
      ),
    );
  }
}
