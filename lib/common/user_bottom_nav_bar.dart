import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/screens/user_account_screens/home/user_donor_page.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/user_home_page.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/user_my_bag_page.dart';
import 'package:food_bank/screens/user_account_screens/home/town_hall_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/user_user_page.dart';

class UserFoodBankBottomNavigator extends StatefulWidget {
  static String name = 'user-bottom-navigator';
  static String route = '/user-bottom-navigator';
  const UserFoodBankBottomNavigator({super.key});

  @override
  State<UserFoodBankBottomNavigator> createState() =>
      _UserFoodBankBottomNavigatorState();
}

class _UserFoodBankBottomNavigatorState
    extends State<UserFoodBankBottomNavigator> {
  List<Widget> pages = [
    const HomePage(),
    const DonorPage(),
    const MyBagPage(),
    const TownHallPage(),
    const UserPage(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFEB5017),
        unselectedItemColor: const Color(0xFF000000),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/inactive-home-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  'assets/icons/active-home-icon.svg',
                  height: 24,
                  width: 24,
                )),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SvgPicture.asset(
                  'assets/icons/inactive-gift-icon.svg',
                  height: 24,
                  width: 24,
                )),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/active-gift-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            label: 'Donors',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/inactive-shopping-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/active-shopping-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            label: 'My Bag',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/inactive-bookmark-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/active-bookmark-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            label: 'Town Hall',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/inactive-user-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(
                'assets/icons/active-user-icon.svg',
                height: 24,
                width: 24,
              ),
            ),
            label: 'Me',
          )
        ],
      ),
    );
  }
}
