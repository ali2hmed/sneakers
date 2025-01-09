
import 'package:flutter/material.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import '../../../utils/constants.dart';

// ignore: must_be_immutable
class RoundedLisTile extends StatelessWidget {
  double width;
  double height;
  Color? leadingBackColor;
  IconData icon;
  String title;
  Widget trailing;

  RoundedLisTile({Key? key, 
    required this.width,
    required this.height,
    required this.leadingBackColor,
    required this.icon,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          width: width,
          height: height / 14,
          child: ListTile(
              leading: CircleAvatar(
                backgroundColor: leadingBackColor,
                radius: 25,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    icon,
                    color: AppConstantsColor.lightTextColor,
                  ),
                ),
              ),
              title: Text(title, style: AppThemes.profileRepeatedListTileTitle),
              trailing: trailing),
        ),
      ),
    );
  }
}