import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../animation/fadeanimation.dart';
import '../../../../../utils/app_methods.dart';
import '../../../../../utils/constants.dart';
import '../../../../../models/shoe_model.dart';
import '../../../data/dummy_data.dart';
import '../../../models/models.dart';
import '../../../theme/custom_app_theme.dart';

class DetailsBody extends StatefulWidget {
  ShoeModel model;
  bool isComeFromMoreSection;
  DetailsBody({required this.model, required this.isComeFromMoreSection});

  @override
  Details createState() => Details();
}

class Details extends State<DetailsBody> {
  bool _isSelectedCountry = false;
  int? _isSelectedSize;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height * 1.1,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            topInformationWidget(width, height),
            middleImgListWidget(width, height),
            SizedBox(
              height: 20,
              width: width / 1.1,
              child: Divider(
                thickness: 1.4,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  nameAndPrice(),
                  SizedBox(height: 10),
                  shoeInfo(width, height),
                  SizedBox(
                    height: 5,
                  ),
                  sizeTextAndCountry(width, height),
                  SizedBox(
                    height: 10,
                  ),
                  endSizesAndButton(width, height),
                  SizedBox(
                    height: 20,
                  ),
                  materialButton(width, height),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Top information Widget Components
  topInformationWidget(width, height) {
    return Container(
      width: width,
      height: height / 2.3,
      child: Stack(
        children: [
          Positioned(
            left: 50,
            bottom: 20,
            child: FadeAnimation(
              delay: 0.5,
              child: Container(
                width: 1000,
                height: height / 2.2,
                decoration: BoxDecoration(
                  color: widget.model.modelColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(1500),
                    bottomRight: Radius.circular(100),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 30,
            child: Hero(
              tag: widget.isComeFromMoreSection
                  ? widget.model.model
                  : widget.model.imgAddress,
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(-25 / 360),
                child: Container(
                  width: width / 1.3,
                  height: height / 4.3,
                  child: Image(image: AssetImage(widget.model.imgAddress)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Rounded Image Widget About Below method Components
  roundedImage(width, height) {
    return Container(
      padding: EdgeInsets.all(2),
      width: width / 5,
      height: height / 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300],
      ),
      child: Image(
        image: AssetImage(widget.model.imgAddress),
      ),
    );
  }

  // Middle Image List Widget Components
  middleImgListWidget(width, height) {
    return FadeAnimation(
      delay: 0.5,
      child: Container(
        padding: EdgeInsets.all(2),
        width: width,
        height: height / 11,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            roundedImage(width, height),
            roundedImage(width, height),
            roundedImage(width, height),
            Container(
              padding: EdgeInsets.all(2),
              width: width / 5,
              height: height / 14,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(widget.model.imgAddress),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.grey.withOpacity(1), BlendMode.darken),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_fill,
                  color: AppConstantsColor.lightTextColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Size Button Widget Components
  sizeButton(width, height) {
    return FadeAnimation(
      delay: 2.5,
      child: Container(
        width: width / 4.5,
        height: height / 14,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _isSelectedSize == width ? Colors.transparent : Colors.grey,
              width: 1,
            ),
          ),
          color: _isSelectedSize == width
              ? AppConstantsColor.materialButtonColor
              : AppConstantsColor.backgroundColor,
          onPressed: () {
            setState(() {
              _isSelectedSize = width;
              widget.model.selectedSize = width / 10; // Convert width to shoe size
            });
          },
          child: Text(
            "${width / 10}",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: _isSelectedSize == width
                  ? AppConstantsColor.lightTextColor
                  : AppConstantsColor.darkTextColor,
            ),
          ),
        ),
      ),
    );
  }

  //End Sizes And Button Widget Components
  endSizesAndButton(width, height) {
    return FadeAnimation(
      delay: 3,
      child: Container(
        width: width,
        height: height / 13,
        child: ListView.builder(
          itemCount: 8,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: sizeButton((index + 35) * 10, height),  // Sizes from 35 to 42
            );
          },
        ),
      ),
    );
  }

  //MaterialButton Components
  materialButton(width, height) {
    return FadeAnimation(
      delay: 3.5,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minWidth: width / 1.2,
        height: height / 15,
        color: AppConstantsColor.materialButtonColor,
        onPressed: () {
          if (_isSelectedSize == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a size'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          AppMethods.addToCart(widget.model, context);
        },
        child: Text(
          "ADD TO BAG",
          style: TextStyle(
            color: AppConstantsColor.lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Size Text Components (Removed UK/USA Buttons)
  sizeTextAndCountry(width, height) {
    return FadeAnimation(
      delay: 2.5,
      child: Row(
        children: [
          Text(
            "Size",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstantsColor.darkTextColor,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  //more details Text Components


  //About Shoe Text Components
  shoeInfo(width, height) {
    return FadeAnimation(
      delay: 1.5,
      child: Container(
        width: width,
        height: height / 9,
        child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tincidunt laoreet enim, eget sodales ligula semper at. Sed id aliquet eros, nec vestibulum felis. Nunc maximus aliquet aliquam. Quisque eget sapien at velit cursus tincidunt. Duis tempor lacinia erat eget fermentum.",
            style: AppThemes.detailsProductDescriptions),
      ),
    );
  }

  //Name And Price Text Components
  nameAndPrice() {
    return FadeAnimation(
      delay: 1.5,
      child: Row(
        children: [
          Text(
            "${widget.model.name} ${widget.model.model}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(child: Container()),
          Text(
            "\$${widget.model.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstantsColor.materialButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}