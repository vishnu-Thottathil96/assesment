class Influencer {
  final int id;
  final String name;
  final String image;
  final String gender;
  final int isInWishlist;
  final String phone;
  final String phoneCode;

  Influencer({
    required this.id,
    required this.name,
    required this.image,
    required this.gender,
    required this.isInWishlist,
    required this.phone,
    required this.phoneCode,
  });

  factory Influencer.fromJson(Map<String, dynamic> json) {
    return Influencer(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      isInWishlist: json['is_in_wishlist'] ?? 0,
      phone: json['phone'] ?? '',
      phoneCode: json['phone_code'] ?? '',
    );
  }
}
