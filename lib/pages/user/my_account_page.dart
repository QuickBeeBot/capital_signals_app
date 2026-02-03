import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:signalbyt/auth/signup.dart';
import 'package:signalbyt/pages/user/home_page.dart';
import 'package:signalbyt/pages/wallet_page.dart';
import '../../components/z_card.dart';
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
import '../_app/account_delete_page.dart';

class MyAccountPage extends StatefulWidget {
  MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage>
    with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final AuthUser? authUser = authProvider.authUser;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
              title: Text('Profile', style: TextStyle(color: AppCOLORS.yellow)),
              actions: [
                Center(
                  child: ZCard(
                    onTap: () {
                      Get.to(() => EarnPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
                    },
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    inkColor: Colors.transparent,
                    child: Text('Earn', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900)),
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    borderRadiusColor: AppCOLORS.yellow,
                  ),
                ),
              ],
              bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: appColorYellow,
                  labelColor: appColorYellow,
                  tabs: <Widget>[
                    Tab(text: "Wallet", icon: Icon(Icons.account_balance_wallet)),
                    Tab(text: "Settings", icon: Icon(Icons.settings)),
                  ]
              )),
          body: TabBarView(
            controller: _tabController,
            children: [
              WalletPage(),
              ListView(
                children: [
                  SizedBox(height: 16),
                  if (authUser?.isAnonymous == false)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(child: Text(authUser?.email ?? ''),
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8)),
                        SizedBox(height: 8),
                      ],
                    ),
                  SizedBox(height: 8),
                  Image.asset("assets/icon/app_logo.png", height: 100),
                  SizedBox(height: 18),
                  ZCard(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      padding: EdgeInsets.zero,
                      color: Colors.transparent,
                      borderRadiusColor: Colors.transparent,
                      onTap: () => Get.to(() => SubscriptionPage(),
                          fullscreenDialog: true),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/money.svg',
                              colorFilter: ColorFilter.mode(
                                  appColorBlue, BlendMode.srcIn),
                              height: 20,
                              width: 20),
                          SizedBox(width: 16),
                          Text('My Subscription', style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      )),
                  Divider(height: 10),
                  ZCard(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      padding: EdgeInsets.zero,
                      color: Colors.transparent,
                      borderRadiusColor: Colors.transparent,
                      onTap: () =>
                          Get.to(() => SupportPage(), fullscreenDialog: true),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/support.svg',
                              colorFilter: ColorFilter.mode(
                                  appColorPink, BlendMode.srcIn),
                              height: 20,
                              width: 20),
                          SizedBox(width: 16),
                          Text('Support', style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      )),
                  Divider(height: 6),
                  ZCard(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(left: 16, top: 0, bottom: 0),
                      padding: EdgeInsets.zero,
                      borderRadiusColor: Colors.transparent,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/notification.svg',
                              colorFilter: ColorFilter.mode(
                                  appColorYellow, BlendMode.srcIn),
                              height: 20,
                              width: 20),
                          SizedBox(width: 16),
                          Text('Enable notifications', style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w600)),
                          Spacer(),
                          Switch(
                              value: authUser?.isNotificationsEnabled ?? true,
                              activeColor: appColorPrimary,
                              onChanged: (v) {
                                FirebaseAuthService.toggleNotifications(
                                    value: v);
                              })
                        ],
                      )),
                  Divider(height: 6),
                  ZCard(
                      color: Colors.transparent,
                      margin: EdgeInsets.only(left: 16, top: 0, bottom: 0),
                      padding: EdgeInsets.zero,
                      borderRadiusColor: Colors.transparent,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/exchange.svg',
                              colorFilter: ColorFilter.mode(
                                  getIconColor(1), BlendMode.srcIn),
                              height: 20,
                              width: 20),
                          SizedBox(width: 16),
                          Text('Enable dark mode',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Spacer(),
                          Switch(
                              value: themeProvider.themeMode == ThemeMode.dark,
                              activeColor: appColorPrimary,
                              onChanged: (v) {
                                if (themeProvider.themeMode == ThemeMode.dark) {
                                  themeProvider.themeMode = ThemeMode.light;
                                } else {
                                  themeProvider.themeMode = ThemeMode.dark;
                                }
                              })
                        ],
                      )),
                  Divider(height: 6),
                  if (authUser?.isAnonymous == false)
                    Column(
                      children: [
                        ZCard(
                            color: Colors.transparent,
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: EdgeInsets.zero,
                            onTap: () async {
                              Provider.of<AppProvider>(context, listen: false)
                                  .cancleAllStreams();
                              await Provider.of<AuthProvider>(
                                  context, listen: false).signOut();
                              await Provider.of<AuthProvider>(
                                  context, listen: false).initReload();
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/notification.svg',
                                    colorFilter: ColorFilter.mode(
                                        appColorError, BlendMode.srcIn),
                                    height: 20,
                                    width: 20),
                                SizedBox(width: 16),
                                Text('Sign out', style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                              ],
                            )),
                        Divider(height: 20),
                      ],
                    ),
                  _buildSignIn(),
                  FollowUs(),
                  const SizedBox(height: 10,),
                  Center(child: Image.asset("assets/icon/winbirdfx_logo.png", height: 75)),
                  const SizedBox(height: 30,),
                ],
              ),
            ],
          )
      )

      /*Scaffold(
        appBar: AppBar(
          title: Text('My Account'),
          centerTitle: false,
          actions: [
            if (authUser?.isAnonymous == false)
              IconButton(
                onPressed: () => Get.to(AccountDeletePage()),
                icon: Icon(Icons.more_vert_outlined),
              ),
          ],
        ),
        body:
      )*/,
    );
  }

  _buildSignIn() {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.authUser?.isAnonymous == false) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(),
        SizedBox(height: 16),
        Container(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text('Want to sync between devices?')),
        if (Platform.isIOS)
          ZCard(
              onTap: () async {
                try {
                  AppControlsProvider appControlsProvider = Provider.of<
                      AppControlsProvider>(context, listen: false);
                  final appControls = appControlsProvider.appControls;

                  User? fbUser = FirebaseAuth.instance.currentUser;
                  String? jsonWebToken = await fbUser?.getIdToken();

                  await FirebaseAuthService.signInWithApple();

                  if (jsonWebToken != null) {
                    ApiAuthUserService.deleteAccountGoogleAppleSignin(
                        apiBaseUrl: appControls.adminUrl,
                        jsonWebToken: jsonWebToken);
                  }

                  Provider.of<AppProvider>(context, listen: false)
                      .cancleAllStreams();
                  await Provider.of<AuthProvider>(context, listen: false)
                      .initReload();
                } catch (e) {
                  print(e);
                }
              },
              margin: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/apple.png', width: 20, height: 20),
                  SizedBox(width: 4),
                  Text('Sign in with Apple',
                      style: TextStyle(color: Colors.black, fontSize: 13))
                ],
              )),
        SizedBox(height: 16),
        ZCard(
            onTap: () async {
              try {
                AppControlsProvider appControlsProvider = Provider.of<
                    AppControlsProvider>(context, listen: false);
                final appControls = appControlsProvider.appControls;

                User? fbUser = FirebaseAuth.instance.currentUser;
                String? jsonWebToken = await fbUser?.getIdToken();

                await FirebaseAuthService.signInWithGoogle();

                if (jsonWebToken != null) {
                  ApiAuthUserService.deleteAccountGoogleAppleSignin(
                      apiBaseUrl: appControls.adminUrl,
                      jsonWebToken: jsonWebToken);
                }

                Provider.of<AppProvider>(context, listen: false)
                    .cancleAllStreams();
                await Provider.of<AuthProvider>(context, listen: false)
                    .initReload();
              } catch (e) {
                print(e);
              }
            },
            margin: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/google.png', width: 20, height: 20),
                SizedBox(width: 4),
                Text('Sign in with Google',
                    style: TextStyle(color: Colors.black, fontSize: 13))
              ],
            )),
        SizedBox(height: 16),
        ZCard(
            onTap: () async {
              // Get.to(() => AuthPage(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
              Get.to(() => LoginScreen(), fullscreenDialog: true, duration: Duration(milliseconds: 500));
            },
            margin: EdgeInsets.symmetric(horizontal: 16),
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/email.png', width: 20, height: 20),
                SizedBox(width: 4),
                Text('Sign in with Email and Password',
                    style: TextStyle(color: Colors.black, fontSize: 13))
              ],
            )),
      ],
    );
  }

  Color getIconColor(int index) {
    final isLightTheme = Theme
        .of(context)
        .brightness == Brightness.light;
    Color color = isLightTheme ? Colors.black54 : Colors.white60;
    return color;
  }
}

