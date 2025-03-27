import 'package:flutter/material.dart';

class ShoeModel {
  final int id;
  String name;
  String model;
  double price;
  String imgAddress;
  Color modelColor;
  String? description;
  String? category;
  double? selectedSize;

  ShoeModel({
    required this.id,
    required this.name,
    required this.model,
    required this.price,
    required this.imgAddress,
    required this.modelColor,
    this.description,
    this.category,
    this.selectedSize,
  });

  // Convert to a format suitable for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'price': price,
      'image': imgAddress, // 🔥 Fix field name to match DB
      'description': description,
      'category': category,
      'selectedSize': selectedSize,
      'modelColor': modelColor.value, // 🔥 Store as int
    };
  }

  // Convert from database map to ShoeModel
  factory ShoeModel.fromMap(Map<String, dynamic> map) {
    return ShoeModel(
      id: map['id'],
      name: map['name'],
      model: map['model'] ?? '',
      price: (map['price'] as num).toDouble(),
      imgAddress: map['image'], // 🔥 Fix field name
      modelColor: Color(map['modelColor'] ?? 0xFF808080), // 🔥 Convert back to Color
      description: map['description'],
      category: map['category'],
      selectedSize: (map['selectedSize'] as num?)?.toDouble(),
    );
  }
}
