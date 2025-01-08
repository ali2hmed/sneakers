import 'package:flutter/material.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/view/detail/detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      // TODO: Replace with actual logged-in user ID
      final favorites = await DBHelper().getFavorites(1); // Using ID 1 for testing
      setState(() {
        favoriteItems = favorites;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        favoriteItems = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorites: $e')),
      );
    }
  }

  void _navigateToDetail(Map<String, dynamic> item) {
    final model = ShoeModel(
      id: item['id'],
      name: item['name'],
      model: item['model'],
      price: item['price'].toDouble(),
      imgAddress: item['image'],
      modelColor: Colors.grey, // You might want to store and retrieve the actual color
      description: item['description'],
      category: item['category'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          model: model,
          isComeFromMoreSection: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstantsColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Favorites',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppConstantsColor.materialButtonColor,
              ),
            )
          : favoriteItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: AppConstantsColor.materialButtonColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Add items to your favorites',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
                    return Dismissible(
                      key: Key(item['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
                      ),
                      onDismissed: (direction) async {
                        await DBHelper().removeFavorite(1, item['id']);
                        setState(() {
                          favoriteItems.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item removed from favorites'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black87,
                          ),
                        );
                      },
                      child: GestureDetector(
                        onTap: () => _navigateToDetail(item),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                padding: EdgeInsets.all(16),
                                child: Hero(
                                  tag: item['image'],
                                  child: Image.asset(
                                    item['image'],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        item['model'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '\$${item['price'].toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppConstantsColor.materialButtonColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
