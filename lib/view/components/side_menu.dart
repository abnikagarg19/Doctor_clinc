import 'package:chatbot/utils/app_routes.dart';
import 'package:chatbot/view/chat/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../components/search_Textbox.dart';
import '../../controller/chatController.dart';
import '../../responsive.dart';
import '../home/dashboard.dart';
import '../setting/setting.dart';
import '../videocall/offline_consulation.dart';

class SideMenu extends StatefulWidget {
  SideMenu({super.key});

  @override
  State<SideMenu> createState() => _DashboardState();
}

class _DashboardState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ResponsiveLayout(
          desktop:
              _buildWidget(context, MediaQuery.of(context).size.width * .8),
          tablet: _buildWidget(context, MediaQuery.of(context).size.width * .9),
          mobile:
              _buildWidget(context, MediaQuery.of(context).size.width * .9)),
    );
  }

  List dashboardlist = [
    "assets/svg/dashboard.svg",
    "assets/svg/calender.svg",
    "assets/svg/chat.svg",
    "assets/svg/setting.svg",
    "assets/svg/logout.svg"
  ];
  int selectedIndex = 0;
  final ChatController controller = Get.put(ChatController());
  _buildWidget(context, width) {
    return LayoutBuilder(
        // If our width is more than 1100 then we consider it a desktop
        builder: (context, constraints) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/sidebar_bg.png",
              height: Get.height / 1.2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                ...List.generate(
                  dashboardlist.length,
                  (index) {
                    return GestureDetector(
                        onTap: () {
                          selectedIndex = index;
                          setState(() {});
                          if (index == 2) {
                            controller.loadPatients();
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: index == selectedIndex
                                    ? Color.fromRGBO(255, 255, 255, 0.7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4)),
                            child: SvgPicture.asset(
                              dashboardlist[index],
                              height: 30,
                            )));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        ),
        SizedBox(
          width: 60,
        ),
        Expanded(
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: search_textbox(
                      onsubmit: (String) {},
                      hintText: "Search here...",
                      onChanged: (String) {},
                    ),
                  ),
                ),
                // SizedBox(width: 16),
                // ElevatedButton.icon(
                //   onPressed: () => Get.toNamed('/websocket'),
                //   icon: Icon(Icons.wifi, color: Colors.white),
                //   label:
                //       Text('WebSocket Test', style: TextStyle(color: Colors.white)),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue,
                //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   ),
                // ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset("assets/images/bell.png"),
                      SizedBox(
                        width: 40,
                      ),
                      Image.asset("assets/images/chat copy.png"),
                      SizedBox(
                        width: 40,
                      ),
                      Image.asset("assets/images/message.png"),
                      SizedBox(
                        width: 80,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/images/aa.jpg",
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                )
              ],
            ),
            _buildSwitchPage(context, selectedIndex),
          ]),
        ),
        SizedBox(
          width: 60,
        ),
      ]);
    });
  }

  _buildSwitchPage(context, selectIndex) {
    if (selectIndex == 4) {
      Future.microtask(() => _showLogoutDialog(context));
      return Container();
    }

    switch (selectIndex) {
      case 0:
        return Dashboard();
      case 1:
        return OfflineConsultation();

      case 2:
        return PatientChatPage();
      case 3:
        return SettingsPage();
      default:
        return Dashboard();
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isSmallScreen(context);
    final bool isTablet = ResponsiveLayout.isMediumScreen(context);
    final bool isWeb = ResponsiveLayout.isLargeScreen(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxWidth:
                  isMobile ? MediaQuery.of(context).size.width * 0.9 : 450,
              minWidth:
                  isMobile ? MediaQuery.of(context).size.width * 0.8 : 400,
            ),
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: isMobile ? 56 : 64,
                  height: isMobile ? 56 : 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: isMobile ? 28 : 32,
                  ),
                ),
                SizedBox(height: isMobile ? 12 : 16),

                // Title
                Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: isMobile ? 6 : 8),

                // Message
                Text(
                  "Are you sure you want to logout from your account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),

                // Buttons - Horizontal for web/tablet, Vertical for mobile
                if (isMobile)
                  ..._buildMobileButtons(context)
                else
                  ..._buildDesktopButtons(context),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildMobileButtons(BuildContext context) {
    return [
      Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.microtask(() {
                  if (mounted) {
                    setState(() {
                      selectedIndex = 0;
                    });
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildDesktopButtons(BuildContext context) {
    return [
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.microtask(() {
                  if (mounted) {
                    setState(() {
                      selectedIndex = 0;
                    });
                  }
                });
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _performLogout() {
    print("Logging out...");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged out successfully"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Future.microtask(() {
      if (mounted) {
        setState(() {
          selectedIndex = 0;
        });
      }
    });

    Get.offAllNamed(Routes.LOGIN);
  }
}
