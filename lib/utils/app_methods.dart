import 'package:flutter/material.dart';

import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/widget/snack_bar.dart';

import '../models/models.dart';

class AppMethods {
  AppMethods._();
  
  static void addToCart(ShoeModel data, BuildContext context) {
    if (data.selectedSize == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a size before adding to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool contains = itemsOnBag.contains(data);

    if (contains) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(failedSnackBar());
    } else {
      itemsOnBag.add(data);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart (Size: ${data.selectedSize})'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
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