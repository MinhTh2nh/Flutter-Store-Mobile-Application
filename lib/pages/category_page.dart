import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/product_detail_page.dart';
import '../components/product_tile.dart';
import '../model/cart_model.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, this.category, this.subcategory});

  final String? category;
  final String? subcategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category: ${category ?? subcategory}'),
      ),
      body: CategoryContent(
        category: category,
        subcategory: subcategory,
      ),
    );
  }
}

class CategoryContent extends StatefulWidget {
  const CategoryContent({super.key, this.category, this.subcategory});

  final String? category;
  final String? subcategory;

  @override
  // ignore: library_private_types_in_public_api
  _CategoryContentState createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchProducts();
    }
  }

  void _fetchProducts() {
    Provider.of<CartModel>(context, listen: false)
        .fetchProductByCategory(widget.category, widget.subcategory);
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                if (cartModel.isLoading && cartModel.shopItems.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = cartModel.shopItems.where((product) {
                  if (widget.category != null) {
                    return product['category_name'] == widget.category;
                  } else if (widget.subcategory != null) {
                    return product['sub_name'] == widget.subcategory;
                  }
                  return true;
                }).toList();

                if (items.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.1,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var product = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailPage(
                                  productId: product['product_id'],
                                ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ProductTile(
                          product_name: product['product_name'],
                          product_price: product["product_price"].toString(),
                          product_thumbnail: product["product_thumbnail"],
                          total_stock: product['total_stock'],
                          average_rating:
                          (product['average_rating'] as num?)?.toDouble() ??
                              0.0,
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      );
  }
}
