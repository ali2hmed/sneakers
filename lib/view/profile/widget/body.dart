import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneakers_app/theme/custom_app_theme.dart';
import 'package:sneakers_app/db_helper.dart';
import 'package:sneakers_app/providers/user_provider.dart';

import '../../../../animation/fadeanimation.dart';
import '../../../../utils/constants.dart';
import '../../../../view/profile/widget/repeated_list.dart';

class BodyProfile extends StatefulWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  _BodyProfileState createState() => _BodyProfileState();
}

class _BodyProfileState extends State<BodyProfile> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isLoggedIn) {
      // Handle not logged in state
      setState(() {
        isLoading = false;
      });
      return;
    }

    final userProfile = await DBHelper().getUserProfile(userProvider.userId!);
    if (mounted) {
      setState(() {
        userData = userProfile;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      width: width,
      height: height,
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                topProfilePicAndName(width, height),
                const SizedBox(
                  height: 40,
                ),
                middleDashboard(width, height),
                bottomSection(width, height),
              ],
            ),
    );
  }

  // Top Profile Photo And Name Components
  topProfilePicAndName(width, height) {
    return FadeAnimation(
      delay: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                "https://avatars.githubusercontent.com/u/91388754?v=4"),
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData?['name'] ?? 'Loading...',
                style: AppThemes.profileDevName,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                userData?['email'] ?? 'Loading...',
                style: AppThemes.profileDevEmail,
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.edit_outlined,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  // Middle Dashboard ListTile Components
  middleDashboard(width, height) {
    return FadeAnimation(
      delay: 2,
      child: SizedBox(
        width: width,
        height: height / 2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "    Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.green[600],
              icon: Icons.wallet_travel_outlined,
              title: "Payments",
              trailing: Container(
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue[700],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "2 New",
                      style: TextStyle(
                          color: AppConstantsColor.lightTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstantsColor.lightTextColor,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.yellow[600],
              icon: Icons.archive,
              title: "Achievement's",
              trailing: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstantsColor.darkTextColor,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.grey[400],
              icon: Icons.shield,
              title: "Privacy",
              trailing: Container(
                width: 140,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red[500],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Action Needed  ",
                      style: TextStyle(
                          color: AppConstantsColor.lightTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstantsColor.lightTextColor,
                      size: 15,
                    )
                  ],
                ),
              ),
            ),
            // New My Requests Item
            RoundedLisTile(
              width: width,
              height: height,
              leadingBackColor: Colors.blue[400],
              icon: Icons.list_alt,
              title: "My Requests",
              trailing: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstantsColor.darkTextColor,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // My Account Section Components
  bottomSection(width, height) {
    return FadeAnimation(
      delay: 2.5,
      child: SizedBox(
        width: width,
        height: height / 6.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "    My Account",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontSize: 15),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/signIn');
              },
              child: Text(
                "    Log Out",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red[500],
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}