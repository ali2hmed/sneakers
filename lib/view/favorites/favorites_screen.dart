import 'package:flutter/material.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstantsColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Favorites',
          style: AppThemes.homeAppBar,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favoriteItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: favoriteItems.length,
                  itemBuilder: (context, index) {
                    final item = favoriteItems[index];
                    return Dismissible(
                      key: Key(item['id'].toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await DBHelper().removeFavorite(1, item['id']);
                        setState(() {
                          favoriteItems.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item removed from favorites')),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.only(bottom: 16),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(item['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            '${item['name']} ${item['model']}',
                            style: AppThemes.homeProductModel,
                          ),
                          subtitle: Text(
                            '\$${item['price']}',
                            style: AppThemes.homeProductPrice,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
