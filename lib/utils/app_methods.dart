import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/db_helper.dart';

class AppMethods {
  static final dbHelper = DBHelper();

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

    try {
      if (kDebugMode) {
        print('DEBUG: Adding to cart - ID: ${data.id}, Size: ${data.selectedSize}');
      }
      await dbHelper.addToCart(1, data);
      if (kDebugMode) {
        print('DEBUG: Successfully added to cart');
      }
      
      // Verify the item was added by checking cart items
      final cartItems = await dbHelper.getCartItems(1);
      if (kDebugMode) {
        print('DEBUG: Current cart items: ${cartItems.length}');
      }
      if (kDebugMode) {
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
      }
      if (kDebugMode) {
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
      sumPrice = sumPrice + bagModel.price;
    }
    return sumPrice;
  }
}