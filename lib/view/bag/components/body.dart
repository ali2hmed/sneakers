import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/view/detail/detail_screen.dart';
import 'package:sneakers_app/view/checkout/checkout_screen.dart';

class BagBody extends StatefulWidget {
  const BagBody({Key? key}) : super(key: key);

  @override
  _BagBodyState createState() => _BagBodyState();
}

class _BagBodyState extends State<BagBody> {
  final dbHelper = DBHelper();
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  double total = 0.0;

  // Define userId and shoeId here
  int userId = 1; // Set this to the current user's ID
  int shoeId = 0; // Set this to the appropriate shoe ID if needed

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('DEBUG: BagBody initState called');
    }
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      if (kDebugMode) {
        print('DEBUG: Loading cart items...');
      }
      setState(() {
        isLoading = true;
      });
      final items = await dbHelper.getCartItems(userId) ?? [];
      final cartTotal = await dbHelper.getCartTotal(userId) ?? 0.0;
      if (kDebugMode) {
        print('DEBUG: Found ${items.length} items in cart');
      }
      if (kDebugMode) {
        print('DEBUG: Cart items: $items');
      }
      if (kDebugMode) {
        print('DEBUG: Cart total: $cartTotal');
      }

      if (mounted) {
        setState(() {
          cartItems = items;
          total = cartTotal;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('DEBUG: Error loading cart: $e');
      }
      if (kDebugMode) {
        print('DEBUG: Stack trace: $stackTrace');
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading cart: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _removeFromCart(int cartId) async {
    try {
      await dbHelper.removeFromCart(userId, cartId);
      _loadCartItems(); // Reload cart items after removal
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing item: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateQuantity(int cartId, int currentQuantity, bool increase) async {
    try {
      final newQuantity = increase ? currentQuantity + 1 : currentQuantity - 1;
      if (newQuantity > 0) {
        await dbHelper.updateCartItemQuantity(cartId, newQuantity);
        _loadCartItems(); // Reload cart items after update
      } else {
        _removeFromCart(cartId);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating quantity: ${e.toString()}')),
      );
    }
  }

  void _navigateToCheckout() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(totalAmount: total),
      ),
    );
  }

@override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('DEBUG: Building BagBody with ${cartItems.length} items');
    }
    return RefreshIndicator(
      onRefresh: _loadCartItems,
      child: isLoading
          ? const Center(
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
                      const SizedBox(height: 20),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 10),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          if (kDebugMode) {
                            print('DEBUG: Building item $index: ${item['name'] ?? 'Unknown'} ${item['model'] ?? ''}');
                          }
                          return Dismissible(
                            key: Key(item['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.red[400],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              _removeFromCart(item['id']);
                            },
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to detail page
                                final model = ShoeModel(
                                  id: item['shoe_id'] ?? 0,
                                  name: item['name'] ?? 'Unknown',
                                  model: item['model'] ?? '',
                                  price: item['price'] ?? 0.0,
                                  imgAddress: item['image'] ?? '',
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
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      padding: const EdgeInsets.all(16),
                                      child: Hero(
                                        tag: item['image'] ?? '',
                                        child: Image.asset(
                                          item['image'] ?? 'assets/images/default_image.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${item['name'] ?? 'Unknown'} ${item['model'] ?? ''}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Size: ${item['size'] ?? 'N/A'}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  '${((item['price'] ?? 0.0) * (item['quantity'] ?? 1)).toInt()} IQD',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppConstantsColor.materialButtonColor,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),

child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.remove),
                                                        onPressed: () => _updateQuantity(
                                                          item['id'],
                                                          item['quantity'] ?? 1,
                                                          false,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints: const BoxConstraints(
                                                          minWidth: 32,
                                                          minHeight: 32,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 32,
                                                        child: Center(
                                                          child: Text(
                                                            (item['quantity'] ?? 1).toString(),
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(Icons.add),
                                                        onPressed: () => _updateQuantity(
                                                          item['id'],
                                                          item['quantity'] ?? 1,
                                                          true,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints: const BoxConstraints(
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
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),

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
                                  const Text(
                                    'Total:',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '${total.toInt()} IQD',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstantsColor.materialButtonColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              MaterialButton(
                                onPressed: _navigateToCheckout,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minWidth: double.infinity,
                                height: 50,
                                color: AppConstantsColor.materialButtonColor,
                                child: const Text(
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