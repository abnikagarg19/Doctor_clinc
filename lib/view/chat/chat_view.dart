import 'package:chatbot/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/chatController.dart';
import '../../utils/constant.dart';

class PatientChatPage extends StatefulWidget {
  PatientChatPage({super.key});

  @override
  State<PatientChatPage> createState() => _PatientChatPageState();
}

class _PatientChatPageState extends State<PatientChatPage> {
  List tabsLIst = [
    "Summary",
    "Timeline",
    "Concerns",
    "Lab Results",
    "Medications"
  ];
  int selectTabs = 0;
  String selectedTab = "vitals";
  final controller = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Left Sidebar

              Expanded(
                flex: 3,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.whiteTextColor,
                      borderRadius: BorderRadius.circular(22),
                      border:
                          Border.all(color: Color.fromRGBO(213, 213, 213, 1))),
                  child: ListView.builder(
                    itemCount: controller.patients.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.selectChat(controller.patients[index]);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 12),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color:
                                          Color.fromRGBO(213, 213, 213, 1)))),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(Icons.person,
                                    color: Colors.black54),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${controller.patients[index]["name"]}",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 16,
                                      color: AppTheme.blackColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "Start the conversation",
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      color: AppTheme.blackColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),

              //  Middle Chat Section
              Expanded(
                flex: 4,
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: AppTheme.whiteTextColor,
                      borderRadius: BorderRadius.circular(22),
                      border:
                          Border.all(color: Color.fromRGBO(213, 213, 213, 1))),
                  child: controller.isLoadingChatHistory.value
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(60, 150, 255, 1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22),
                                      topRight: Radius.circular(22))),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person,
                                        color: Colors.black87),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                      "${controller.selectedPatient.value!["name"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              child: controller.messages.value.isEmpty
                                  ? Center(
                                      child: Text("Start the conversation"),
                                    )
                                  : ListView.builder(
                                      // reverse: true,
                                      controller: controller
                                          .scrollController, // 👈 attach controller
                                      //controller: controller.scrollcontroller,
                                      itemCount: controller.messages.length,
                                      padding: EdgeInsets.zero,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // final words = controller.aichatList[index]["ans"]
                                        //     .toString()
                                        //     .split(' ');

                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              if (controller.messages[index]
                                                      ["sender_type"] ==
                                                  "doctor")
                                                Container(
                                                  // color:
                                                  //     Theme.of(context).scaffoldBackgroundColor,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin: EdgeInsets.only(
                                                      right: 0,
                                                    ),
                                                    // decoration: BoxDecoration(
                                                    //   color: AppTheme.whiteBackgroundColor,
                                                    //   borderRadius: BorderRadius.circular(12),
                                                    // ),
                                                    child: IntrinsicHeight(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Flexible(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      right: 6,
                                                                      top: 6,
                                                                      bottom: 6,
                                                                    ),
                                                                    child: Text(
                                                                        "${controller.messages[index]["message_content"]}",
                                                                        style: GoogleFonts
                                                                            .quicksand(
                                                                          color: Color.fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              1),
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          height:
                                                                              1.6,
                                                                        )))
                                                              ],
                                                            ),
                                                          ),
                                                          VerticalDivider(
                                                            color:
                                                                Color.fromRGBO(
                                                                    66,
                                                                    217,
                                                                    129,
                                                                    1),
                                                            width: 20,
                                                            thickness: 4,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(height: 20),
                                              if (controller.messages[index]
                                                      ["sender_type"] ==
                                                  "patient")
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        VerticalDivider(
                                                          color: AppTheme
                                                              .lightPrimaryColor,
                                                          width: 20,
                                                          thickness: 4,
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            // margin:
                                                            //     EdgeInsets
                                                            //         .only(
                                                            //   right: 40,
                                                            // ),
                                                            // width: MediaQuery.of(
                                                            //             context)
                                                            //         .size
                                                            //         .width /
                                                            //     2.6,
                                                            // decoration: BoxDecoration(
                                                            //   color: AppTheme.whiteBackgroundColor,
                                                            //   borderRadius: BorderRadius.circular(12),
                                                            // ),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 8,
                                                                top: 2,
                                                                bottom: 2,
                                                              ),
                                                              child: Text(
                                                                "${controller.messages[index]["message_content"]}",
                                                                style: GoogleFonts
                                                                    .quicksand(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  height: 1.6,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(height: 20),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: Colors.grey.shade300)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller.chatcontroller,
                                      onChanged: (value) {
                                        controller.changeStatus(
                                          value,
                                        );
                                      },
                                      onSubmitted: (value) {
                                        if (controller.sendButton.value) {
                                          controller.sendMessage();
                                          controller.chatcontroller.clear();
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Type a message",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor:
                                            Color.fromRGBO(232, 232, 232, 1),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller.sendButton.value) {
                                        controller.sendMessage();
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          controller.sendButton.value
                                              ? Colors.blue
                                              : Color.fromRGBO(
                                                  148,
                                                  148,
                                                  148,
                                                  1,
                                                ),
                                      child: const Icon(Icons.send,
                                          color: Colors.white),
                                    ),
                                  ),
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
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        tabsLIst.length,
                        (index) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTabs = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: selectTabs == index
                                        ? Color.fromRGBO(60, 150, 255, 1)
                                        : AppTheme.whiteTextColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                            132, 149, 147, 147),
                                        spreadRadius: 1,
                                        offset: const Offset(0, 6),
                                        blurRadius: 10,
                                      )
                                    ],
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    )),
                                child: Center(
                                  child: Text("${tabsLIst[index]}",
                                      style: GoogleFonts.rubik(
                                          color: selectTabs == index
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(
                                                  142, 142, 142, 1),
                                          fontSize:
                                              Constant.verysmallbody(context),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text("Patient name: Raj Kumar",
                                              style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize:
                                                      Constant.twetysixtext(
                                                          context),
                                                  fontWeight: FontWeight.w700)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                              "23y old male patient presents with a mild-grade febrile illness accompanied by a productive cough yielding white, odorless, non-blood-tinged sputum. Symptoms have been gradual in onset, with no associated chills, dyspnea, chest pain, or systemic complaints. There is no past medical history suggestive of diabetes, hypertension, thyroid dysfunction, or tuberculosis. Personal and lifestyle history are unremarkable.",
                                              style: GoogleFonts.quicksand(
                                                  color: AppTheme.blackColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text("Symptoms:",
                                              style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w700)),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              """Pain: A headache, back pain, stomachache.
                                  Fatigue: Feeling unusually tired or weak.
                                  Nausea: Feeling sick to your stomach, with an urge to vomit.
                                  Fever: An elevated body temperature.
                                  Muscle aches: Pain or soreness in the muscles.
                                  Coughing: A reflex action to clear the airways.
                                  Night sweats: Excessive sweating during sleep.
                                  """,
                                              style: GoogleFonts.quicksand(
                                                  color: AppTheme.blackColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                    ),
                                    Image.asset("assets/images/full_body.png")
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     _infoButton(
                                //         "Patient Vitals", selectedTab == "vitals", () {
                                //       setState(() => selectedTab = "vitals");
                                //     }),
                                //     _infoButton(
                                //         "Patient Summary", selectedTab == "summary",
                                //         () {
                                //       setState(() => selectedTab = "summary");
                                //     }),
                                //   ],
                                // ),
                                // const SizedBox(height: 20),
                                // Expanded(
                                //     child: selectedTab == "vitals"
                                //         ? PatientVitalsWidget(height, width)
                                //         : PatientSummaryWidget(height, width))
                              ])),
                    ),
                  ],
                ),
              ),
            ]),
      );
    }));
  }
}
