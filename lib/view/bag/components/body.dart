import 'package:flutter/material.dart';
import 'package:sneakers_app/data/dummy_data.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/utils/app_methods.dart';

class BagBody extends StatefulWidget {
  const BagBody({Key? key}) : super(key: key);

  @override
  _BagBodyState createState() => _BagBodyState();
}

class _BagBodyState extends State<BagBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: itemsOnBag.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your bag is empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsOnBag.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      ShoeModel currentBagItem = itemsOnBag[index];
                      return Dismissible(
                        key: Key(currentBagItem.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.delete_outline, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            itemsOnBag.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Item removed from cart'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.black87,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    padding: EdgeInsets.all(16),
                                    child: Hero(
                                      tag: currentBagItem.imgAddress,
                                      child: Image.asset(
                                        currentBagItem.imgAddress,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentBagItem.name,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            currentBagItem.model,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                '\$${currentBagItem.price.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppConstantsColor.materialButtonColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.straighten,
                                      size: 20,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Size: EU ${currentBagItem.selectedSize?.toStringAsFixed(1)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (itemsOnBag.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '\$${AppMethods.sumOfItemsOnBag().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstantsColor.materialButtonColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          MaterialButton(
                            onPressed: () {
                              // TODO: Implement checkout
                            },
                            color: AppConstantsColor.materialButtonColor,
                            minWidth: double.infinity,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'CHECKOUT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
