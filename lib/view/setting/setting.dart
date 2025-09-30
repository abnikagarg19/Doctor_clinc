import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/shared_pref.dart';
import '../../theme/apptheme.dart';
import '../../utils/constant.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text("Setting",
              style: GoogleFonts.rubik(
                color: AppTheme.blackColor,
                fontSize: Constant.foutyHeight(context),
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Expanded(
                  flex: 4,
                  child: Container(
                    child: Column(
                      children: [
                        // Profile Progress
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(31, 100, 255, 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: CircularProgressIndicator(
                                      value: 0.5,
                                      strokeWidth: 1,
                                      backgroundColor: Color.fromRGBO(255, 255, 255, 0.1),
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                  Container(  width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.1), shape: BoxShape.circle),
                                    child: Center(
                                      child: Text(
                                        "50%",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                         SizedBox(width: 20,),
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
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                    ),
                                    const SizedBox(height: 4),
                                     Text(
                                      "Lorem ipsum dolor sit amet",
                                      textAlign: TextAlign.center,
                                     style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(255, 255, 255, 1),
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

                        // Menu Items
                        Expanded(
                          child: ListView(
                            children: const [
                              SidebarItem(
                                  icon: Icons.person,
                                  title: "Profile Settings",
                                  active: true),
                              SidebarItem(
                                  icon: Icons.calendar_today,
                                  title: "Appointment Settings"),
                              SidebarItem(
                                  icon: Icons.folder_shared,
                                  title: "Patient Records & Access"),
                              SidebarItem(
                                  icon: Icons.notifications,
                                  title: "Notifications"),
                              SidebarItem(
                                  icon: Icons.note_alt,
                                  title: "Prescription Templates"),
                              SidebarItem(
                                  icon: Icons.security,
                                  title: "Security & Privacy"),
                              SidebarItem(
                                  icon: Icons.payment,
                                  title: "Billing & Payments"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                // Right Content
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile Settings",
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 117, 255, 1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SettingsTile(
                            title:
                                "Edit personal details (name, specialty, photo)"),
                        Divider(
                          height: 30,
                        ),
                        SettingsTile(
                            title: "Update contact info (email, phone)"),
                        Divider(
                          height: 30,
                        ),
                        SettingsTile(title: "Change password"),
                        Divider(
                          height: 30,
                        ),
                        SettingsTile(title: "Language preference"),
                      ],
                    ),
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

  const SidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? const Color.fromARGB(255, 252, 252, 252)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon,size: 20, color: active ? Colors.blue :  Color.fromRGBO(142, 142, 142, 1),),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active ? Colors.blue.shade700 :      const Color.fromRGBO(142, 142, 142, 1),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18,color: Color.fromRGBO(142, 142, 142, 1),),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String title;
  const SettingsTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.expand_more),
    );
  }
}
