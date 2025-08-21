import 'package:flutter/material.dart';
import 'restaurant_search_page.dart';
import 'influencer_list_page.dart';
import '../core/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to animation for smooth tab selection updates
    _tabController.animation!.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isTabSelected(int tabIndex) {
    // Use animation value to determine selected tab
    final animationValue = _tabController.animation!.value;
    return (animationValue.round() == tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.gradientStart,
        title: const Text("Zwara"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Custom Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _tabController.animateTo(0),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isTabSelected(0) ? Colors.white : Colors.white12,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Influencers",
                        style: TextStyle(
                          color: isTabSelected(0)
                              ? AppColors.gradientStart
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _tabController.animateTo(1),
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isTabSelected(1) ? Colors.white : Colors.white12,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Restaurants",
                        style: TextStyle(
                          color: isTabSelected(1)
                              ? AppColors.gradientStart
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                InfluencerListPage(),
                RestaurantSearchPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
