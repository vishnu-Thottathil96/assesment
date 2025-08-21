import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inovant/core/api_endpoints.dart';
import '../core/api_client.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ApiClient _api = ApiClient();
  Map<String, dynamic>? _product;
  String? _influencerName;
  bool _isLoading = true;
  String? _error;

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

      final data = response['data'] ?? {};
      // Get influencer reference from items_list if exists
      String influencerName = "Unknown";
      if ((data['items_list'] ?? []).isNotEmpty) {
        influencerName =
            data['items_list'][0]['item_category_name'] ?? "Unknown";
      }

      setState(() {
        _product = data;
        _influencerName = influencerName;
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
        appBar: AppBar(title: const Text("Product Detail")),
        body: Center(child: Text("Error: $_error")),
      );
    }

    if (_product == null || _product!.isEmpty) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }

    final images =
        [_product!['logo'], _product!['banner']].whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(title: Text(_product!['name'] ?? "Product Detail")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel
                SizedBox(
                  height: isWide ? 400 : 250,
                  child: PageView(
                    children:
                        images
                            .map((img) => Image.network(img, fit: BoxFit.cover))
                            .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  _product!['name'] ?? "",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                // Description (plain text)
                Text(
                  _product!['description']?.replaceAll(
                        RegExp(r'<[^>]*>'),
                        '',
                      ) ??
                      "",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                // Price (show minimum_order as example)
                Text(
                  "Price: \$${_product!['minimum_order'] ?? '0.00'}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.green),
                ),
                const SizedBox(height: 8),
                // Influencer reference
                Text(
                  "Category/Influencer: $_influencerName",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Products list
                Text("Items:", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...(_product!['items_list'] ?? []).map<Widget>((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        item['image'] ?? "",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name'] ?? ""),
                      subtitle: Text(
                        "${item['short_description'] ?? ""}\nPrice: \$${item['final_price'] ?? ""}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
