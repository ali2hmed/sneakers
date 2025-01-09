import 'package:flutter/material.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/view/detail/detail_screen.dart';

class BagBody extends StatefulWidget {
  @override
  _BagBodyState createState() => _BagBodyState();
}

class _BagBodyState extends State<BagBody> {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    print('DEBUG: BagBody initState called');
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      print('DEBUG: Loading cart items...');
      setState(() {
        isLoading = true;
      });
      
      // TODO: Replace with actual logged-in user ID
      final items = await dbHelper.getCartItems(1);
      final cartTotal = await dbHelper.getCartTotal(1);
      print('DEBUG: Found ${items.length} items in cart');
      print('DEBUG: Cart items: $items');
      print('DEBUG: Cart total: $cartTotal');
      
      if (mounted) {
        setState(() {
          cartItems = items;
          total = cartTotal;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('DEBUG: Error loading cart: $e');
      print('DEBUG: Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading cart: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building BagBody with ${cartItems.length} items');
    return RefreshIndicator(
      onRefresh: _loadCartItems,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppConstantsColor.materialButtonColor,
              ),
            )
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Add items to start shopping',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          print('DEBUG: Building item $index: ${item['name']} ${item['model']}');
                          return Dismissible(
                            key: Key(item['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              _removeFromCart(item['id']);
                            },
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to detail page
                                final model = ShoeModel(
                                  id: item['shoe_id'],
                                  name: item['name'],
                                  model: item['model'],
                                  price: item['price'],
                                  imgAddress: item['image'],
                                  modelColor: Colors.grey,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      model: model,
                                      isComeFromMoreSection: false,
                                    ),
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
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      padding: EdgeInsets.all(16),
                                      child: Hero(
                                        tag: item['image'],
                                        child: Image.asset(
                                          item['image'],
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
                                              '${item['name']} ${item['model']}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Size: ${item['size']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  '${(item['price'] * item['quantity']).toInt()} IQD',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppConstantsColor.materialButtonColor,
                                                  ),
                                                ),
                                                Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.remove),
                                                        onPressed: () => _updateQuantity(
                                                          item['id'],
                                                          item['quantity'],
                                                          false,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints: BoxConstraints(
                                                          minWidth: 32,
                                                          minHeight: 32,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 32,
                                                        child: Center(
                                                          child: Text(
                                                            item['quantity'].toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.add),
                                                        onPressed: () => _updateQuantity(
                                                          item['id'],
                                                          item['quantity'],
                                                          true,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints: BoxConstraints(
                                                          minWidth: 32,
                                                          minHeight: 32,
                                                        ),
                                                      ),
                                                    ],
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (cartItems.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${total.toInt()} IQD',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstantsColor.materialButtonColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              MaterialButton(
                                onPressed: () {
                                  // TODO: Implement checkout
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minWidth: double.infinity,
                                height: 50,
                                color: AppConstantsColor.materialButtonColor,
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

  Future<void> _updateQuantity(int cartId, int currentQuantity, bool increase) async {
    try {
      final newQuantity = increase ? currentQuantity + 1 : currentQuantity - 1;
      if (newQuantity < 1) return;

      await dbHelper.updateCartItemQuantity(cartId, newQuantity);
      _loadCartItems(); // Reload cart to update total and quantities
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: $e')),
      );
    }
  }

  Future<void> _removeFromCart(int cartId) async {
    try {
      await dbHelper.removeFromCart(cartId);
      _loadCartItems();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removed from cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: $e')),
      );
    }
  }
}
