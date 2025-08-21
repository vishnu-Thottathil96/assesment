import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inovant/screens/restaurant_details.dart';
import 'package:inovant/widgets/influencer_shimmer_card.dart';
import '../core/api_client.dart';
import '../core/constants/app_colors.dart';

class RestaurantSearchPage extends StatefulWidget {
  const RestaurantSearchPage({super.key});

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  final ApiClient _api = ApiClient();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  List<dynamic> _results = [];
  bool _isLoading = false;
  String? _error;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchResults('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchResults(value);
    });
  }

  Future<void> _fetchResults(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _api.post(
        '/restaurant-search',
        {
          "search": query,
          "category_id": "",
          "latlon": "29.3677642,47.9705378",
          "user_id": ""
        },
      );

      final data = response['data'];
      if (data != null && data['restaurants'] is List) {
        setState(() => _results = data['restaurants']);
      } else {
        setState(() => _results = []);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
            const SizedBox(height: 16),

            // Results
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoading
                    ? InfluencerShimmerCard()
                    : _error != null
                        ? Center(child: Text("Error: $_error"))
                        : _results.isEmpty
                            ? const Center(child: Text("No results found"))
                            : ListView.builder(
                                key: ValueKey(_results.length),
                                itemCount: _results.length,
                                itemBuilder: (context, index) {
                                  final item = _results[index];
                                  return Card(
                                    color: AppColors.background,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(12),
                                      leading: item['logo'] != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                item['logo'],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                    Icons.restaurant,
                                                    size: 50,
                                                    color: Colors.white70,
                                                  );
                                                },
                                              ),
                                            )
                                          : const Icon(Icons.restaurant),
                                      title: Text(
                                        item['name'] ?? 'Unnamed',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 4),
                                          Text(
                                            "Rating: ${item['rating'] ?? '-'}",
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                          const SizedBox(height: 2),
                                          if (item['item_category'] != null)
                                            Text(
                                              item['item_category'],
                                              style: const TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 12),
                                            ),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white70,
                                        size: 16,
                                      ),
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return RestaurantDetails(
                                                productId: item["id"]);
                                          },
                                        ));
                                      },
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
