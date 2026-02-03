import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/auth/signup.dart';
import '../../components/z_card.dart';
import '../../models/app_controls_public.dart';
import '../../models/auth_user.dart';
import '../../models_providers/app_controls_provider.dart';
import '../../models_providers/auth_provider.dart';
import '../../models_services/firebase_auth_service.dart';
import '../subsciption/subscription_page.dart';
import 'support_page.dart';
import '../../constants/app_colors.dart';
import '../../models_providers/app_provider.dart';
import '../../models_providers/theme_provider.dart';
import '../../models_services/api_authuser_service.dart';
import '../../utils/z_launch_url.dart';
import '../../models_providers/app_controls_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isPremiumExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final authUser = authProvider.authUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Premium color palette
    final backgroundColor = isDarkMode ? Color(0xFF0A0A0F) : Color(0xFFF8FAFF);
    final surfaceColor = isDarkMode ? Color(0xFF1A1A24) : Colors.white;
    final primaryText = isDarkMode ? Color(0xFFF0F0F0) : Color(0xFF1A1A2E);
    final secondaryText = isDarkMode ? Color(0xFFA0A0B0) : Color(0xFF666680);
    final accentColor = AppCOLORS.yellow;
    final premiumGradient = LinearGradient(
      colors: [Color(0xFFF9A826), Color(0xFFFFC107), Color(0xFFFFD54F)],
      stops: [0.0, 0.5, 1.0],
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Scaffold(
              backgroundColor: backgroundColor,
              body: CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  // Premium App Bar
                  SliverAppBar(
                    expandedHeight: 240,
                    floating: false,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        final top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          title: AnimatedOpacity(
                            duration: Duration(milliseconds: 200),
                            opacity: top > 100 ? 0.0 : 1.0,
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          centerTitle: true,
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: isDarkMode
                                    ? [
                                  Color(0xFF1A1A2E),
                                  Color(0xFF16213E),
                                  Color(0xFF0A0A0F),
                                ]
                                    : [
                                  Color(0xFF4A6FA5),
                                  Color(0xFF2E4A76),
                                  Color(0xFF1A2C42),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Background pattern
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.05,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            isDarkMode
                                                ? 'assets/images/mesh_dark.png'
                                                : 'assets/images/mesh_light.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Content
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top + 60,
                                    left: 24,
                                    right: 24,
                                    bottom: 24,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Account',
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Manage your settings and preferences',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Main Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 24),

                          // User Profile Card
                          _buildUserProfileCard(authUser, isDarkMode, surfaceColor, primaryText, secondaryText, accentColor),

                          SizedBox(height: 24),

                          // Premium Status Card
                          if (authUser?.hasActiveSubscription == true)
                            _buildPremiumCard(isDarkMode, premiumGradient, primaryText),

                          // Menu Items Grid
                          _buildMenuGrid(isDarkMode, surfaceColor, primaryText, secondaryText, themeProvider, authUser),

                          SizedBox(height: 32),

                          // Social Links
                          _buildSocialLinks(isDarkMode, surfaceColor),

                          SizedBox(height: 32),

                          // Footer
                          _buildFooter(isDarkMode, primaryText, secondaryText),
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
    );
  }

  Widget _buildUserProfileCard(
      AuthUser? authUser,
      bool isDarkMode,
      Color surfaceColor,
      Color primaryText,
      Color secondaryText,
      Color accentColor,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Color(0xFF2D2D3D) : Color(0xFFE0E0F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.8),
                        accentColor.withOpacity(0.4),
                      ],
                    ),
                    border: Border.all(
                      color: accentColor.withOpacity(0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authUser?.email?.split('@').first ?? 'Trader',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: primaryText,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        authUser?.email ?? 'sign in to sync data',
                        style: TextStyle(
                          fontSize: 14,
                          color: secondaryText,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (authUser?.hasActiveSubscription == true)
              _buildSubscriptionStatus(isDarkMode, primaryText)
            else if (authUser?.isAnonymous == false)
              _buildUpgradeButton()
            else
              _buildSignInSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus(bool isDarkMode, Color primaryText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00C853).withOpacity(isDarkMode ? 0.2 : 0.1),
            Color(0xFF64DD17).withOpacity(isDarkMode ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF00C853).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: Color(0xFF00C853), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00C853),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Full access to all signals',
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryText.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryText.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => SubscriptionPage(), transition: Transition.cupertino),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppCOLORS.yellow, Color(0xFFF9A826)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppCOLORS.yellow.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_rounded, color: Colors.black, size: 20),
              SizedBox(width: 8),
              Text(
                'Upgrade to Premium',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your trading account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Sign in to access premium features and sync across devices',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF666680),
            height: 1.5,
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            if (Platform.isIOS)
              _buildAuthButton(
                icon: 'assets/images/apple.png',
                label: 'Continue with Apple',
                onTap: _handleAppleSignIn,
                isDark: true,
              ),
            SizedBox(height: 12),
            _buildAuthButton(
              icon: 'assets/images/google.png',
              label: 'Continue with Google',
              onTap: _handleGoogleSignIn,
              isDark: false,
            ),
            SizedBox(height: 12),
            _buildAuthButton(
              iconData: Icons.email_rounded,
              label: 'Sign in with Email',
              // onTap: () => Get.to(() => AuthPage(), transition: Transition.cupertino),
              onTap: () => Get.to(() => LoginScreen(), transition: Transition.cupertino),
              isEmail: true, icon: '',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAuthButton({
    required String icon, // This expects a String path
    IconData? iconData, // Add this parameter for IconData
    required String label,
    required VoidCallback onTap,
    bool isDark = false,
    bool isEmail = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: isEmail ? AppCOLORS.yellow : (isDark ? Colors.black : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.transparent : Color(0xFFE0E0F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isEmail)
                Image.asset(icon, width: 24, height: 24, color: isDark ? Colors.white : null)
              // else if (iconData != null) // Use iconData if provided
              else if (iconData != null) // Use iconData if provided
                Icon(iconData, color: isEmail ? Colors.white : (isDark ? Colors.white : Colors.black), size: 24),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEmail ? Colors.white : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(bool isDarkMode, LinearGradient premiumGradient, Color primaryText) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: premiumGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppCOLORS.yellow.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _isPremiumExpanded = !_isPremiumExpanded),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(Icons.diamond_rounded, color: AppCOLORS.yellow, size: 28),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Premium Membership',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Active - All features unlocked',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      _isPremiumExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black,
                      size: 24,
                    ),
                  ],
                ),
                if (_isPremiumExpanded) ...[
                  SizedBox(height: 20),
                  Divider(color: Colors.black.withOpacity(0.1)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureItem(Icons.speed_rounded, 'Real-time', 'Signals'),
                      _buildFeatureItem(Icons.timeline_rounded, 'Advanced', 'Charts'),
                      _buildFeatureItem(Icons.analytics_rounded, 'Premium', 'Analysis'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: AppCOLORS.yellow, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(
      bool isDarkMode,
      Color surfaceColor,
      Color primaryText,
      Color secondaryText,
      ThemeProvider themeProvider,
      AuthUser? authUser,
      ) {
    final items = [
      _MenuItem(
        icon: Icons.subscriptions_rounded,
        label: 'Subscription',
        color: Color(0xFF4CAF50),
        onTap: () => Get.to(() => SubscriptionPage(), transition: Transition.cupertino),
      ),
      _MenuItem(
        icon: Icons.support_agent_rounded,
        label: 'Support',
        color: Color(0xFF2196F3),
        onTap: () => Get.to(() => SupportPage(), transition: Transition.cupertino),
      ),
      _MenuItem(
        icon: Icons.notifications_active_rounded,
        label: 'Notifications',
        color: Color(0xFFFF9800),
        onTap: () {},
        isToggle: true,
        value: authUser?.isNotificationsEnabled ?? true,
        onChanged: (v) => FirebaseAuthService.toggleNotifications(value: v),
      ),
      _MenuItem(
        icon: Icons.dark_mode_rounded,
        label: 'Dark Mode',
        color: Color(0xFF9C27B0),
        onTap: () {},
        isToggle: true,
        value: themeProvider.themeMode == ThemeMode.dark,
        onChanged: (v) => themeProvider.themeMode = v ? ThemeMode.dark : ThemeMode.light,
      ),
      if (authUser?.isAnonymous == false)
        _MenuItem(
          icon: Icons.logout_rounded,
          label: 'Sign Out',
          color: Color(0xFFF44336),
          onTap: () async {
            Provider.of<AppProvider>(context, listen: false).cancleAllStreams();
            await Provider.of<AuthProvider>(context, listen: false).signOut();
            await Provider.of<AuthProvider>(context, listen: false).initReload();
          },
        ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildMenuItem(items[index], isDarkMode, surfaceColor, primaryText),
    );
  }

  Widget _buildMenuItem(_MenuItem item, bool isDarkMode, Color surfaceColor, Color primaryText) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode ? Color(0xFF2D2D3D) : Color(0xFFE0E0F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.isToggle)
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: item.value!,
                          onChanged: item.onChanged,
                          activeColor: item.color,
                          activeTrackColor: item.color.withOpacity(0.3),
                        ),
                      )
                    else
                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryText.withOpacity(0.3)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLinks(bool isDarkMode, Color surfaceColor) {
    final appControls = Provider.of<AppControlsProvider>(context).appControls;

    final socialItems = [
      if (appControls.linkTelegram.isNotEmpty)
        _SocialItem('Telegram', AntDesign.message1, Color(0xFF0088CC)),
      if (appControls.linkTwitter.isNotEmpty)
        _SocialItem('Twitter', AntDesign.twitter, Color(0xFF1DA1F2)),
      if (appControls.linkInstagram.isNotEmpty)
        _SocialItem('Instagram', AntDesign.instagram, Color(0xFFE4405F)),
      if (appControls.linkYoutube.isNotEmpty)
        _SocialItem('YouTube', AntDesign.youtube, Color(0xFFFF0000)),
      if (appControls.linkSupport.isNotEmpty)
        _SocialItem('Support', Icons.support_agent_rounded, Color(0xFF4CAF50)),
    ];

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Color(0xFF2D2D3D) : Color(0xFFE0E0F0),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect With Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Follow for updates and trading insights',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666680),
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: socialItems.map((item) => _buildSocialItem(item, appControls)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialItem(_SocialItem item, AppControlsPublic appControls) {
    String getUrl() {
      switch (item.label) {
        case 'Telegram': return appControls.linkTelegram;
        case 'Twitter': return appControls.linkTwitter;
        case 'Instagram': return appControls.linkInstagram;
        case 'YouTube': return appControls.linkYoutube;
        case 'Support': return appControls.linkSupport;
        default: return '';
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ZLaunchUrl.launchUrl(getUrl()),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: item.color, size: 20),
              SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: item.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode, Color primaryText, Color secondaryText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Image.asset(
            'assets/icon/app_logo.png',
            height: 40,
            color: isDarkMode ? Colors.white70 : AppCOLORS.blue,
          ),
          SizedBox(height: 16),
          Text(
            'CapitalSignals',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: primaryText,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Professional Trading Signals Platform',
            style: TextStyle(
              fontSize: 12,
              color: secondaryText,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 16),
          Text(
            '© ${DateTime.now().year} CapitalSignals. All rights reserved.',
            style: TextStyle(
              fontSize: 11,
              color: secondaryText.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAppleSignIn() async {
    try {
      final appControls = Provider.of<AppControlsProvider>(context, listen: false).appControls;
      final fbUser = FirebaseAuth.instance.currentUser;
      final jsonWebToken = await fbUser?.getIdToken();

      await FirebaseAuthService.signInWithApple();

      if (jsonWebToken != null) {
        ApiAuthUserService.deleteAccountGoogleAppleSignin(
          apiBaseUrl: appControls.adminUrl,
          jsonWebToken: jsonWebToken,
        );
      }

      Provider.of<AppProvider>(context, listen: false).cancleAllStreams();
      await Provider.of<AuthProvider>(context, listen: false).initReload();
    } catch (e) {
      Get.snackbar(
        'Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }

  void _handleGoogleSignIn() async {
    try {
      final appControls = Provider.of<AppControlsProvider>(context, listen: false).appControls;
      final fbUser = FirebaseAuth.instance.currentUser;
      final jsonWebToken = await fbUser?.getIdToken();

      await FirebaseAuthService.signInWithGoogle();

      if (jsonWebToken != null) {
        ApiAuthUserService.deleteAccountGoogleAppleSignin(
          apiBaseUrl: appControls.adminUrl,
          jsonWebToken: jsonWebToken,
        );
      }

      Provider.of<AppProvider>(context, listen: false).cancleAllStreams();
      await Provider.of<AuthProvider>(context, listen: false).initReload();
    } catch (e) {
      Get.snackbar(
        'Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFF44336),
        colorText: Colors.white,
      );
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isToggle;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isToggle = false,
    this.value,
    this.onChanged,
  });
}

class _SocialItem {
  final String label;
  final IconData icon;
  final Color color;

  _SocialItem(this.label, this.icon, this.color);
}
