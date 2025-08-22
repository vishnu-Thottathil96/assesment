class RestaurantDetailsModel {
  final String? name;
  final String? logo;
  final String? banner;
  final String? status;
  final String? statusColor;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? restaurantArea;
  final List<dynamic> subcategory;
  final List<dynamic> itemsList;
  final String? openingHours;
  final String? nextDay;
  final String? nextOpeningHours;
  final String? minimumOrder;
  final String? deliveryFee;
  final String? deliveryDistance;
  final List<dynamic> paymentOptions;

  RestaurantDetailsModel({
    this.name,
    this.logo,
    this.banner,
    this.status,
    this.statusColor,
    this.rating = 0,
    this.reviewCount = 0,
    this.restaurantArea,
    this.subcategory = const [],
    this.itemsList = const [],
    this.openingHours,
    this.nextDay,
    this.nextOpeningHours,
    this.minimumOrder,
    this.deliveryFee,
    this.deliveryDistance,
    this.paymentOptions = const [],
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsModel(
      name: json['name'],
      logo: json['logo'],
      banner: json['banner'],
      status: json['status'],
      statusColor: json['status_color'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      restaurantArea: json['restaurant_area'],
      subcategory: json['subcategory'] ?? [],
      itemsList: json['items_list'] ?? [],
      openingHours: json['opening_hours'],
      nextDay: json['next_day'],
      nextOpeningHours: json['next_opening_hours'],
      minimumOrder: json['minimum_order']?.toString(),
      deliveryFee: json['delivery_fee']?.toString(),
      deliveryDistance: json['delivery_distance']?.toString(),
      paymentOptions: json['payment_option'] ?? [],
    );
  }
}
