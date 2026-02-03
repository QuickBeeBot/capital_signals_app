import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/pages/home/home_page.dart';
import 'package:signalbyt/pages/learn/learn_page.dart';
import 'package:signalbyt/pages/signals/signals_init_page.dart';
import 'package:signalbyt/pages/user/profile.dart';
import '../constants/app_colors.dart';
import '../models_providers/navbar_provider.dart';

class AppNavbarPage extends StatefulWidget {
  const AppNavbarPage({Key? key}) : super(key: key);

  @override
  State<AppNavbarPage> createState() => _AppNavbarPageState();
}

class _AppNavbarPageState extends State<AppNavbarPage> {
  // Only store the current page, don't preload others
  Widget? _currentPage;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with home page
    _currentIndex = Provider.of<NavbarProvider>(context, listen: false).selectedPageIndex;
    _currentPage = _getPage(_currentIndex);
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return LearnPage();
      case 2:
        return SignalsInitPage(type: 'long');
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

  void _handleNavigationTap(int index) {
    if (index != _currentIndex) {
      final appProvider = Provider.of<NavbarProvider>(context, listen: false);
      appProvider.selectedPageIndex = index;

      setState(() {
        _currentIndex = index;
        _currentPage = _getPage(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final appProvider = Provider.of<NavbarProvider>(context);

    return Scaffold(
      body: _currentPage ?? HomePage(),
      bottomNavigationBar: _buildBottomNavigationBar(isDarkMode, appProvider),
    );
  }

  Widget _buildBottomNavigationBar(bool isDarkMode, NavbarProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
        child: Container(
          height: 70,
          color: isDarkMode ? Color(0xFF1A1A1A) : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                iconPath: 'assets/svg/home.svg',
                label: 'Home',
                isDarkMode: isDarkMode,
                isSelected: appProvider.selectedPageIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                iconPath: 'assets/svg/learn.svg',
                label: 'Learn',
                isDarkMode: isDarkMode,
                isSelected: appProvider.selectedPageIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                iconPath: 'assets/svg/go-long.svg',
                label: 'Signals',
                isDarkMode: isDarkMode,
                isSelected: appProvider.selectedPageIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                iconPath: 'assets/svg/user.svg',
                label: 'Profile',
                isDarkMode: isDarkMode,
                isSelected: appProvider.selectedPageIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
    required bool isDarkMode,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _handleNavigationTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (isDarkMode ? AppCOLORS.yellow : AppCOLORS.blue).withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? (isDarkMode ? AppCOLORS.yellow : AppCOLORS.blue)
                        : (isDarkMode ? Colors.grey[500]! : Colors.grey[600]!),
                    BlendMode.srcIn,
                  ),
                  height: 20,
                  width: 20,
                ),
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDarkMode ? AppCOLORS.yellow : AppCOLORS.blue)
                    : (isDarkMode ? Colors.grey[500]! : Colors.grey[600]!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:animate_do/animate_do.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:glassmorphism/glassmorphism.dart';
// import 'package:provider/provider.dart';
// import 'package:signalbyt/pages/home/home_page.dart';
// import 'package:signalbyt/pages/learn/learn_page.dart';
// import 'package:signalbyt/pages/signals/signals_init_page.dart';
// import 'package:signalbyt/pages/user/profile.dart';
// import '../constants/app_colors.dart';
// import '../models_providers/navbar_provider.dart';
//
// class AppNavbarPage extends StatefulWidget {
//   const AppNavbarPage({Key? key}) : super(key: key);
//
//   @override
//   State<AppNavbarPage> createState() => _AppNavbarPageState();
// }
//
// class _AppNavbarPageState extends State<AppNavbarPage> with SingleTickerProviderStateMixin {
//   late PageController _pageController;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//   int _previousIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     final appProvider = Provider.of<NavbarProvider>(context, listen: false);
//
//     _pageController = PageController(initialPage: appProvider.selectedPageIndex);
//
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 400),
//     );
//
//     _scaleAnimation = TweenSequence<double>([
//       TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.95), weight: 50),
//       TweenSequenceItem(tween: Tween<double>(begin: 0.95, end: 1.0), weight: 50),
//     ]).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: Offset(0.0, 0.05),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     ));
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _handleNavigationTap(int index) {
//     final appProvider = Provider.of<NavbarProvider>(context, listen: false);
//
//     if (appProvider.selectedPageIndex != index) {
//       _previousIndex = appProvider.selectedPageIndex;
//       setState(() {
//         appProvider.selectedPageIndex = index;
//       });
//
//       // Create a sophisticated page transition
//       _animationController.reset();
//       _animationController.forward();
//
//       if (_pageController.hasClients) {
//         _pageController.animateToPage(
//           index,
//           duration: Duration(milliseconds: 400),
//           curve: Curves.easeInOutCubic,
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = theme.brightness == Brightness.dark;
//     final appProvider = Provider.of<NavbarProvider>(context);
//
//     return Stack(
//       children: [
//         // Main Content with sophisticated transitions
//         FadeTransition(
//           opacity: _fadeAnimation,
//           child: ScaleTransition(
//             scale: _scaleAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: PageView(
//                 controller: _pageController,
//                 physics: BouncingScrollPhysics(),
//                 children: _pages,
//                 onPageChanged: (index) {
//                   if (appProvider.selectedPageIndex != index) {
//                     _previousIndex = appProvider.selectedPageIndex;
//                     setState(() {
//                       appProvider.selectedPageIndex = index;
//                     });
//                     _animationController.reset();
//                     _animationController.forward();
//                   }
//                 },
//               ),
//             ),
//           ),
//         ),
//
//         // Floating Navigation Bar with Glassmorphism
//         Positioned(
//           bottom: 20,
//           left: 20,
//           right: 20,
//           child: FadeInUp(
//             duration: Duration(milliseconds: 800),
//             child: _buildFloatingNavBar(isDarkMode, appProvider),
//           ),
//         ),
//
//         // Optional: Floating Action Button for Signals (Center Navigation)
//         if (appProvider.selectedPageIndex == 2)
//           Positioned(
//             bottom: 100,
//             right: 20,
//             child: FadeInRight(
//               duration: Duration(milliseconds: 600),
//               child: FloatingActionButton.extended(
//                 onPressed: () {
//                   // Quick action for signals
//                 },
//                 backgroundColor: AppCOLORS.yellow,
//                 foregroundColor: Colors.black,
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 icon: Icon(Icons.flash_on_rounded),
//                 label: Text('Active Signals'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildFloatingNavBar(bool isDarkMode, NavbarProvider appProvider) {
//     return GlassmorphicContainer(
//       width: double.infinity,
//       height: 70,
//       borderRadius: 20,
//       blur: 20,
//       alignment: Alignment.bottomCenter,
//       border: 2,
//       linearGradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: isDarkMode
//             ? [
//           Colors.white.withOpacity(0.1),
//           Colors.white.withOpacity(0.05),
//         ]
//             : [
//           Colors.white.withOpacity(0.25),
//           Colors.white.withOpacity(0.15),
//         ],
//       ),
//       borderGradient: LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//         colors: isDarkMode
//             ? [
//           Colors.white.withOpacity(0.3),
//           Colors.white.withOpacity(0.1),
//         ]
//             : [
//           Colors.white.withOpacity(0.5),
//           Colors.white.withOpacity(0.2),
//         ],
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             _buildNavItem(
//               index: 0,
//               iconPath: 'assets/svg/home.svg',
//               label: 'Home',
//               isDarkMode: isDarkMode,
//               isSelected: appProvider.selectedPageIndex == 0,
//             ),
//             _buildNavItem(
//               index: 1,
//               iconPath: 'assets/svg/learn.svg',
//               label: 'Learn',
//               isDarkMode: isDarkMode,
//               isSelected: appProvider.selectedPageIndex == 1,
//             ),
//             _buildNavItem(
//               index: 2,
//               iconPath: 'assets/svg/go-long.svg',
//               label: 'Signals',
//               isDarkMode: isDarkMode,
//               isSelected: appProvider.selectedPageIndex == 2,
//             ),
//             _buildNavItem(
//               index: 3,
//               iconPath: 'assets/svg/user.svg',
//               label: 'Profile',
//               isDarkMode: isDarkMode,
//               isSelected: appProvider.selectedPageIndex == 3,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNavItem({
//     required int index,
//     required String iconPath,
//     required String label,
//     required bool isDarkMode,
//     required bool isSelected,
//   }) {
//     return GestureDetector(
//       onTap: () => _handleNavigationTap(index),
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? LinearGradient(
//             colors: isDarkMode
//                 ? [
//               AppCOLORS.yellow.withOpacity(0.2),
//               AppCOLORS.yellow.withOpacity(0.1),
//             ]
//                 : [
//               AppCOLORS.blue.withOpacity(0.2),
//               AppCOLORS.blue.withOpacity(0.1),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           )
//               : null,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               alignment: Alignment.center,
//               children: [
//                 // Glow effect for selected item
//                 if (isSelected)
//                   Container(
//                     width: 15,
//                     height: 15,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: isDarkMode
//                           ? AppCOLORS.yellow.withOpacity(0.2)
//                           : AppCOLORS.blue.withOpacity(0.2),
//                       boxShadow: [
//                         BoxShadow(
//                           color: isDarkMode
//                               ? AppCOLORS.yellow.withOpacity(0.3)
//                               : AppCOLORS.blue.withOpacity(0.3),
//                           blurRadius: 8,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                   ),
//
//                 // Icon with animation
//                 AnimatedScale(
//                   scale: isSelected ? 0.8 : 0.8,
//                   duration: Duration(milliseconds: 300),
//                   child: SvgPicture.asset(
//                     iconPath,
//                     colorFilter: ColorFilter.mode(
//                       isSelected
//                           ? (isDarkMode ? AppCOLORS.yellow : AppCOLORS.blue)
//                           : (isDarkMode ? Colors.grey[400]! : Colors.grey[600]!),
//                       BlendMode.srcIn,
//                     ),
//                     height: isSelected ? 24 : 22,
//                     width: isSelected ? 24 : 22,
//                   ),
//                 ),
//
//                 // Notification badge (example for signals)
//                 if (index == 2 && _hasNewSignals)
//                   Positioned(
//                     top: -2,
//                     right: -2,
//                     child: Container(
//                       width: 8,
//                       height: 8,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.red,
//                         border: Border.all(
//                           color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 4),
//
//             // Label with animation
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? (isDarkMode ? AppCOLORS.yellow : AppCOLORS.blue)
//                     : Colors.transparent,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w600,
//                   color: isSelected
//                       ? (isDarkMode ? Colors.black : Colors.white)
//                       : (isDarkMode ? Colors.grey[400]! : Colors.grey[600]!),
//                   letterSpacing: isSelected ? 0.5 : 0.0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   bool get _hasNewSignals {
//     // Add your logic for new signals notification
//     return false;
//   }
//
//   // Enhanced pages with proper keys
//   final List<Widget> _pages = [
//     FadeIn(child: HomePage(), key: ValueKey('home')),
//     FadeIn(child: LearnPage(), key: ValueKey('learn')),
//     FadeIn(child: SignalsInitPage(type: 'long', key: ObjectKey('signals'))),
//     FadeIn(child: ProfilePage(), key: ValueKey('profile')),
//   ];
// }
//
//





// import 'package:custom_navigation_bar/custom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:signalbyt/pages/user/notifications_page.dart';
// import 'package:signalbyt/pages/user/profile.dart';
// import '../components/z_card.dart';
// import 'home/annoucements_page.dart';
// import 'home/home_page.dart';
// import 'home/news_page.dart';
// import 'learn/learn_page.dart';
// import 'signals/signals_init_page.dart';
//
// import '../../../models_providers/navbar_provider.dart';
// import '../constants/app_colors.dart';
// import 'home/home_page2.dart';
// import 'user/my_account_page.dart';
//
// class AppNavbarPage extends StatefulWidget {
//   const AppNavbarPage({Key? key}) : super(key: key);
//
//   @override
//   _AppNavbarPageState createState() => _AppNavbarPageState();
// }
//
// class _AppNavbarPageState extends State<AppNavbarPage> {
//   late PageController _pageController;
//
//   @override
//   void initState() {
//     final appProvider = Provider.of<NavbarProvider>(context, listen: false);
//     _pageController = PageController(initialPage: appProvider.selectedPageIndex);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final appProvider = Provider.of<NavbarProvider>(context, listen: false);
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;
//
//     return Scaffold(
//       body: AnimatedSwitcher(
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return FadeTransition(child: child, opacity: animation);
//           },
//           duration: const Duration(milliseconds: 300),
//           child: pages.elementAt(appProvider.selectedPageIndex)),
//       bottomNavigationBar: CustomNavigationBar(
//         blurEffect: false,
//         onTap: (v) {
//           appProvider.selectedPageIndex = v;
//           if (_pageController.hasClients) _pageController.animateToPage(v, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
//         },
//         // iconSize: 20.0,
//         selectedColor: Colors.white,
//         strokeColor: Colors.white,
//         backgroundColor: isLightTheme ? Colors.grey.shade300 : Color(0xFF35383F).withOpacity(.8),
//         borderRadius: Radius.circular(20.0),
//         opacity: 1,
//         elevation: 0,
//         currentIndex: appProvider.selectedPageIndex,
//         isFloating: true,
//         items: [
//           CustomNavigationBarItem(
//             icon: SvgPicture.asset('assets/svg/home.svg', colorFilter: ColorFilter.mode(getIconColor(0), BlendMode.srcIn), height: getIconHeight(0), width: getIconHeight(0)),
//             title: Text('Home', style: TextStyle(color: getIconColor(0), fontSize: 12)),
//           ),
//           CustomNavigationBarItem(
//             icon: SvgPicture.asset('assets/svg/learn.svg', colorFilter: ColorFilter.mode(getIconColor(1), BlendMode.srcIn), height: getIconHeight(1), width: getIconHeight(1)),
//             title: Text('Learn', style: TextStyle(color: getIconColor(1), fontSize: 12)),
//           ),
//           CustomNavigationBarItem(
//             icon: SvgPicture.asset('assets/svg/go-long.svg', colorFilter: ColorFilter.mode(getIconColor(2), BlendMode.srcIn), height: getIconHeight(2), width: getIconHeight(2)),
//             title: Text('Signals', style: TextStyle(color: getIconColor(2), fontSize: 12)),
//           ),
//           // CustomNavigationBarItem(
//           //   icon: SvgPicture.asset('assets/svg/notification.svg',
//           //       colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn), height: getIconHeight(3), width: getIconHeight(3)),
//           //   title: Text('Alerts', style: TextStyle(color: getIconColor(3), fontSize: 12)),
//           // ),
//           CustomNavigationBarItem(
//             icon: SvgPicture.asset('assets/svg/user.svg', colorFilter: ColorFilter.mode(getIconColor(3), BlendMode.srcIn), height: getIconHeight(3), width: getIconHeight(3)),
//             title: Text('Profile', style: TextStyle(color: getIconColor(3), fontSize: 12)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   double getIconHeight(int index) {
//     final appProvider = Provider.of<NavbarProvider>(context);
//     final selectedIndex = appProvider.selectedPageIndex;
//     return selectedIndex == index ? 24 : 20;
//   }
//
//   Color getIconColor(int index) {
//     final appProvider = Provider.of<NavbarProvider>(context);
//     final selectedIndex = appProvider.selectedPageIndex;
//     final isLightTheme = Theme.of(context).brightness == Brightness.light;
//     Color color = isLightTheme ? Colors.black26 : Colors.white24;
//     // if (selectedIndex == index) return isLightTheme ? appColorBlue : appColorBlue;
//     if (selectedIndex == index) return isLightTheme ? appColorBlue : appColorYellow;
//     return color;
//   }
//
// /* ----------------------------- NOTE UserPages ----------------------------- */
//
//   List<Widget> pages = [
//     HomePage(),
//     LearnPage(),
//     SignalsInitPage(type: 'long', key: ObjectKey('long')),
//     ProfilePage(),
//   ];
//
// }
//
//
