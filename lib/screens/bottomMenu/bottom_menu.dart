import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:selavu/screens/account/account_screen.dart';
import 'package:selavu/screens/categories/categories_screen.dart';
import 'package:selavu/screens/expenses/expenses_screen.dart';
import 'package:selavu/utils/app_colours.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_images.dart';
import '../home/home_screen.dart';

class BottomMenu extends StatefulWidget {
  static final GlobalKey<BottomMenuState> mainScreenKey = GlobalKey<BottomMenuState>();

  BottomMenu({Key? key}) : super(key: mainScreenKey);

  static void switchToExpenses() {
    mainScreenKey.currentState?.onItemTapped(1);
  }

  static void switchToHome() {
    mainScreenKey.currentState?.onItemTapped(0);
  }

  @override
  State<BottomMenu> createState() => BottomMenuState();
}

class BottomMenuState extends State<BottomMenu> {

  int selectedIndex = 0;

  List<Widget> screens = const [
    HomeScreen(),
    ExpensesScreen(),
    CategoriesScreen(),
    AccountScreen(),
  ];

  void onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWeb = constraints.maxWidth > 800;
        if(isWeb){
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  // leading: Icon(Icons.menu), // Optional leading icon
                  destinations: [
                    NavigationRailDestination(
                        selectedIcon: SvgPicture.asset(
                          AppImages.imageHomeActiveIcon,
                          width: 2.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageHomeIcon,
                          width: 2.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: Text("Home", style: Theme.of(context).textTheme.bodyMedium,)
                    ),
                    NavigationRailDestination(
                        selectedIcon: SvgPicture.asset(
                          AppImages.imageExpenseActiveIcon,
                          width: 2.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageExpenseIcon,
                          width: 2.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: Text("Expenses", style: Theme.of(context).textTheme.bodyMedium,)
                    ),
                    NavigationRailDestination(
                        selectedIcon: SvgPicture.asset(
                          AppImages.imageCategoryActiveIcon,
                          width: 2.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageCategoryIcon,
                          width: 2.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: Text("Categories", style: Theme.of(context).textTheme.bodyMedium,)
                    ),
                    NavigationRailDestination(
                        selectedIcon: SvgPicture.asset(
                          AppImages.imageAccountActiveIcon,
                          width: 2.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageAccountIcon,
                          width: 2.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: Text("Account", style: Theme.of(context).textTheme.bodyMedium,)
                    ),
                  ],
                ),
                Expanded(
                  child: screens.elementAt(selectedIndex),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: screens.elementAt(selectedIndex),
            bottomNavigationBar: SizedBox(
              height: 7.h,
              child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (int index){
                    onItemTapped(index);
                  },
                  backgroundColor: whiteColour,
                  selectedLabelStyle: Theme.of(context).textTheme.labelLarge,
                  unselectedLabelStyle: Theme.of(context).textTheme.labelMedium,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).primaryColor,
                  items: [
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset(
                          AppImages.imageHomeActiveIcon,
                          width: 5.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageHomeIcon,
                          width: 5.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: "Home"
                    ),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset(
                          AppImages.imageExpenseActiveIcon,
                          width: 5.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageExpenseIcon,
                          width: 5.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: "Expenses"
                    ),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset(
                          AppImages.imageCategoryActiveIcon,
                          width: 5.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageCategoryIcon,
                          width: 5.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: "Categories"
                    ),
                    BottomNavigationBarItem(
                        activeIcon: SvgPicture.asset(
                          AppImages.imageAccountActiveIcon,
                          width: 5.w,
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.srcIn),
                        ),
                        icon: SvgPicture.asset(
                          AppImages.imageAccountIcon,
                          width: 5.w,
                          colorFilter: const ColorFilter.mode(Colors.black54, BlendMode.srcIn),
                        ),
                        label: "Account"
                    ),
                  ]
              ),
            ),
          );
        }
      }
    );
  }
}
