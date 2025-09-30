import 'package:chatbot/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
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
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(213, 213, 213, 1)))),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            child:
                                const Icon(Icons.person, color: Colors.black54),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Raj Kumar",
                                style: GoogleFonts.quicksand(
                                  fontSize: 18,
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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(60, 150, 255, 1), borderRadius:BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22)) ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Colors.black87),
                          ),
                          SizedBox(width: 12),
                          Text("Raj Kumar",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                     Expanded(
                child: ListView.builder(
                  reverse: true,
                  //controller: controller.scrollcontroller,
                  itemCount: 1,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    // final words = controller.aichatList[index]["ans"]
                    //     .toString()
                    //     .split(' ');

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            // color:
                            //     Theme.of(context).scaffoldBackgroundColor,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(right: 0, ),
                              // decoration: BoxDecoration(
                              //   color: AppTheme.whiteBackgroundColor,
                              //   borderRadius: BorderRadius.circular(12),
                              // ),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              right: 6,
                                              top: 6,
                                              bottom: 6,
                                            ),
                                            child: Text(
                                              "Hi My name is Raj ",
                                             style: GoogleFonts.quicksand(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 14,fontWeight: FontWeight.w500,
                                            height: 1.6,
                                            
                                          
                                          )))
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: Color.fromRGBO(66, 217, 129, 1),
                                      width: 20,
                                      thickness: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  VerticalDivider(
                                    color: AppTheme.lightPrimaryColor,
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
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 8,
                                         
                                          top: 2,
                                          bottom: 2,
                                        ),
                                        child: Text(
                                          "Hi Raj welcome ",
                                          style: GoogleFonts.quicksand(
                                            color: Color.fromRGBO(0, 0, 0, 1),
                                            fontSize: 14,fontWeight: FontWeight.w500,
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
                          SizedBox(height: 30),
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
                            top: BorderSide(color: Colors.grey.shade300)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Type a message",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Color.fromRGBO(232, 232, 232, 1),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade600,
                            child: const Icon(Icons.send, color: Colors.white),
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
            ),Expanded(
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
                                            : Color.fromRGBO(142, 142, 142, 1),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                                                fontSize: Constant.twetysixtext(
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
                                                fontSize:
                                                    Constant.smallbody(context),
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
         ]
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  const ChatBubble({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  const TabButton({super.key, required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? Colors.blue.shade600 : Colors.black87,
        ),
      ),
    );
  }
}
