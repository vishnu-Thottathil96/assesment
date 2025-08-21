// models/restaurant_detail.dart
class RestaurantDetailResponse {
  final bool success;
  final int status;
  final String message;
  final Meta? meta;
  final RestaurantDetail? data;

  RestaurantDetailResponse({
    required this.success,
    required this.status,
    required this.message,
    this.meta,
    this.data,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      data:
          json['data'] != null ? RestaurantDetail.fromJson(json['data']) : null,
    );
  }
}

class Meta {
  final String? titleEn;
  final String? titleAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final String? keywordsEn;
  final String? keywordsAr;

  Meta({
    this.titleEn,
    this.titleAr,
    this.descriptionEn,
    this.descriptionAr,
    this.keywordsEn,
    this.keywordsAr,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      titleEn: json['title_en'],
      titleAr: json['title_ar'],
      descriptionEn: json['description_en'],
      descriptionAr: json['description_ar'],
      keywordsEn: json['keywords_en'],
      keywordsAr: json['keywords_ar'],
    );
  }
}

class RestaurantDetail {
  final int id;
  final String? name;
  final String? logo;
  final String? banner;
  final double rating;
  final int reviewCount;
  final int? deliveryTime;
  final String? openingHours;
  final String? description;
  final String minimumOrder;
  final String deliveryFee;
  final double deliveryDistance;
  final String? status;
  final String? statusColor;
  final List<PaymentOption> paymentOption;
  final List<SubCategory> subcategory;
  final List<Item> itemsList;
  final RestaurantArea? restaurantArea;

  RestaurantDetail({
    required this.id,
    this.name,
    this.logo,
    this.banner,
    required this.rating,
    required this.reviewCount,
    this.deliveryTime,
    this.openingHours,
    this.description,
    required this.minimumOrder,
    required this.deliveryFee,
    required this.deliveryDistance,
    this.status,
    this.statusColor,
    required this.paymentOption,
    required this.subcategory,
    required this.itemsList,
    this.restaurantArea,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      banner: json['banner'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      deliveryTime: json['delivery_time'],
      openingHours: json['opening_hours'],
      description: json['description'],
      minimumOrder: json['minimum_order']?.toString() ?? '0.000',
      deliveryFee: json['delivery_fee']?.toString() ?? '0.000',
      deliveryDistance: (json['delivery_distance'] ?? 0).toDouble(),
      status: json['status'],
      statusColor: json['status_color'],
      paymentOption: (json['payment_option'] as List<dynamic>?)
              ?.map((e) => PaymentOption.fromJson(e))
              .toList() ??
          [],
      subcategory: (json['subcategory'] as List<dynamic>?)
              ?.map((e) => SubCategory.fromJson(e))
              .toList() ??
          [],
      itemsList: (json['items_list'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e))
              .toList() ??
          [],
      restaurantArea: json['restaurant_area'] != null
          ? RestaurantArea.fromJson(json['restaurant_area'])
          : null,
    );
  }
}

class PaymentOption {
  final String? type;
  final String? code;
  final String? icon;

  PaymentOption({this.type, this.code, this.icon});

  factory PaymentOption.fromJson(Map<String, dynamic> json) {
    return PaymentOption(
      type: json['type'],
      code: json['code'],
      icon: json['icon'],
    );
  }
}

class SubCategory {
  final int id;
  final String? name;
  final String? image;

  SubCategory({required this.id, this.name, this.image});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Item {
  final int id;
  final String? name;
  final String? shortDescription;
  final String? sku;
  final String finalPrice;
  final String? regularPrice;
  final String? image;
  final String? categoryName;

  Item({
    required this.id,
    this.name,
    this.shortDescription,
    this.sku,
    required this.finalPrice,
    this.regularPrice,
    this.image,
    this.categoryName,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
      sku: json['SKU']?.toString(),
      finalPrice: json['final_price']?.toString() ?? '0.000',
      regularPrice: json['regular_price']?.toString(),
      image: json['image'],
      categoryName: json['item_category_name']?.toString(),
    );
  }
}

class RestaurantArea {
  final String? stateName;
  final String? areaName;
  final String? blockName;
  final String? countryName;
  final String? street;
  final String? avenue;
  final String? landmark;

  RestaurantArea({
    this.stateName,
    this.areaName,
    this.blockName,
    this.countryName,
    this.street,
    this.avenue,
    this.landmark,
  });

  factory RestaurantArea.fromJson(Map<String, dynamic> json) {
    return RestaurantArea(
      stateName: json['state_name'],
      areaName: json['area_name'],
      blockName: json['block_name'],
      countryName: json['country_name'],
      street: json['street'],
      avenue: json['avenue'],
      landmark: json['landmark'],
    );
  }
}
