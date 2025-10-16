// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../theme/apptheme.dart';
// import '../../utils/constant.dart';
//
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: 20,
//           ),
//           Text("Setting",
//               style: GoogleFonts.rubik(
//                 color: AppTheme.blackColor,
//                 fontSize: Constant.foutyHeight(context),
//                 fontWeight: FontWeight.w400,
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: Row(
//               children: [
//                 // Sidebar
//                 Expanded(
//                   flex: 4,
//                   child: Container(
//                     child: Column(
//                       children: [
//                         // Profile Progress
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Color.fromRGBO(31, 100, 255, 1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Stack(
//                                 alignment: Alignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 90,
//                                     height: 90,
//                                     child: CircularProgressIndicator(
//                                       value: 0.5,
//                                       strokeWidth: 1,
//                                       backgroundColor:
//                                           Color.fromRGBO(255, 255, 255, 0.1),
//                                       color: const Color.fromARGB(
//                                           255, 255, 255, 255),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: 90,
//                                     height: 90,
//                                     decoration: BoxDecoration(
//                                         color:
//                                             Color.fromRGBO(255, 255, 255, 0.1),
//                                         shape: BoxShape.circle),
//                                     child: Center(
//                                       child: Text(
//                                         "50%",
//                                         style: GoogleFonts.poppins(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                           color:
//                                               Color.fromRGBO(255, 255, 255, 1),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: 20,
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       "Profile Information",
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.w600,
//                                         color: Color.fromRGBO(255, 255, 255, 1),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       "Lorem ipsum dolor sit amet",
//                                       textAlign: TextAlign.center,
//                                       style: GoogleFonts.poppins(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w300,
//                                         color: Color.fromRGBO(255, 255, 255, 1),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//
//                         // Menu Items
//                         Expanded(
//                           child: ListView(
//                             children: const [
//                               SidebarItem(
//                                   icon: Icons.person,
//                                   title: "Profile Settings",
//                                   active: true),
//                               SidebarItem(
//                                   icon: Icons.calendar_today,
//                                   title: "Appointment Settings"),
//                               SidebarItem(
//                                   icon: Icons.folder_shared,
//                                   title: "Patient Records & Access"),
//                               SidebarItem(
//                                   icon: Icons.notifications,
//                                   title: "Notifications"),
//                               SidebarItem(
//                                   icon: Icons.note_alt,
//                                   title: "Prescription Templates"),
//                               SidebarItem(
//                                   icon: Icons.security,
//                                   title: "Security & Privacy"),
//                               SidebarItem(
//                                   icon: Icons.payment,
//                                   title: "Billing & Payments"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 // Right Content
//                 Expanded(
//                   flex: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 30),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.blue.shade200, width: 1),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Profile Settings",
//                           style: GoogleFonts.rubik(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Color.fromRGBO(0, 117, 255, 1),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         SettingsTile(
//                             title:
//                                 "Edit personal details (name, specialty, photo)"),
//                         Divider(
//                           height: 30,
//                         ),
//                         SettingsTile(
//                             title: "Update contact info (email, phone)"),
//                         Divider(
//                           height: 30,
//                         ),
//                         SettingsTile(title: "Change password"),
//                         Divider(
//                           height: 30,
//                         ),
//                         SettingsTile(title: "Language preference"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
// }
//
// class SidebarItem extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final bool active;
//
//   const SidebarItem({
//     super.key,
//     required this.icon,
//     required this.title,
//     this.active = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       decoration: BoxDecoration(
//         color: active
//             ? const Color.fromARGB(255, 252, 252, 252)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Icon(
//           icon,
//           size: 20,
//           color: active ? Colors.blue : Color.fromRGBO(142, 142, 142, 1),
//         ),
//         title: Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: active ? FontWeight.w600 : FontWeight.w400,
//             color: active
//                 ? Colors.blue.shade700
//                 : const Color.fromRGBO(142, 142, 142, 1),
//           ),
//         ),
//         trailing: const Icon(
//           Icons.chevron_right,
//           size: 18,
//           color: Color.fromRGBO(142, 142, 142, 1),
//         ),
//       ),
//     );
//   }
// }
//
// class SettingsTile extends StatelessWidget {
//   final String title;
//   const SettingsTile({super.key, required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       contentPadding: EdgeInsets.all(0),
//       title: Text(title, style: const TextStyle(fontSize: 14)),
//       trailing: const Icon(Icons.expand_more),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/authController.dart';
import '../../theme/apptheme.dart';
import '../../utils/constant.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedIndex = 0;
  final AuthController authController = Get.put(AuthController());
  final List<Map<String, dynamic>> _sidebarItems = [
    {'icon': Icons.person, 'title': "Profile Settings"},
    {'icon': Icons.calendar_today, 'title': "Appointment Settings"},
    {'icon': Icons.folder_shared, 'title': "Patient Records & Access"},
    {'icon': Icons.notifications, 'title': "Notifications"},
    {'icon': Icons.note_alt, 'title': "Prescription Templates"},
    {'icon': Icons.security, 'title': "Security & Privacy"},
    {'icon': Icons.payment, 'title': "Billing & Payments"},
  ];
  late TextEditingController nameController;
  late TextEditingController specialtyController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  @override
  void initState() {
    nameController =
        TextEditingController(text: authController.userProfile['name'] ?? '');
    specialtyController = TextEditingController(
        text: authController.userProfile['specialization'] ?? '');
    emailController =
        TextEditingController(text: authController.userProfile['email'] ?? '');
    phoneController = TextEditingController(
        text: authController.userProfile['mobile_number'] ?? '');
    super.initState();
  }

  List<Widget> _buildRightSideContent() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Settings",
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(0, 117, 255, 1),
            ),
          ),
          const SizedBox(height: 20),
          SettingsTile(
            title: "Edit personal details (name, specialty, photo)",
            initiallyExpanded: true, // Let's make the first one open by default
            child: Column(
              children: [
                Text("Full Name ${authController.userProfile['name']}"),
                const SizedBox(height: 10),
                Text("Full Name ${authController.userProfile['name']}"),
                const SizedBox(height: 10),
                Image.network(authController.userProfile[''])
              ],
            ),
          ),
          const Divider(),
          SettingsTile(
            title: "Update contact info (email, phone)",
            child: Column(
              children: [
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Email Address')),
                const SizedBox(height: 10),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number')),
              ],
            ),
          ),
          const Divider(),
          SettingsTile(
            title: "Change password",
            child: Column(
              children: [
                TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Current Password')),
                const SizedBox(height: 10),
                TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'New Password')),
                const SizedBox(height: 10),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Confirm New Password')),
              ],
            ),
          ),
          const Divider(),
          SettingsTile(
            title: "Language preference",
            child: DropdownButtonFormField<String>(
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
              ],
              onChanged: (value) {},
              decoration: const InputDecoration(labelText: 'Select Language'),
            ),
          ),
          const Divider(),
        ],
      ),
      // Content for Appointment Settings
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Settings",
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(0, 117, 255, 1),
            ),
          ),
          const Divider(),
          SettingsTile(
            title: "Set availability and working hours",
            child: Center(
                child: Text(
                    "Here you would put a calendar or day/time picker widgets.")),
          ),
          const Divider(),
          SettingsTile(
            title: "Configure appointment types and durations",
            child: Center(
                child: Text(
                    "Here you would have fields for 'Standard Consultation (30 mins)', etc.")),
          ),
          const Divider(),
        ],
      ),
      const Center(child: Text("Patient Records & Access Content")),
      const Center(child: Text("Notifications Content")),
      const Center(child: Text("Prescription Templates Content")),
      const Center(child: Text("Security & Privacy Content")),
      const Center(child: Text("Billing & Payments Content"))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text("Setting",
              style: GoogleFonts.rubik(
                color: AppTheme.blackColor,
                fontSize: Constant.foutyHeight(context),
                fontWeight: FontWeight.w400,
              )),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      // Profile Progress
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(31, 100, 255, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: CircularProgressIndicator(
                                    value: 0.5,
                                    strokeWidth: 1,
                                    backgroundColor:
                                        Color.fromRGBO(255, 255, 255, 0.1),
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(255, 255, 255, 0.1),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      "50%",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    "Profile Information",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Lorem ipsum dolor sit amet",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      ///Left list
                      Expanded(
                        child: ListView.builder(
                          itemCount: _sidebarItems.length,
                          itemBuilder: (context, index) {
                            final item = _sidebarItems[index];
                            return SidebarItem(
                              icon: item['icon'],
                              title: item['title'],
                              active: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),

                /// Right Content
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200, width: 1),
                    ),
                    child: _buildRightSideContent()[selectedIndex],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromARGB(255, 252, 252, 252)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            size: 20,
            color:
                active ? Colors.blue : const Color.fromRGBO(142, 142, 142, 1),
          ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active
                  ? Colors.blue.shade700
                  : const Color.fromRGBO(142, 142, 142, 1),
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            size: 18,
            color: Color.fromRGBO(142, 142, 142, 1),
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  const SettingsTile(
      {super.key,
      required this.title,
      required this.child,
      this.initiallyExpanded = false});

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        iconColor: Colors.blue,
        collapsedIconColor: Colors.grey.shade700,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
