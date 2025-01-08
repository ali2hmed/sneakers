import 'package:flutter/material.dart';

import '../models/models.dart';

final List<ShoeModel> availableShoes = [
  ShoeModel(
    id: 1,
    name: "NIKE",
    model: "AIR-MAX",
    price: 130000,
    imgAddress: "assets/images/nike1.png",
    modelColor: const Color(0xffDE0106),
  ),
  ShoeModel(
    id: 2,
    name: "NIKE",
    model: "AIR-JORDAN MID",
    price: 190000,
    imgAddress: "assets/images/nike8.png",
    modelColor: const Color(0xff3F7943),
  ),
  ShoeModel(
    id: 3,
    name: "NIKE",
    model: "ZOOM",
    price: 160000,
    imgAddress: "assets/images/nike2.png",
    modelColor: const Color(0xffE66863),
  ),
  ShoeModel(
    id: 4,
    name: "NIKE",
    model: "Air-FORCE",
    price: 110000,
    imgAddress: "assets/images/nike3.png",
    modelColor: const Color(0xffD7D8DC),
  ),
  ShoeModel(
    id: 5,
    name: "NIKE",
    model: "AIR-JORDAN LOW",
    price: 150000,
    imgAddress: "assets/images/nike5.png",
    modelColor: const Color(0xff37376B),
  ),
  ShoeModel(
    id: 6,
    name: "NIKE",
    model: "ZOOM",
    price: 115000,
    imgAddress: "assets/images/nike4.png",
    modelColor: const Color(0xffE4E3E8),
  ),
  ShoeModel(
    id: 7,
    name: "NIKE",
    model: "AIR-JORDAN LOW",
    price: 150000,
    imgAddress: "assets/images/nike6.png",
    modelColor: const Color(0xff8C001A),
  ),
  ShoeModel(
    id: 8,
    name: "NIKE",
    model: "ZOOM",
    price: 175000,
    imgAddress: "assets/images/nike7.png",
    modelColor: const Color(0xff4D4D4),
  ),
];

List<ShoeModel> itemsOnBag = [];

final List<UserStatus> userStatus = [
  UserStatus(
    emoji: '😴',
    txt: "Away",
    selectColor: const Color(0xff121212),
    unSelectColor: const Color(0xffbfbfbf),
  ),
  UserStatus(
    emoji: '💻',
    txt: "At Work",
    selectColor: const Color(0xff05a35c),
    unSelectColor: const Color(0xffCEEBD9),
  ),
  UserStatus(
    emoji: '🎮',
    txt: "Gaming",
    selectColor: const Color(0xffFFD237),
    unSelectColor: const Color(0xffFDDFBB),
  ),
  UserStatus(
    emoji: '🤫',
    txt: "Busy",
    selectColor: const Color(0xffba3a3a),
    unSelectColor: const Color(0xffdb9797),
  ),
];

final List categories = [
  'All',
  'Nike',
  'Adidas',
  'Jordan',
  'Puma',
  'Gucci',
  'Tom Ford',
  'Koio',
];
final List featured = [
  'New',
  'Featured',
  'Upcoming',
];