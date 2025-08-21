// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:inovant/screens/product_details.dart';
// import '../core/api_client.dart';

// class InfluencerDetailPage extends StatefulWidget {
//   final int influencerId;
//   const InfluencerDetailPage({super.key, required this.influencerId});

//   @override
//   State<InfluencerDetailPage> createState() => _InfluencerDetailPageState();
// }

// class _InfluencerDetailPageState extends State<InfluencerDetailPage> {
//   final ApiClient _api = ApiClient();
//   Map<String, dynamic>? _data;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchInfluencerDetail();
//   }

//   Future<void> _fetchInfluencerDetail() async {
//     try {
//       final response = await _api.get(
//         "/influencer-details?influencer_id=${widget.influencerId}&latlon=29.3677642,47.9705378&lang=en",
//       );

//       setState(() {
//         _data = response['data'];
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
//         appBar: AppBar(title: const Text("Influencer Detail")),
//         body: Center(child: Text("Error: $_error")),
//       );
//     }

//     if (_data == null) {
//       return const Scaffold(body: Center(child: Text("No data found")));
//     }

//     final products = List<Map<String, dynamic>>.from(
//       _data?['popular_items'] ?? [],
//     );

//     return Scaffold(
//       appBar: AppBar(title: Text(_data?['name'] ?? "Influencer")),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Banner
//             if (_data?['banner'] != null)
//               Image.network(
//                 _data!['banner'],
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),

//             // Profile
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundImage: NetworkImage(_data?['image'] ?? ""),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _data?['name'] ?? "",
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                         Text("Gender: ${_data?['gender'] ?? "-"}"),
//                         Text(
//                           "Phone: +${_data?['phone_code']} ${_data?['phone']}",
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(),

//             // Popular Items
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Text(
//                 "Popular Items",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//             ),
//             if (products.isEmpty)
//               const Padding(
//                 padding: EdgeInsets.all(16),
//                 child: Text("No popular items"),
//               )
//             else
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   final p = products[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) {
//                               return ProductDetailPage(
//                                 productId: p["product_id"],
//                                 // productId: 456,
//                               );
//                             },
//                           ),
//                         );
//                       },
//                       child: ListTile(
//                         leading: Image.network(
//                           p['image'],
//                           width: 60,
//                           fit: BoxFit.cover,
//                         ),
//                         title: Text(p['name']),
//                         subtitle: Text(p['short_description'] ?? ""),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               "\$${p['final_price']}",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             if (p['influencer_discount'] != null)
//                               Text(
//                                 "-${p['influencer_discount']}%",
//                                 style: const TextStyle(color: Colors.red),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),

//             const Divider(),

//             // Social
//             if ((_data?['instagram'] ?? "").isNotEmpty ||
//                 (_data?['snapchat'] ?? "").isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Social Links",
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     if ((_data?['instagram'] ?? "").isNotEmpty)
//                       Text("Instagram: ${_data?['instagram']}"),
//                     if ((_data?['snapchat'] ?? "").isNotEmpty)
//                       Text("Snapchat: ${_data?['snapchat']}"),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import 'package:inovant/screens/product_details.dart';
import '../core/api_client.dart';
import '../models/influencer_details_model.dart';

class InfluencerDetailPage extends StatefulWidget {
  final int influencerId;
  const InfluencerDetailPage({super.key, required this.influencerId});

  @override
  State<InfluencerDetailPage> createState() => _InfluencerDetailPageState();
}

class _InfluencerDetailPageState extends State<InfluencerDetailPage> {
  final ApiClient _api = ApiClient();
  InfluencerDetailsModel? _influencer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchInfluencerDetail();
  }

  Future<void> _fetchInfluencerDetail() async {
    try {
      final response = await _api.get(
        "/influencer-details?influencer_id=${widget.influencerId}&latlon=29.3677642,47.9705378&lang=en",
      );

      setState(() {
        _influencer = InfluencerDetailsModel.fromJson(response);
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
        appBar: AppBar(title: const Text("Influencer Detail")),
        body: Center(child: Text("Error: $_error")),
      );
    }

    if (_influencer == null) {
      return const Scaffold(body: Center(child: Text("No data found")));
    }

    final influencer = _influencer!;

    return Scaffold(
      appBar: AppBar(title: Text(influencer.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            if (influencer.banner.isNotEmpty)
              Image.network(
                influencer.banner,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            // Profile Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(influencer.image),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          influencer.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text("Gender: ${influencer.gender}"),
                        Text(
                            "Phone: +${influencer.phoneCode} ${influencer.phone}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Description
            if (influencer.descriptionEn != null &&
                influencer.descriptionEn!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  influencer.descriptionEn!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            const Divider(),

            // Popular Items Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Popular Items",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (influencer.popularItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text("No popular items"),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: influencer.popularItems.length,
                itemBuilder: (context, index) {
                  final item = influencer.popularItems[index];
                  return Padding(
                    padding: ResponsiveHelper.scalePadding(context,
                        vertical: 15, horizontal: 8),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        border: Border.all(color: AppColors.glassAppBarBorder),
                        borderRadius: BorderRadius.circular(
                          ResponsiveHelper.scaleRadius(context, 12),
                        ),
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
                              radius: ResponsiveHelper.scaleWidth(context, 30),
                              backgroundColor: Colors.grey.shade800,
                              backgroundImage: null, // remove this
                              child: ClipOval(
                                child: Image.network(
                                  item.image,
                                  fit: BoxFit.cover,
                                  width:
                                      ResponsiveHelper.scaleWidth(context, 60),
                                  height:
                                      ResponsiveHelper.scaleWidth(context, 60),
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
                                width: ResponsiveHelper.scaleGap(context, 12)),

                            // Info Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "\$${item.finalPrice}",
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

                                  // Phone
                                  Text(
                                    item.shortDescription,
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

                  // return Card(
                  //   margin: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 8,
                  //   ),
                  //   child:
                  //    ListTile(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) =>
                  //               ProductDetailPage(productId: p.productId),
                  //         ),
                  //       );
                  //     },
                  //     leading: Image.network(
                  //       p.image,
                  //       width: 60,
                  //       fit: BoxFit.cover,
                  //     ),
                  //     title: Text(p.name),
                  //     subtitle: Text(p.shortDescription),
                  //     trailing: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text(
                  //           "\$${p.finalPrice}",
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //         if (p.restaurant.name.isNotEmpty)
                  //           Text(
                  //             p.restaurant.name,
                  //             style: const TextStyle(
                  //               fontSize: 12,
                  //               color: Colors.grey,
                  //             ),
                  //           ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                },
              ),

            const Divider(),
          ],
        ),
      ),
    );
  }
}
