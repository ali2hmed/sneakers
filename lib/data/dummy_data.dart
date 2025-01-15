import 'package:flutter/material.dart';

import '../models/models.dart';

final List<ShoeModel> availableShoes = [
ShoeModel(
  id: 1,
  name: "NIKE",
  model: "AIR-MAX",
  price: 130000,
  imgAddress: "assets/images/nike1.png",
  modelColor: const Color(0xFFEF5350), // Soft red
),
ShoeModel(
  id: 2,
  name: "NIKE",
  model: "AIR-JORDAN MID",
  price: 190000,
  imgAddress: "assets/images/nike8.png",
  modelColor: const Color(0xFF66BB6A), // Fresh green
),
ShoeModel(
  id: 3,
  name: "NIKE",
  model: "ZOOM",
  price: 160000,
  imgAddress: "assets/images/nike2.png",
  modelColor: const Color(0xFFFFA726), // Bright orange
),
ShoeModel(
  id: 4,
  name: "NIKE",
  model: "Air-FORCE",
  price: 110000,
  imgAddress: "assets/images/nike3.png",
  modelColor: const Color(0xFFB0BEC5), // Light grey-blue
),
ShoeModel(
  id: 5,
  name: "NIKE",
  model: "AIR-JORDAN LOW",
  price: 150000,
  imgAddress: "assets/images/nike5.png",
  modelColor: const Color(0xFF5C6BC0), // Indigo
),
ShoeModel(
  id: 6,
  name: "NIKE",
  model: "ZOOM",
  price: 115000,
  imgAddress: "assets/images/nike4.png",
  modelColor: const Color(0xFFECEFF1), // Pale silver
),
ShoeModel(
  id: 7,
  name: "NIKE",
  model: "AIR-JORDAN LOW",
  price: 150000,
  imgAddress: "assets/images/nike6.png",
  modelColor: const Color(0xFFD81B60), // Hot pink
),
ShoeModel(
  id: 8,
  name: "NIKE",
  model: "ZOOM",
  price: 175000,
  imgAddress: "assets/images/nike7.png",
  modelColor: const Color.fromARGB(255, 72, 175, 226), // Cool grey-blue
),
ShoeModel(
  id: 9,
  name: "Adidas",
  model: "Ultraboost 22",
  price: 200000,
  imgAddress: "assets/images/adidas_ultraboost22.png",
  modelColor: const Color(0xFF64B5F6), // Sky blue
),
ShoeModel(
  id: 10,
  name: "Adidas",
  model: "NMD_R1",
  price: 180000,
  imgAddress: "assets/images/adidas_nmd_r1.png",
  modelColor: const Color(0xFFF06292), // Light pink
),
ShoeModel(
  id: 11,
  name: "Adidas",
  model: "Stan Smith",
  price: 150000,
  imgAddress: "assets/images/adidas_stan_smith.png",
  modelColor: const Color(0xFF81C784), // Soft green
),
ShoeModel(
  id: 12,
  name: "Adidas",
  model: "Superstar",
  price: 140000,
  imgAddress: "assets/images/adidas_superstar.png",
  modelColor: const Color(0xFFFFD54F), // Golden yellow
),
ShoeModel(
  id: 13,
  name: "Adidas",
  model: "Gazelle",
  price: 130000,
  imgAddress: "assets/images/adidas_gazelle.png",
  modelColor: const Color(0xFFBA68C8), // Purple
),
ShoeModel(
  id: 14,
  name: "Puma",
  model: "Puma RS-X",
  price: 180000,
  imgAddress: "assets/images/puma_rsx.png",
  modelColor: const Color(0xFF4FC3F7), // Light blue
),
ShoeModel(
  id: 15,
  name: "Puma",
  model: "Puma Future Rider",
  price: 170000,
  imgAddress: "assets/images/puma_future_rider.png",
  modelColor: const Color(0xFFE57373), // Light red
),
ShoeModel(
  id: 16,
  name: "Gucci",
  model: "Gucci Ace",
  price: 500000,
  imgAddress: "assets/images/gucci_ace.png",
  modelColor: const Color(0xFFBDBDBD), // Cool grey
),
ShoeModel(
  id: 17,
  name: "Gucci",
  model: "Gucci Rhyton",
  price: 480000,
  imgAddress: "assets/images/gucci_rhyton.png",
  modelColor: const Color(0xFFFFA000), // Amber
),
ShoeModel(
  id: 18,
  name: "Vans",
  model: "Old Skool",
  price: 120000,
  imgAddress: "assets/images/vans_old_skool.png",
  modelColor: const Color(0xFF7986CB), // Muted purple
),
ShoeModel(
  id: 19,
  name: "Vans",
  model: "Sk8-Hi",
  price: 130000,
  imgAddress: "assets/images/vans_sk8_hi.png",
  modelColor: const Color(0xFF90CAF9), // Baby blue
),
ShoeModel(
  id: 20,
  name: "New Balance",
  model: "574 Classic",
  price: 140000,
  imgAddress: "assets/images/new_balance_574.png",
  modelColor: const Color(0xFF66BB6A), // Soft green
),
ShoeModel(
  id: 21,
  name: "New Balance",
  model: "990v5",
  price: 210000,
  imgAddress: "assets/images/new_balance_990v5.png",
  modelColor: const Color(0xFF546E7A), // Slate grey
),
ShoeModel(
  id: 22,
  name: "Reebok",
  model: "Club C 85",
  price: 125000,
  imgAddress: "assets/images/reebok_club_c_85.png",
  modelColor: const Color(0xFFF9A825), // Golden yellow
),
ShoeModel(
  id: 23,
  name: "Reebok",
  model: "Nano X1",
  price: 160000,
  imgAddress: "assets/images/reebok_nano_x1.png",
  modelColor: const Color(0xFF9575CD), // Light purple
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
  'Puma',
  'Gucci',
  'Vans',
  'New Balance',
  'Reebok',
];

final List featured = [
  'New',
  'Featured',
  'Upcoming',
];