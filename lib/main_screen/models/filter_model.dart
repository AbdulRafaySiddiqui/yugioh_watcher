class FilterModel {
  String name;
  String searchText;
  double minPrice;
  double maxPrice;
  bool notSearchText;
  bool notInRange;

  FilterModel({
    this.name,
    this.searchText,
    this.minPrice,
    this.maxPrice,
    this.notSearchText = false,
    this.notInRange = false,
  });

  FilterModel.fromJSON(Map<dynamic, dynamic> map)
      : searchText = map["searchText"],
        name = map["name"],
        minPrice = map["minPrice"] == null
            ? 0.0
            : double.parse(map["minPrice"].toString()),
        maxPrice = map["maxPrice"] == null
            ? 0.0
            : double.parse(map["maxPrice"].toString()),
        notInRange = map["notInRange"] ?? false,
        notSearchText = map["notSearchText"] ?? false;

  toJSON() {
    return {
      "searchText": searchText,
      "minPrice": minPrice,
      "maxPrice": maxPrice,
      "name": name,
      "notInRange": notInRange,
      "notSearchText": notSearchText,
    };
  }
}
