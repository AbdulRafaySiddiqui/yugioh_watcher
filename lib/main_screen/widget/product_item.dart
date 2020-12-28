import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:products_watcher/main_screen/models/product_model.dart';
import 'package:products_watcher/main_screen/widget/product_website_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;

  const ProductItem({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (product.websiteURL != null) if (product.source == Source.EBAY)
            launch(product.websiteURL);
          else
            Get.to(ProductWebsiteView(websiteURL: product.websiteURL));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            //Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                imageUrl: product.imageURL ?? "",
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: product.source == Source.CRAGSLIST
                        ? Colors.purple
                        : product.source == Source.TWITTER
                            ? Colors.blue
                            : product.source == Source.REDDIT
                                ? Colors.red
                                : Colors.yellow,
                  ),
                  child: Center(
                    child: Icon(Icons.error),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
              ),
            ),
            //Title & Price
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title
                    Text(
                      product.title ?? "Title Not available!",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 15),
                    // Spacer(),
                    //price
                    Row(
                      children: [
                        Text(
                          product.priceString ?? "\$0",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Spacer(),
                        if (product.source == Source.EBAY)
                          GestureDetector(
                            child: Icon(Icons.open_in_browser,
                                color: Colors.white),
                            onTap: () {
                              Get.to(ProductWebsiteView(
                                  websiteURL: product.websiteURL));
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
