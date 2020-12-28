import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:products_watcher/dialog_service.dart/dialog_service.dart';
import 'package:products_watcher/main_screen/models/filter_model.dart';
import 'package:products_watcher/main_screen/models/product_model.dart';
import 'package:intl/intl.dart';

class FirebaseDb extends GetxService {
  FirebaseDatabase _database;
  DatabaseReference _twitterRef;
  DatabaseReference _craigslistRef;
  DatabaseReference _reddittRef;
  DatabaseReference _ebayRef;
  DatabaseReference _filtersRef;

  DialogService _dialogService;

  Future<void> init() async {
    await Firebase.initializeApp();
    _database = FirebaseDatabase();

    _dialogService = Get.find();

    _twitterRef = _database.reference().child("Twitter_search");
    _craigslistRef = _database.reference().child("craigslist");
    _reddittRef = _database.reference().child("reddit_items");
    _ebayRef = _database.reference().child("eBay_Items");
    _filtersRef = _database.reference().child("filters");
  }

  Future<List<FilterModel>> getFilters() async {
    try {
      var result = await _filtersRef.once();
      if (result.value == null) return [];
      var list = Map<dynamic, dynamic>.from(result?.value)?.values?.toList();
      if (list == null) return null;
      return list.map((i) => FilterModel.fromJSON(i)).toList();
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }

  Future<void> addFilter(FilterModel filter) async {
    try {
      await _filtersRef.child(filter.name).set(filter.toJSON());
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  Future<void> deleteFilter(String name) async {
    try {
      await _filtersRef.child(name).remove();
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  Future<List<ProductModel>> getTwitterProducts() async {
    try {
      var result = await _twitterRef.once();
      var products = <ProductModel>[];
      var topCategory =
          Map<dynamic, dynamic>.from(result.value).values.toList();
      var yugiohSell = Map<dynamic, dynamic>.from(topCategory[0]);
      var yugiohSelling = Map<dynamic, dynamic>.from(topCategory[1]);

      yugiohSell["statuses"].forEach((i) {
        try {
          products.add(
            ProductModel(
              title: i["text"],
              imageURL: i["user"]["profile_image_url"],
              createdAt: parseDate(i["created_at"]),
              websiteURL: "https://twitter.com/" +
                  i["user"]["screen_name"] +
                  "/status/" +
                  i["id_str"],
              source: Source.TWITTER,
            ),
          );
        } catch (e) {}
      });

      yugiohSelling["statuses"].forEach((i) {
        try {
          products.add(
            ProductModel(
              title: i["text"],
              imageURL: i["user"]["profile_image_url"],
              createdAt: parseDate(i["created_at"]),
              websiteURL: "https://twitter.com/" +
                  i["user"]["screen_name"] +
                  "/status/" +
                  i["id_str"],
              source: Source.TWITTER,
            ),
          );
        } catch (e) {}
      });
      return products;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }

  Future<List<ProductModel>> getCraigsListProducts() async {
    try {
      var result = await _craigslistRef.once();
      var products = <ProductModel>[];
      var list = Map<dynamic, dynamic>.from(result.value).values;
      list.forEach((i) => i.forEach((k) {
            try {
              products.add(
                ProductModel(
                  title: k["title"],
                  price: parsePrice(k["price"]),
                  priceString: k["price"],
                  websiteURL: k["url"],
                  createdAt: parseDate(k["date"]),
                  source: Source.CRAGSLIST,
                ),
              );
            } catch (e) {}
          }));

      return products;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }

  Future<List<ProductModel>> getRedditProducts() async {
    try {
      var result = await _reddittRef.once();
      var products = <ProductModel>[];
      var list = Map<dynamic, dynamic>.from(result.value).values;
      try {
        for (var i in list) {
          products.add(
            ProductModel(
              title: i["title"],
              price: 0,
              priceString: "\$0",
              websiteURL: i["url"],
              createdAt: parseDate(i["created_utc"]),
              source: Source.REDDIT,
            ),
          );
        }
      } catch (e) {}

      return products;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }

  Future<List<ProductModel>> getEbayProducts() async {
    try {
      var result = await _ebayRef.once();
      var products = <ProductModel>[];
      var list = Map<dynamic, dynamic>.from(result.value).values;
      for (var i in list) {
        try {
          products.add(
            ProductModel(
              title: i["title"][0],
              price: parsePrice(i["sellingStatus"][0]["convertedCurrentPrice"]
                  [0]["__value__"]),
              priceString: "\$" +
                  i["sellingStatus"][0]["convertedCurrentPrice"][0]["__value__"]
                      .toString(),
              imageURL: i["pictureURLLarge"][0],
              websiteURL: i["viewItemURL"][0],
              createdAt: parseDate(i["listingInfo"][0]["startTime"][0]),
              source: Source.EBAY,
            ),
          );
        } catch (e) {}
      }

      return products;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }

  double parsePrice(String price) {
    try {
      if (price == null) return 0;
      price = price.replaceAll(r'$', '');
      price = price.replaceAll(r',', '');
      var val = double.tryParse(price);
      return val ?? 0.0;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return 0.0;
    }
  }

  DateTime parseDate(dynamic rawDate) {
    try {
      int timestamp = int.tryParse(rawDate.toString());
      DateTime date;
      if (timestamp != null) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        return date;
      }

      date = DateTime.tryParse(rawDate);
      if (date != null) return date;

      //Thu Dec 24 10:48:19 +0000 2020
      //the following format doesn't work, don't know why cause the pattern looks right
      //did filed an issue here https://github.com/dart-lang/intl/issues/345
      // DateFormat format = new DateFormat("EEE MMM DD hh:mm:ss Z yyyy");

      //so just parse the month and day and parse the year manually for now
      DateFormat format = new DateFormat("EEE MMM DD hh:mm:ss");
      date = format.parse(rawDate);

      String strDate = rawDate.toString();
      int year = int.parse(strDate.substring(strDate.length - 4));
      date = DateTime(year, date.month, date.day, date.hour, date.minute,
          date.second, date.millisecond, date.microsecond);

      return date;
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return null;
    }
  }
}
