import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/api_endpoints.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/core/util/parse_html_string.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import '../core/api_client.dart';

class RestaurantDetails extends StatefulWidget {
  final int productId;
  const RestaurantDetails({super.key, required this.productId});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  final ApiClient _api = ApiClient();
  Map<String, dynamic>? _product;
  Map<String, dynamic>? _meta;
  bool _isMenuExpanded = false; // place this in your state class

  bool _isLoading = true;
  String? _error;

  // Carousel
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductDetail();
  }

  Future<void> _fetchProductDetail() async {
    try {
      final response = await _api.post(
        "${ApiEndpoints.productDetails}${widget.productId}",
        {},
      );
      setState(() {
        _product = response['data'] ?? {};
        _meta = response['meta'] ?? {};
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
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

    if (_product == null || _product!.isEmpty) {
      return const Scaffold(body: Center(child: Text("Restaurant not found")));
    }

    final images =
        [_product!['logo'], _product!['banner']].whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(title: Text(_product!['name'] ?? "Restaurant")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------------- IMAGE CAROUSEL ----------------
            SizedBox(
              height: 250,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
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
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// ---------------- NAME + STATUS ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    _product!['name'] ?? "",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        _product!['status_color'].replaceFirst('#', '0xFF'))),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _product!['status'] == "O" ? "Open" : "Closed",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// ---------------- RATING ----------------
            Row(
              children: [
                ...List.generate(5, (index) {
                  double rating = (_product!['rating'] ?? 0).toDouble();
                  if (index + 1 <= rating) {
                    return const Icon(Icons.star,
                        color: Colors.amber, size: 20);
                  } else if (index + 0.5 <= rating) {
                    return const Icon(Icons.star_half,
                        color: Colors.amber, size: 20);
                  } else {
                    return const Icon(Icons.star_border,
                        color: Colors.amber, size: 20);
                  }
                }),
                const SizedBox(width: 6),
                Text(
                  "(${_product!['review_count']} reviews)",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// ---------------- DESCRIPTION ----------------
            Text(
              parseHtmlString(_meta?['description_en'] ?? ""),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            /// ---------------- ADDRESS ----------------
            if (_product!['restaurant_area'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),

                  // Main address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.blueAccent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${_product!['restaurant_area']['block_name']}, ${_product!['restaurant_area']['area_name']}, ${_product!['restaurant_area']['state_name']}, ${_product!['restaurant_area']['country_name']}",
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),

                  // Landmark if available
                  if (_product!['restaurant_area']['landmark'] != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Landmark: ${_product!['restaurant_area']['landmark']}",
                            style: TextStyle(
                                fontSize: 14.sp, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),

            /// ---------------- SUBCATEGORIES ----------------
            if ((_product!['subcategory'] as List).isNotEmpty) ...[
              Text("Our Specials",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: (_product!['subcategory'] as List).map((s) {
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
                          const SizedBox(height: 4),
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

            /// ---------------- MENU ----------------

            GestureDetector(
              onTap: () {
                setState(() => _isMenuExpanded = !_isMenuExpanded);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.glassAppBarBorder)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Menu",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Icon(
                        _isMenuExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

// Animated menu list
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Column(
                children: (_product!['items_list'] ?? []).map<Widget>((item) {
                  return Padding(
                    padding: ResponsiveHelper.scalePadding(context,
                        vertical: 15, horizontal: 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border:
                            Border.all(color: AppColors.glassAppBarBorder),
                        borderRadius: BorderRadius.circular(
                            ResponsiveHelper.scaleRadius(context, 12)),
                      ),
                      child: Padding(
                        padding: ResponsiveHelper.scalePadding(
                          context,
                          vertical: 12,
                          horizontal: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius:
                                  ResponsiveHelper.scaleWidth(context, 30),
                              backgroundColor: Colors.grey.shade800,
                              child: ClipOval(
                                child: Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  width: ResponsiveHelper.scaleWidth(
                                      context, 60),
                                  height: ResponsiveHelper.scaleWidth(
                                      context, 60),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.dining_sharp,
                                      size: ResponsiveHelper.scaleWidth(
                                          context, 28),
                                      color: Colors.white70,
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    ResponsiveHelper.scaleGap(context, 12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0),
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
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: ResponsiveHelper.scaleGap(
                                          context, 6)),
                                  Text(
                                    item['short_description'],
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              crossFadeState: _isMenuExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            /// ---------------- OPENING HOURS ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900, // dark background for contrast
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Today's Hours",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _product!['opening_hours'] ?? "-",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                    ),
                  ),
                  if (_product!['next_day'] != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Colors.orangeAccent),
                        const SizedBox(width: 8),
                        Text(
                          "Next (${_product!['next_day']})",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _product!['next_opening_hours'] ?? "-",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            /// ---------------- DELIVERY INFO ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade900, // dark background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart,
                          color: Colors.orangeAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Minimum Order",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${_product!['minimum_order']} KWD",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining,
                          color: Colors.greenAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Delivery Fee",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${_product!['delivery_fee']} KWD",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(
                        "Distance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${_product!['delivery_distance']} km",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ---------------- PAYMENT OPTIONS ----------------
            const SizedBox(height: 15),

            if ((_product!['payment_option'] as List).isNotEmpty) ...[
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
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (_product!['payment_option'] as List).map((p) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.network(
                        p['icon'],
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.payment, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:inovant/core/api_endpoints.dart';
// import 'package:inovant/core/constants/app_colors.dart';
// import 'package:inovant/core/util/responsive_helper.dart';
// import '../core/api_client.dart';

// class RestaurantDetails extends StatefulWidget {
//   final int productId;
//   const RestaurantDetails({super.key, required this.productId});

//   @override
//   State<RestaurantDetails> createState() => _RestaurantDetailsState();
// }

// class _RestaurantDetailsState extends State<RestaurantDetails> {
//   final ApiClient _api = ApiClient();
//   Map<String, dynamic>? _product;
//   String? _influencerName;
//   bool _isLoading = true;
//   String? _error;

//   // For carousel indicator
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProductDetail();
//   }

//   Future<void> _fetchProductDetail() async {
//     try {
//       final response = await _api.post(
//         "${ApiEndpoints.productDetails}${widget.productId}",
//         {},
//       );

//       final data = response['data'] ?? {};
//       // Get influencer reference from items_list if exists
//       String influencerName = "Unknown";
//       if ((data['items_list'] ?? []).isNotEmpty) {
//         influencerName =
//             data['items_list'][0]['item_category_name'] ?? "Unknown";
//       }

//       setState(() {
//         _product = data;
//         _influencerName = influencerName;
//       });
//     } catch (e) {
//       setState(() => _error = e.toString());
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (_error != null) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Product Detail")),
//         body: Center(child: Text("Error: $_error")),
//       );
//     }

//     if (_product == null || _product!.isEmpty) {
//       return const Scaffold(body: Center(child: Text("Product not found")));
//     }

//     final images =
//         [_product!['logo'], _product!['banner']].whereType<String>().toList();

//     return Scaffold(
//       appBar: AppBar(title: Text(_product!['name'] ?? "Product Detail")),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final isWide = constraints.maxWidth > 600;
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Image carousel with indicator
//                 SizedBox(
//                   height: isWide ? 400 : 250,
//                   child: Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       PageView(
//                         controller: _pageController,
//                         onPageChanged: (index) {
//                           setState(() {
//                             _currentPage = index;
//                           });
//                         },
//                         children: images
//                             .map((img) => Image.network(img, fit: BoxFit.cover))
//                             .toList(),
//                       ),
//                       Positioned(
//                         bottom: 8,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                             images.length,
//                             (index) => Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 4),
//                               width: _currentPage == index ? 10 : 8,
//                               height: _currentPage == index ? 10 : 8,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: _currentPage == index
//                                     ? const Color.fromARGB(255, 121, 121, 121)
//                                     : const Color.fromARGB(137, 255, 141, 141),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Name
//                 Text(
//                   _product!['name'] ?? "",
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 8),
//                 // Description (plain text)
//                 Text(
//                   _product!['description']?.replaceAll(
//                         RegExp(r'<[^>]*>'),
//                         '',
//                       ) ??
//                       "",
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 const SizedBox(height: 8),
//                 // Price (show minimum_order as example)
//                 Text(
//                   "Price: \$${_product!['minimum_order'] ?? '0.00'}",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium
//                       ?.copyWith(color: Colors.green),
//                 ),
//                 const SizedBox(height: 8),
//                 // Influencer reference
//                 Text(
//                   "Category/Influencer: $_influencerName",
//                   style: Theme.of(context)
//                       .textTheme
//                       .bodyMedium
//                       ?.copyWith(fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 // Products list
//                 Text("Items:", style: Theme.of(context).textTheme.titleMedium),
//                 const SizedBox(height: 8),
//                 ...(_product!['items_list'] ?? []).map<Widget>((item) {
//                   return Padding(
//                     padding: ResponsiveHelper.scalePadding(context,
//                         vertical: 15, horizontal: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 RestaurantDetails(productId: item['id']),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: AppColors.background,
//                           border:
//                               Border.all(color: AppColors.glassAppBarBorder),
//                           borderRadius: BorderRadius.circular(
//                             ResponsiveHelper.scaleRadius(context, 12),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: ResponsiveHelper.scalePadding(
//                             context,
//                             vertical: 12,
//                             horizontal: 12,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius:
//                                     ResponsiveHelper.scaleWidth(context, 30),
//                                 backgroundColor: Colors.grey.shade800,
//                                 backgroundImage: null, // remove this
//                                 child: ClipOval(
//                                   child: Image.network(
//                                     item['image'],
//                                     fit: BoxFit.cover,
//                                     width: ResponsiveHelper.scaleWidth(
//                                         context, 60),
//                                     height: ResponsiveHelper.scaleWidth(
//                                         context, 60),
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Icon(
//                                         Icons.dining_sharp,
//                                         size: ResponsiveHelper.scaleWidth(
//                                             context, 28),
//                                         color: Colors.white70,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(
//                                   width:
//                                       ResponsiveHelper.scaleGap(context, 12)),

//                               // Info Section
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Expanded(
//                                           child: Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 8.0),
//                                             child: Text(
//                                               item['name'],
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 16.sp,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           "\$ ${item['final_price']}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16.sp,
//                                               color: Colors.green),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                         height: ResponsiveHelper.scaleGap(
//                                             context, 6)),

//                                     // Phone
//                                     Text(
//                                       item['short_description'],
//                                       style: TextStyle(
//                                         fontSize: 14.sp,
//                                         color: Colors.white70,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
