import 'package:flutter/material.dart';
import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/db_helper.dart';

class AppMethods {
  static final dbHelper = DBHelper();

  static void addToCart(ShoeModel data, BuildContext context) async {
    if (data.selectedSize == null) {
      print('DEBUG: Size not selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a size first'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    try {
      print('DEBUG: Adding to cart - ID: ${data.id}, Size: ${data.selectedSize}');
      // TODO: Replace with actual logged-in user ID
      await dbHelper.addToCart(1, data);
      print('DEBUG: Successfully added to cart');
      
      // Verify the item was added by checking cart items
      final cartItems = await dbHelper.getCartItems(1);
      print('DEBUG: Current cart items: ${cartItems.length}');
      print('DEBUG: Cart items: $cartItems');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
    } catch (e, stackTrace) {
      print('DEBUG: Error adding to cart: $e');
      print('DEBUG: Stack trace: $stackTrace');
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