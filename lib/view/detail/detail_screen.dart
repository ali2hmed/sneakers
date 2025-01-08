import 'package:flutter/material.dart';
import 'package:sneakers_app/models/shoe_model.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/utils/constants.dart';
import 'package:sneakers_app/view/detail/components/body.dart';

class DetailScreen extends StatefulWidget {
  final ShoeModel model;
  final bool isComeFromMoreSection;
  
  DetailScreen({
    required this.model,
    required this.isComeFromMoreSection,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    // TODO: Replace with actual logged-in user ID
    final isInFavorites = await dbHelper.isFavorite(1, widget.model.id);
    if (mounted) {
      setState(() {
        isFavorite = isInFavorites;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    // TODO: Replace with actual logged-in user ID
    final userId = 1;
    
    if (isFavorite) {
      await dbHelper.removeFavorite(userId, widget.model.id);
    } else {
      await dbHelper.addFavorite(userId, widget.model.id);
    }

    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black87,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppConstantsColor.backgroundColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: Text(
              widget.model.name,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black87,
                ),
              ),
            ],
          ),
        ),
        body: DetailsBody(
          model: widget.model,
          isComeFromMoreSection: widget.isComeFromMoreSection,
        ),
      ),
    );
  }
}