class FollowUs extends StatelessWidget {
  const FollowUs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(
        context);
    final appControls = appControlsProvider.appControls;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Container(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Links:')),
        Column(
          children: [
            if (appControls.linkGooglePlay != '')
              ZSocialMedia(
                text: 'Google Play',
                color: appColorBlue,
                icon: AntDesign.google,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkGooglePlay),
              ),
            if (appControls.linkAppStore != '')
              ZSocialMedia(
                text: 'App Store',
                color: Colors.grey,
                icon: AntDesign.apple_o,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkAppStore),
              ),
            if (appControls.linkInstagram != '')
              ZSocialMedia(
                text: 'Instagram',
                color: appColorPink,
                icon: AntDesign.instagram,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkInstagram),
              ),
            if (appControls.linkTelegram != '')
              ZSocialMedia(
                text: 'Telegram',
                color: appColorBlue,
                icon: AntDesign.message1,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkTelegram),
              ),
            if (appControls.linkWhatsapp != '')
              ZSocialMedia(
                text: 'WhatsApp',
                color: appColorGreen,
                icon: AntDesign.message1,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkWhatsapp),
              ),
            if (appControls.linkYoutube != '')
              ZSocialMedia(
                text: 'Youtube',
                color: appColorRed,
                icon: AntDesign.youtube,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkYoutube),
              ),
            if (appControls.linkTwitter != '')
              ZSocialMedia(
                text: 'Twitter',
                color: appColorBlue,
                icon: AntDesign.twitter,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkTwitter),
              ),
            if (appControls.linkSupport != '')
              ZSocialMedia(
                text: 'Support',
                color: appColorRed,
                icon: AntDesign.user,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkSupport),
              ),
            if (appControls.linkTerms != '')
              ZSocialMedia(
                text: 'Terms',
                color: appColorRed,
                icon: AntDesign.lock,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkTerms),
              ),
            if (appControls.linkPivacy != '')
              ZSocialMedia(
                text: 'Privacy',
                color: appColorRed,
                icon: AntDesign.eyeo,
                onTap: () => ZLaunchUrl.launchUrl(appControls.linkPivacy),
              ),
          ],
        ),
      ],
    );
  }
}

class ZSocialMedia extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Function() onTap;

  ZSocialMedia(
      {Key? key, required this.icon, required this.text, required this.color, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [Icon(icon), SizedBox(width: 8), Text(text)],
        ),
      ),
    );
  }
}
