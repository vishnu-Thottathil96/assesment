import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovant/core/api_endpoints.dart';
import 'package:inovant/core/constants/app_colors.dart';
import 'package:inovant/core/constants/app_strings.dart';
import 'package:inovant/core/util/responsive_helper.dart';
import 'package:inovant/widgets/influencer_card.dart';
import 'package:inovant/widgets/influencer_shimmer_card.dart';
import '../core/api_client.dart';
import '../core/exception_handler.dart';
import '../models/influencer.dart';

class InfluencerListPage extends StatefulWidget {
  const InfluencerListPage({super.key});

  @override
  State<InfluencerListPage> createState() => _InfluencerListPageState();
}

class _InfluencerListPageState extends State<InfluencerListPage> {
  final ApiClient _api = ApiClient();
  final List<Influencer> _influencers = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInfluencers();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchInfluencers({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      if (refresh) {
        _page = 1;
        _influencers.clear();
        _hasMore = true;
      }

      final response = await _api.post("${ApiEndpoints.influencerList}$_page", {
        "filter": {"categories": ""},
      });

      final List<dynamic> data = response['data']?['influencer'] ?? [];
      final newInfluencers = data.map((e) => Influencer.fromJson(e)).toList();

      setState(() {
        _influencers.addAll(newInfluencers);
        _hasMore = newInfluencers.isNotEmpty;
        if (_hasMore) _page++;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoading) {
        _fetchInfluencers();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const double _appBarHeight = kToolbarHeight * 2;

  @override
  Widget build(BuildContext context) {
    if (_influencers.isEmpty && _isLoading) {
      return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(_appBarHeight),
        // child: AppBar(
        //   toolbarHeight: _appBarHeight,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.transparent,
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: [
        //           AppColors.gradientStart,
        //           AppColors.gradientEnd,
        //         ],
        //       ),
        //     ),
        //     child: SafeArea(
        //       bottom: false,
        //       child: Padding(
        //         padding: ResponsiveHelper.scalePadding(
        //           context,
        //           vertical: 10,
        //           horizontal: 16,
        //         ),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //           children: [
        //             Text(
        //               AppStrings.listPageHeading,
        //               style: TextStyle(
        //                 color: AppColors.headingText,
        //                 fontSize: 24.sp,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             Text(
        //               AppStrings.listPageSubHeading,
        //               style: TextStyle(
        //                 color: AppColors.subHeadingText,
        //                 fontSize: 14.sp,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // ),
        body: SafeArea(
            child: ListView.builder(
          itemBuilder: (context, index) => InfluencerShimmerCard(),
        )),
      );
    }

    if (_influencers.isEmpty && !_isLoading) {
      return Scaffold(
        body: ErrorFallback(
          message: "No influencers found",
          onRetry: () => _fetchInfluencers(refresh: true),
        ),
      );
    }

    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(_appBarHeight),
      //   child: AppBar(
      //     toolbarHeight: _appBarHeight,
      //     elevation: 0,
      //     automaticallyImplyLeading: false,
      //     backgroundColor: Colors.transparent,
      //     flexibleSpace: Container(
      //       decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //           begin: Alignment.topLeft,
      //           end: Alignment.bottomRight,
      //           colors: [
      //             AppColors.gradientStart,
      //             AppColors.gradientEnd,
      //           ],
      //         ),
      //       ),
      //       child: SafeArea(
      //         bottom: false,
      //         child: Padding(
      //           padding: ResponsiveHelper.scalePadding(
      //             context,
      //             vertical: 10,
      //             horizontal: 16,
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             mainAxisAlignment: MainAxisAlignment.spaceAround,
      //             children: [
      //               Text(
      //                 AppStrings.listPageHeading,
      //                 style: TextStyle(
      //                   color: AppColors.headingText,
      //                   fontSize: 24.sp,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               Text(
      //                 AppStrings.listPageSubHeading,
      //                 style: TextStyle(
      //                   color: AppColors.subHeadingText,
      //                   fontSize: 14.sp,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: () => _fetchInfluencers(refresh: true),
        displacement: 30,
        child: Padding(
          padding: ResponsiveHelper.scalePadding(context, vertical: 20),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _influencers.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < _influencers.length) {
                return InfluencerCard(influencer: _influencers[index]);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
