import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/db_helper.dart';

class AppMethods {
  static final dbHelper = DBHelper();

  static Future<int?> getUserId() async {
    // TODO: Replace this with actual user fetching logic
    return 1; // Example user ID, should be retrieved from login session
  }

  static void addToCart(ShoeModel data, BuildContext context) async {
    if (data.selectedSize == null) {
      if (kDebugMode) {
        print('DEBUG: Size not selected');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a size first'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    int? userId = await getUserId(); // Fetch the user ID dynamically
    if (userId == null) {
      if (kDebugMode) {
        print('DEBUG: User not logged in');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please log in to add items to the cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    try {
      int shoeId = data.id;
      double selectedSize = data.selectedSize!;
      String shoeName = data.name; // Define shoeName based on ShoeModel
      double shoePrice = data.price; // Define shoePrice based on ShoeModel
      int quantity = 1; // Default quantity

      if (kDebugMode) {
        print('DEBUG: Adding to cart - User ID: $userId, Shoe ID: $shoeId, Size: $selectedSize');
      }

      await dbHelper.addToCart(userId, shoeId, shoeName, shoePrice, quantity);

      if (kDebugMode) {
        print('DEBUG: Successfully added to cart');
      }

      // Verify the item was added by checking cart items
      final cartItems = await dbHelper.getCartItems(userId);
      if (kDebugMode) {
        print('DEBUG: Current cart items: ${cartItems.length}');
        print('DEBUG: Cart items: $cartItems');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('DEBUG: Error adding to cart: $e');
        print('DEBUG: Stack trace: $stackTrace');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  static double sumOfItemsOnBag() {
    double sumPrice = 0.0;
    for (ShoeModel bagModel in itemsOnBag) {
      sumPrice += bagModel.price;
    }
    return sumPrice;
  }
}
