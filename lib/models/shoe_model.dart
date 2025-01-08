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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'price': price,
      'image': imgAddress,
      'description': description,
      'category': category,
      'selectedSize': selectedSize,
    };
  }

  factory ShoeModel.fromMap(Map<String, dynamic> map) {
    return ShoeModel(
      id: map['id'],
      name: map['name'],
      model: map['model'],
      price: map['price'],
      imgAddress: map['image'],
      modelColor: Colors.grey,
      description: map['description'],
      category: map['category'],
      selectedSize: map['selectedSize']?.toDouble(),
    );
  }
}