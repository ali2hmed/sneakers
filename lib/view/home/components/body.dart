import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/view/detail/detail_screen.dart';

import '../../../../animation/fadeanimation.dart';
import '../../../../models/models.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int selectedIndexOfCategory = 0;
  int selectedIndexOfFeatured = 1;
  Map<int, bool> favoriteStatus = {};
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    // TODO: Replace with actual logged-in user ID
    for (var item in availableShoes) {
      final isFav = await dbHelper.isFavorite(1, item.id);
      if (mounted) {
        setState(() {
          favoriteStatus[item.id] = isFav;
        });
      }
    }
  }

  Future<void> _toggleFavorite(int shoeId) async {
    // TODO: Replace with actual logged-in user ID
    final userId = 1;
    final isFavorite = favoriteStatus[shoeId] ?? false;

    if (isFavorite) {
      await dbHelper.removeFavorite(userId, shoeId);
    } else {
      await dbHelper.addFavorite(userId, shoeId);
    }

    if (mounted) {
      setState(() {
        favoriteStatus[shoeId] = !isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        topCategoriesWidget(width, height),
        SizedBox(height: 10),
        middleCategoriesWidget(width, height),
        SizedBox(height: 5),
        moreTextWidget(),
        lastCategoriesWidget(width, height),
      ],
    );
  }

// Top Categories Widget Components
  topCategoriesWidget(width, height) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: width,
          height: height / 18,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndexOfCategory = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                          fontSize: selectedIndexOfCategory == index ? 21 : 18,
                          color: selectedIndexOfCategory == index
                              ? AppConstantsColor.darkTextColor
                              : AppConstantsColor.unSelectedTextColor,
                          fontWeight: selectedIndexOfCategory == index
                              ? FontWeight.bold
                              : FontWeight.w400),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

// Middle Categories Widget Components
  middleCategoriesWidget(width, height) {
    return Container(
      width: width,
      height: height / 2.4,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: availableShoes.length,
        itemBuilder: (ctx, index) {
          ShoeModel model = availableShoes[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => DetailScreen(
                    model: model,
                    isComeFromMoreSection: false,
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(15),
              width: width / 1.9,
              child: Stack(
                children: [
                  Container(
                    width: width / 1.81,
                    decoration: BoxDecoration(
                      color: model.modelColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    child: FadeAnimation(
                      delay: 1,
                      child: Row(
                        children: [
                          Text(model.name,
                              style: AppThemes.homeProductName),
                          SizedBox(
                            width: 280,
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteStatus[model.id] ?? false
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () => _toggleFavorite(model.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 10,
                    child: FadeAnimation(
                      delay: 1.5,
                      child: Text(model.model,
                          style: AppThemes.homeProductModel),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 10,
                    child: FadeAnimation(
                      delay: 2,
                      child: Text("${model.price} IQD",
                          style: AppThemes.homeProductPrice),
                    ),
                  ),
                  Positioned(
                    left: 40,
                    top: 90,
                    child: FadeAnimation(
                      delay: 2,
                      child: Hero(
                        tag: model.imgAddress,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(-30 / 360),
                          child: Container(
                            width: 280,
                            height: 260,
                            child: Image(
                              image: AssetImage(model.imgAddress),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.arrow_right_circle,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

// More Text Widget Components
  moreTextWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text("More", style: AppThemes.homeMoreText),
          Expanded(child: Container()),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_right,
                size: 27,
              ))
        ],
      ),
    );
  }

// Last Categories Widget Components
  lastCategoriesWidget(width, height) {
    return Container(
      width: width,
      height: height / 4,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: availableShoes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            ShoeModel model = availableShoes[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => DetailScreen(
                      model: model,
                      isComeFromMoreSection: true,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(10),
                width: width / 2.24,
                height: height / 4.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: FadeAnimation(
                        delay: 1,
                        child: Container(
                          width: width / 13,
                          height: height / 10,
                          padding: EdgeInsets.zero,
                          margin:  EdgeInsets.zero,
                          color: Colors.red,
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Center(
                                  child: FadeAnimation(
                                delay: 1.5,
                                child: Text("NEW",
                                    style: AppThemes.homeGridNewText),
                              ))),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 1,
                      child: IconButton(
                        icon: Icon(
                          favoriteStatus[model.id] ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppConstantsColor.darkTextColor,
                        ),
                        onPressed: () => _toggleFavorite(model.id),
                      ),
                    ),
                    Positioned(
                      top: 26,
                      left: 25,
                      child: FadeAnimation(
                        delay: 1.5,
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation(-15 / 360),
                          child: Container(
                            width: width / 3,
                            height: height / 7,
                            child: Hero(
                              tag: model.model,
                              child: Image(
                                image: AssetImage(model.imgAddress),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeAnimation(
                          delay: 2,
                          child: Container(
                            width: width / 2,
                            height: height / 42,
                            child: FittedBox(
                              child: Text("${model.name} ${model.model}",
                                  style: AppThemes.homeGridNameAndModel),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          delay: 2.2,
                          child: Container(
                            width: width / 4,
                            height: height / 42,
                            child: FittedBox(
                              child: Text(
                                "${model.price} IQD",
                                style: AppThemes.homeGridPrice
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}