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
                          if (index == 1) {
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
    if (selectIndex == 3) {
      return Container();
    }
    switch (selectIndex) {
      case 0:
        return Dashboard(
            // constraints: constraints,
            );
      case 1:
      return  OfflineConsulation();
      case 2:
        return PatientChatPage(
            // constraints: constraints,
            );
      case 3:
        return SettingsPage(
            // constraints: constraints,
            );
    }
  }
}
