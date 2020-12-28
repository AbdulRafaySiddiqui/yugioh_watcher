enum Source { EBAY, CRAGSLIST, TWITTER, REDDIT }

class ProductModel {
  final String title;
  final double price;
  final String priceString;
  final String imageURL;
  final String websiteURL;
  final Source source;
  final DateTime createdAt;

  ProductModel({
    this.createdAt,
    this.title,
    this.price = 0,
    this.priceString,
    this.imageURL,
    this.websiteURL,
    this.source,
  });
}
