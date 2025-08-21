class InfluencerDetailsModel {
  final int id;
  final String name;
  final String image;
  final String banner;
  final String bannerWeb;
  final String gender;
  final int isInWishlist;
  final String phone;
  final String phoneCode;
  final String? descriptionEn;
  final int productCount;
  final List<PopularItem> popularItems;

  InfluencerDetailsModel({
    required this.id,
    required this.name,
    required this.image,
    required this.banner,
    required this.bannerWeb,
    required this.gender,
    required this.isInWishlist,
    required this.phone,
    required this.phoneCode,
    this.descriptionEn,
    required this.productCount,
    required this.popularItems,
  });

  factory InfluencerDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return InfluencerDetailsModel(
      id: data['id'],
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      banner: data['banner'] ?? '',
      bannerWeb: data['banner_web'] ?? '',
      gender: data['gender'] ?? '',
      isInWishlist: data['is_in_wishlist'] ?? 0,
      phone: data['phone'] ?? '',
      phoneCode: data['phone_code'] ?? '',
      descriptionEn: json['meta']?['description_en'],
      productCount: data['product_count'] ?? 0,
      popularItems: (data['popular_items'] as List<dynamic>?)
              ?.map((e) => PopularItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PopularItem {
  final int productId;
  final String name;
  final String shortDescription;
  final String image;
  final String finalPrice;
  final Restaurant restaurant;

  PopularItem({
    required this.productId,
    required this.name,
    required this.shortDescription,
    required this.image,
    required this.finalPrice,
    required this.restaurant,
  });

  factory PopularItem.fromJson(Map<String, dynamic> json) {
    return PopularItem(
      productId: json['product_id'],
      name: json['name'] ?? '',
      shortDescription: json['short_description'] ?? '',
      image: json['image'] ?? '',
      finalPrice: json['final_price'] ?? '',
      restaurant: Restaurant.fromJson(json['restaurant']),
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String image;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
