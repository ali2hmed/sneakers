import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/shoe_model.dart';
import '../data/dummy_data.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  final DBHelper _dbHelper = DBHelper();
  List<ShoeModel> _shoes = [];
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    int shoeId = 1; // Set a valid shoeId based on your app logic
    bool shoesExist = await _dbHelper.shoesExist(shoeId);
    if (!shoesExist) {
      await _dbHelper.insertShoes(availableShoes);
    }
    _fetchShoes();
    _fetchOrders();
  }

  Future<void> _fetchShoes() async {
    final shoes = await _dbHelper.getShoes();
    if (mounted) {
      setState(() {
        _shoes = shoes;
      });
    }
  }

  Future<void> _fetchOrders() async {
    int userId = 1; // Set a valid userId based on your app logic
    final orders = await _dbHelper.getOrders(userId);
    if (mounted) {
      setState(() {
        _orders = orders;
      });
    }
  }

  Future<void> _deleteShoe(int id) async {
    await _dbHelper.deleteShoe(id);
    _fetchShoes();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shoe deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showAddShoeDialog() {
    final nameController = TextEditingController();
    final modelController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController(text: 'assets/images/');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Shoe"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Shoe Name"),
                ),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: "Model"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),
                Row(
                  children: [
                    const Text('Image Path: '),
                    Expanded(
                      child: TextField(
                        controller: imageController,
                        decoration: const InputDecoration(hintText: "Enter image name"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final model = modelController.text.trim();
                final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                final image = imageController.text.trim();

                if (name.isNotEmpty && model.isNotEmpty && price > 0 && image.isNotEmpty) {
                  ShoeModel shoeModel = ShoeModel(
                    id: 0, // Set to a default value or let the database assign it
                    name: name,
                    model: model,
                    price: price,
                    imgAddress: image,
                    modelColor: Colors.grey, // Specify model color
                  );

                  try {
                    await _dbHelper.insertShoes([shoeModel]);
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchShoes(); // Refresh the list
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shoe added successfully')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields correctly')),
                    );
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShoesPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: _shoes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _shoes.length,
              itemBuilder: (context, index) {
                final shoe = _shoes[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            image: DecorationImage(
                              image: AssetImage(shoe.imgAddress),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shoe.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              shoe.model,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "\$${shoe.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteShoe(shoe.id ?? 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOrdersPage() {
    return RefreshIndicator(
      onRefresh: _fetchOrders,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _orders.isEmpty
            ? const Center(
                child: Text(
                  "No orders available",
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order #${order['id']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${(order['total_price'] as num?)?.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Customer: ${order['customer_name'] ?? 'Guest'}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Date: ${order['created_at'] ?? DateTime.now().toString().substring(0, 10)}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _logout() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_currentIndex == 0) {
                _fetchShoes();
              } else {
                _fetchOrders();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _showAddShoeDialog,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Shoes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Orders",
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildShoesPage() : _buildOrdersPage(),
    );
  }
}
