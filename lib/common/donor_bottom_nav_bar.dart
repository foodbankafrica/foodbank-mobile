import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/screens/donor_account_screens/home/donor_donor_page.dart';
import 'package:food_bank/screens/donor_account_screens/home/donor_home_page.dart';
import 'package:food_bank/screens/donor_account_screens/home/donor_user_page.dart';

class DonorFoodBankBottomNavigator extends StatefulWidget {
  static String name = 'donor-bottom-navigator';
  static String route = '/donor-bottom-navigator';
  const DonorFoodBankBottomNavigator({super.key});

  @override
  State<DonorFoodBankBottomNavigator> createState() =>
      _DonorFoodBankBottomNavigator();
}

class _DonorFoodBankBottomNavigator
    extends State<DonorFoodBankBottomNavigator> {
  List<Widget> pages = [
    const DonorHomePage(),
    const DonorDonorPage(),
    const DonorUserPage(),
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
            label: 'Donations',
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
