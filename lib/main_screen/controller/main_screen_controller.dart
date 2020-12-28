import 'package:get/get.dart';
import 'package:products_watcher/dialog_service.dart/dialog_service.dart';
import 'package:products_watcher/main_screen/models/filter_model.dart';
import 'package:products_watcher/main_screen/models/product_model.dart';
import 'package:products_watcher/services/firebase_db.dart';
import 'package:products_watcher/services/notification_service.dart';

class MainScreenController extends GetxController {
  @override
  void onInit() async {
    try {
      super.onInit();
      isLoading.value = true;

      Get.put(DialogService());
      await Get.put(FirebaseDb()).init();
      await Get.put(NotificationSerive()).init();
      _firebaseDb = Get.find();
      _dialogService = Get.find();

      await loadFilters();
      await loadProducts();

      isLoading.value = false;
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  FirebaseDb _firebaseDb;
  DialogService _dialogService;
  final _products = <ProductModel>[].obs;
  final isLoading = false.obs;
  final isAddingFilter = false.obs;
  final isDeletingFilter = false.obs;
  final selectedFilter = Rx<FilterModel>();
  final currentFilter = Rx<FilterModel>();
  final filters = <FilterModel>[].obs;
  List<ProductModel> get products =>
      filteredProducts(currentFilter.value, _products.value);

  setCurrentFilter(FilterModel filter) => currentFilter.value = filter;

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      _products.value = [];

      var cragslistItems = await _firebaseDb.getCraigsListProducts();
      var twitterItems = await _firebaseDb.getTwitterProducts();
      var redditItems = await _firebaseDb.getRedditProducts();
      var eBayItems = await _firebaseDb.getEbayProducts();

      if (cragslistItems != null) _products.addAll(cragslistItems);
      if (twitterItems != null) _products.addAll(twitterItems);
      if (redditItems != null) _products.addAll(redditItems);
      if (eBayItems != null) _products.addAll(eBayItems);

      products.sort((k, i) => i.createdAt.compareTo(k.createdAt));

      isLoading.value = false;
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  Future<void> loadFilters() async {
    try {
      filters.value = await _firebaseDb.getFilters();
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  addFilter(FilterModel filter) async {
    try {
      isAddingFilter.value = true;
      await _firebaseDb.addFilter(filter);
      await loadFilters();
      selectedFilter.value = null;
      isAddingFilter.value = false;
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  deleteFilter(String name) async {
    try {
      isDeletingFilter.value = true;

      await _firebaseDb.deleteFilter(name);
      await loadFilters();

      isDeletingFilter.value = false;
    } catch (e) {
      _dialogService.showErrorDialog(e);
    }
  }

  List<ProductModel> filteredProducts(
      FilterModel filter, List<ProductModel> products) {
    try {
      if (filter == null) return products;

      return products.where((i) {
        var inSearch = false;
        var inRange = false;
        //filter text
        if (filter.searchText.isEmpty ||
            !filter.notSearchText ==
                (i.title != null &&
                    i.title
                        .toLowerCase()
                        .contains(filter.searchText.toLowerCase())))
          inSearch = true;

        if (!filter.notInRange ==
            ((filter.minPrice == null || i.price >= filter.minPrice) &&
                (filter.maxPrice == null || i.price <= filter.maxPrice)))
          inRange = true;

        return inSearch && inRange;
      }).toList();
    } catch (e) {
      _dialogService.showErrorDialog(e);
      return [];
    }
  }
}
