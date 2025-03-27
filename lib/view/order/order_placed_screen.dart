import 'package:flutter/material.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/view/navigator.dart';

class OrderPlacedScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final String customerName;

  const OrderPlacedScreen({
    Key? key,
    required this.orderId,
    required this.totalAmount,
    required this.customerName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Save the order to the database
    _saveOrderToDatabase(context);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Navigate to home screen when back button is pressed
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainNavigator()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: AppConstantsColor.materialButtonColor,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Placed Successfully!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Order ID: #$orderId',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Amount: ${totalAmount.toInt()} IQD',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConstantsColor.materialButtonColor,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Thank you for your purchase! We\'ll notify you once your order is on its way.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const MainNavigator()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstantsColor.materialButtonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order tracking coming soon!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Track Order',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstantsColor.materialButtonColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Future<void> _saveOrderToDatabase(BuildContext context) async {
  final dbHelper = DBHelper();
  
  // Convert orderId to int if needed, assuming it represents a numeric value.
  int orderIdAsInt = int.tryParse(orderId) ?? 0; // Default to 0 if parsing fails

  await dbHelper.insertOrder(orderIdAsInt, customerName, totalAmount);

  // Notify the admin dashboard to refresh the order list
  debugPrint('Order saved to database. Notify admin dashboard to refresh.');
}

}
