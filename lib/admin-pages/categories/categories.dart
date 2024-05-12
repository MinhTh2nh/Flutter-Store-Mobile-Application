import 'package:flutter/material.dart';
import 'package:food_mobile_app/admin-pages/categories/category_detail_page.dart';
import 'package:food_mobile_app/admin-pages/categories/small_components/category_form.dart';
import 'package:food_mobile_app/components/category_tile.dart';
import '../../components/slide_menu.dart';
import 'package:food_mobile_app/admin-pages/products/small_components/create_button.dart';
import '../../components/custome_app_bar/custom_app_bar_admin.dart';
import '../../model/cart_model.dart';
import 'package:provider/provider.dart';

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({Key? key}) : super(key: key);

  static String routeName = "/admin/categories";

  @override
  _AdminCategoryPageState createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  // Define the callback function
  void updateCategoryList() {
    Provider.of<CartModel>(context, listen: false).fetchCategories();
  }

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        Provider.of<CartModel>(context, listen: false).fetchCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: SideMenu(),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text(
                    "List Of Categories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  buttonAdmin(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategoryCreationForm(onUpdate: updateCategoryList)),
                      );
                    },
                    title: "NEW",
                    color: Colors.teal.shade200,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                if (cartModel.categories.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartModel.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.1,
                  ),
                  itemBuilder: (context, index) {
                    var category = cartModel.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailPage(
                              index: category['category_id'],
                              onUpdate: updateCategoryList,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            child: Stack(
                              children: [
                                CategoryTile(
                                  category_name: category['category_name'],
                                  category_description: category["category_description"].toString(),
                                  category_thumbnail: category["category_thumbnail"],
                                  onPressed: () {}, // Placeholder onPressed function
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
