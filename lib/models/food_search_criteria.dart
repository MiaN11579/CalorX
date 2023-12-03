class FoodSearchCriteria {
  final String? query;
  final List<String>? dataType;
  final int? pageSize;
  final int? pageNumber;
  final String? sortBy;
  final String? sortOrder;
  final String? brandOwner;
  final List<String>? tradeChannel;
  final String? startDate;
  final String? endDate;

  FoodSearchCriteria(
      {this.query,
      this.dataType,
      this.pageSize,
      this.pageNumber,
      this.sortBy,
      this.sortOrder,
      this.brandOwner,
      this.tradeChannel,
      this.startDate,
      this.endDate});

  factory FoodSearchCriteria.fromJson(Map<String, dynamic> data) {
    final query = data['query'];
    final dataType = data['dateType'];
    final pageSize = data['pageSize'];
    final pageNumber = data['pageNumber'];
    final sortBy = data['sortBy'];
    final sortOrder = data['sortOrder'];
    final brandOwner = data['brandOwner'];
    final tradeChannel = data['tradeChannel'];
    final startDate = data['startDate'];
    final endDate = data['endDate'];

    return FoodSearchCriteria(
      query: query,
      dataType: dataType,
      pageSize: pageSize,
      pageNumber: pageNumber,
      sortBy: sortBy,
      sortOrder: sortOrder,
      brandOwner: brandOwner,
      tradeChannel: tradeChannel,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
