import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/api_endpoints.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/core/util/parse_html_string.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import 'package:inovant/models/restaurent_details_model.dart';
import 'package:inovant/widgets/vertical_gap.dart';
import '../core/api_client.dart';

class RestaurantDetails extends StatefulWidget {
  final int productId;
  const RestaurantDetails({super.key, required this.productId});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  final ApiClient _api = ApiClient();
  final PageController _pageController = PageController();

  RestaurantDetailsModel? _restaurant;
  Map<String, dynamic>? _meta;
  bool _isMenuExpanded = false;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetail();
  }

  Future<void> _fetchRestaurantDetail() async {
    try {
      final response = await _api.post(
        "${ApiEndpoints.productDetails}${widget.productId}",
        {},
      );
      setState(() {
        _restaurant = RestaurantDetailsModel.fromJson(response['data'] ?? {});
        _meta = response['meta'] ?? {};
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Color _parseHexColor(String? hex, {Color fallback = Colors.grey}) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      final normalized =
          hex.startsWith('#') ? hex.replaceFirst('#', '0xFF') : hex;
      return Color(int.parse(normalized));
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Restaurant Detail")),
        body: Center(child: Text("Error: $_error")),
      );
    }

    if (_restaurant == null) {
      return const Scaffold(body: Center(child: Text("Restaurant not found")));
    }

    final images =
        [_restaurant!.logo, _restaurant!.banner].whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(title: Text(_restaurant!.name ?? "Restaurant")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(images),
            const VerticalGap(18),
            _buildHeader(context),
            const VerticalGap(10),
            _buildRating(context),
            const VerticalGap(12),
            _buildDescription(),
            const VerticalGap(16),
            _buildAddressSection(),
            _buildSubcategories(),
            _buildMenuToggle(context),
            const VerticalGap(8),
            _buildMenuList(),
            _buildOpeningHours(),
            _buildDeliveryInfo(),
            const VerticalGap(15),
            _buildPaymentOptions(),
          ],
        ),
      ),
    );
  }

  /// ---------------- WIDGET BUILDERS ----------------

  Widget _buildImageCarousel(List<String> images) {
    return SizedBox(
      height: ResponsiveHelper.scaleHeight(context, 230),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            children: images
                .map((img) => Image.network(img, fit: BoxFit.cover))
                .toList(),
          ),
          if (images.length > 1)
            Positioned(
              bottom: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 10 : 8,
                    height: _currentPage == index ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _restaurant!.name ?? "",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _parseHexColor(_restaurant!.statusColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _restaurant!.status == "O" ? "Open" : "Closed",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final rating = _restaurant!.rating.toDouble();
          if (index + 1 <= rating) {
            return const Icon(Icons.star, color: Colors.amber, size: 20);
          } else if (index + 0.5 <= rating) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 20);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 20);
          }
        }),
        const SizedBox(width: 6),
        Text(
          "(${_restaurant!.reviewCount} reviews)",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      parseHtmlString(_meta?['description_en'] ?? ""),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildAddressSection() {
    if (_restaurant!.restaurantArea == null) return const SizedBox();

    final area = _restaurant!.restaurantArea!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalGap(6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${area['block_name']}, ${area['area_name']}, "
                "${area['state_name']}, ${area['country_name']}",
                style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              ),
            ),
          ],
        ),
        if (area['landmark'] != null) ...[
          const VerticalGap(4),
          Row(
            children: [
              const Icon(Icons.place, color: Colors.redAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Landmark: ${area['landmark']}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
        const VerticalGap(20),
      ],
    );
  }

  Widget _buildSubcategories() {
    if (_restaurant!.subcategory.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Our Specials", style: Theme.of(context).textTheme.titleMedium),
        const VerticalGap(6),
        SizedBox(
          height: ResponsiveHelper.scaleHeight(context, 100),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _restaurant!.subcategory.map((s) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                width: 100,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        s['image'],
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const VerticalGap(4),
                    Text(
                      s['name'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuToggle(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isMenuExpanded = !_isMenuExpanded),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.glassAppBarBorder),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("View Menu", style: Theme.of(context).textTheme.titleMedium),
            Icon(
              _isMenuExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList() {
    return AnimatedCrossFade(
      firstChild: const SizedBox(),
      secondChild: Column(
        children: _restaurant!.itemsList.map<Widget>((item) {
          return Padding(
            padding: ResponsiveHelper.scalePadding(context,
                vertical: 15, horizontal: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.glassAppBarBorder),
                borderRadius: BorderRadius.circular(
                    ResponsiveHelper.scaleRadius(context, 12)),
              ),
              padding: ResponsiveHelper.scalePadding(context,
                  vertical: 12, horizontal: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: ResponsiveHelper.scaleWidth(context, 30),
                    backgroundColor: Colors.grey.shade800,
                    child: ClipOval(
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        width: ResponsiveHelper.scaleWidth(context, 60),
                        height: ResponsiveHelper.scaleWidth(context, 60),
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.dining_sharp,
                          size: ResponsiveHelper.scaleWidth(context, 28),
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.scaleGap(context, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "\$ ${item['final_price']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveHelper.scaleGap(context, 6)),
                        Text(
                          item['short_description'],
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      crossFadeState: _isMenuExpanded
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildOpeningHours() {
    return _buildInfoCard(
      icon: Icons.access_time,
      iconColor: Colors.greenAccent,
      title: "Today's Hours",
      content: _restaurant!.openingHours ?? "-",
      extra: _restaurant!.nextDay != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalGap(8),
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.orangeAccent),
                    const SizedBox(width: 8),
                    Text(
                      "Next (${_restaurant!.nextDay})",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const VerticalGap(4),
                Text(
                  _restaurant!.nextOpeningHours ?? "-",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildDeliveryInfo() {
    return _buildInfoCard(
      icon: Icons.shopping_cart,
      iconColor: Colors.orangeAccent,
      title: "Minimum Order",
      content: "${_restaurant!.minimumOrder} KWD",
      extra: Column(
        children: [
          const VerticalGap(8),
          _buildInfoRow(
            icon: Icons.delivery_dining,
            color: Colors.greenAccent,
            label: "Delivery Fee",
            value: "\$ ${_restaurant!.deliveryFee}",
          ),
          const VerticalGap(8),
          _buildInfoRow(
            icon: Icons.location_on,
            color: Colors.redAccent,
            label: "Distance",
            value: "${_restaurant!.deliveryDistance} km",
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions() {
    if (_restaurant!.paymentOptions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.payment, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Text(
              "Payment Options",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const VerticalGap(8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _restaurant!.paymentOptions.map((p) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.network(
                  p['icon'],
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.payment, color: Colors.black54),
                ),
              );
            }).toList(),
          ),
        ),
        const VerticalGap(12),
      ],
    );
  }

  /// ---------------- SMALL HELPERS ----------------

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    Widget? extra,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Text(
                content,
                style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              ),
            ],
          ),
          if (extra != null) extra,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, color: Colors.white70),
        ),
      ],
    );
  }
}
