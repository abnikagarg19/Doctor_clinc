import 'package:chatbot/controller/DoctorController.dart';
import 'package:chatbot/models/DoctorModelMeeting.dart';
import 'package:chatbot/videocall/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/apptheme.dart';
import '../utils/constant.dart';
import 'meeting_screen.dart';

class DoctorJoinScreen extends StatelessWidget {
  final _controller = Get.put<Doctorcontroller>(Doctorcontroller());

  DoctorJoinScreen({super.key});

  // void onCreateButtonPressed(BuildContext context) async {
  //   // call api to create meeting and then navigate to MeetingScreen with meetingId,token
  //   await createMeeting().then((meetingId) {
  //     if (!context.mounted) return;
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => MeetingScreen(
  //           meetingId: meetingId,
  //           token: token,
  //         ),
  //       ),
  //     );
  //   });
  // }

  void onJoinButtonPressed(BuildContext context) {
    //   String meetingId = _meetingIdController.text;
    var re = RegExp("\\w{4}\\-\\w{4}\\-\\w{4}");
    // // check meeting id is not null or invaild
    // // if meeting id is vaild then navigate to MeetingScreen with meetingId,token
    // if (meetingId.isNotEmpty && re.hasMatch(meetingId)) {
    //   _meetingIdController.clear();
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => MeetingScreen(
    //         meetingId: meetingId,
    //         token: token,
    //       ),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text("Please enter valid meeting id"),
    //   ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.whiteBackgroundColor,
          title: const Text('Doctor’s Dashboard'),
          titleSpacing: 30,
          centerTitle: false,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 20),
          //     child: GestureDetector(
          //         onTap: () {
          //           Get.back();
          //         },
          //         child: SvgPicture.asset("assets/svg/cross.svg")),
          //   ),
          // ],
        ),
        body: GetBuilder<Doctorcontroller>(builder: (controller) {
          return SingleChildScrollView(
            child: Column(children: [
              // SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     GestureDetector(
              //         onTap: () {
              //           Get.back();
              //         },
              //         child: SvgPicture.asset("assets/svg/cross.svg")),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(color: AppTheme.backGround),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/images/profile.png",
                          height: 80,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Prashant\'s Clinic',
                            style: GoogleFonts.rubik(
                              color: AppTheme.blackColor,
                              fontSize: Constant.smallbody(context),
                              fontWeight: FontWeight.w700,
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        Text('General Physician',
                            style: GoogleFonts.rubik(
                              color: AppTheme.blackColor,
                              fontSize: Constant.smallbody(context),
                              fontWeight: FontWeight.w400,
                            )),
                        SizedBox(
                          height: 2,
                        ),
                        Text("1 Appointments today",
                            style: GoogleFonts.rubik(
                              color: AppTheme.linkColor,
                              fontSize: Constant.smallbody(context),
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),

              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Upcoming Call's",
                                style: GoogleFonts.quicksand(
                                  color: AppTheme.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                // onTap: () async {
                                //   final picked = await showDatePicker(
                                //     context: Get.context!,
                                //     initialDate: controller.selectedDate,
                                //     firstDate: DateTime.now().subtract(
                                //       Duration(days: 355),
                                //     ),
                                //     lastDate: DateTime.now().add(
                                //       Duration(days: 365),
                                //     ),
                                //   );

                                //   if (picked != null) {
                                //     setState(() {
                                //       selectedDate = picked!;
                                //     });
                                //     controller.getappointmentList(
                                //       DateFormat(
                                //         "yyyy-MM-dd",
                                //       ).format(selectedDate),
                                //     );
                                //   }
                                // },
                                child: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        // !_controller.isLoaded
                        //     ? Center(child: CircularProgressIndicator())
                        //     : controller.appointmentList.first["meeting"] !=
                        //             null
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          // itemCount: controller.appointmentList
                          //     .first["meeting"].length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      31,
                                      87,
                                      87,
                                      87,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.circular(
                                        //     100,
                                        //   ),
                                        //   child: Image.asset(
                                        //     "assets/newicons/profile.jpeg",
                                        //     height: 60,
                                        //     width: 60,
                                        //     fit: BoxFit.cover,
                                        //   ),
                                        // ),
                                        // SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "John Smith",
                                                style: GoogleFonts.quicksand(
                                                  color: Color.fromRGBO(
                                                    54,
                                                    100,
                                                    188,
                                                    1,
                                                  ),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "General Surgeon ",
                                                style: GoogleFonts.quicksand(
                                                  color: Color.fromRGBO(
                                                    94,
                                                    205,
                                                    129,
                                                    1,
                                                  ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                "Doctor Appointment",
                                                //  "${_controller.appointmentList.first["meeting"]![index]["slotTime"]} | ${_controller.appointmentList.first["meeting"]![index]["date"]} ",
                                                style: GoogleFonts.rubik(
                                                  color: Color.fromRGBO(
                                                    103,
                                                    148,
                                                    231,
                                                    1,
                                                  ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              // if (selected == 1)
                                              //   SizedBox(height: 6),
                                              // if (selected == 1)
                                              //   StarRating(
                                              //     color: AppTheme.starColor,
                                              //     rating: 3,
                                              //     onRatingChanged: (rating) =>
                                              //         null,
                                              //     starCount: 5,
                                              //   ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            //meeting_id_front
                                            Get.to(
                                              MeetingScreen(
                                                meetingId: "kv3f-g63t-55fx",
                                                token: token,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                220,
                                                251,
                                                229,
                                                1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                8,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20),
                                            child: Center(
                                              child: Text(
                                                "Connect",
                                                style: GoogleFonts.rubik(
                                                  color: Color.fromRGBO(
                                                    94,
                                                    205,
                                                    129,
                                                    1,
                                                  ),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            );
                          },
                        )
                        // : Center(
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(16.0),
                        //       child: Text("No Appointments"),
                        //     ),
                        //   ),
                      ]))
              //  if(controller.isLoaded)
              // if(controller.resposeList.isNotEmpty)
              // ListView.builder(
              //   shrinkWrap: true,
              //   itemCount: 1,
              //   primary: false,
              //   itemBuilder: (context, index) {
              //     return Container(
              //       decoration: BoxDecoration(
              //           color: AppTheme.whiteTextColor,
              //           borderRadius: BorderRadius.circular(12)),
              //       margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text("Raj Kumar",
              //                   style: GoogleFonts.rubik(
              //                     color: AppTheme.blackColor,
              //                     fontSize: Constant.smallbody(context),
              //                     fontWeight: FontWeight.w700,
              //                   )),
              //               GestureDetector(
              //                 onTap: () {
              //                   Get.to(MeetingScreen(
              //                       meetingId:
              //                       "nbog-jc1c-g15a", token: token));
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: AppTheme.powderBlue,
              //                       borderRadius: BorderRadius.circular(8)),
              //                   padding: EdgeInsets.symmetric(
              //                       horizontal: 10, vertical: 6),
              //                   child: Text("Connect",
              //                       style: GoogleFonts.rubik(
              //                         color: AppTheme.whiteTextColor,
              //                         fontSize: 12,
              //                         fontWeight: FontWeight.w700,
              //                       )),
              //                 ),
              //               )
              //             ],
              //           ),
              //           Text("I have fever with cough , sneezing symptons",
              //               style: GoogleFonts.rubik(
              //                 color: AppTheme.blackColor,
              //                 fontSize: Constant.smallbody(context),
              //                 fontWeight: FontWeight.w400,
              //               )),
              //           SizedBox(
              //             height: 4,
              //           ),
              //           Text("17 July 2025 , 2:00 pm",
              //               style: GoogleFonts.rubik(
              //                 color: AppTheme.linkColor,
              //                 fontSize: Constant.smallbody(context),
              //                 fontWeight: FontWeight.w500,
              //               )),
              //         ],
              //       ),
              //     );
              //   },
              // )
              // // body: Padding(
              // //   padding: const EdgeInsets.all(12.0),
              // //   child: Column(
              // //     mainAxisAlignment: MainAxisAlignment.center,
              // //     children: [
              // //       ElevatedButton(
              // //         onPressed: () => onCreateButtonPressed(context),
              // //         child: const Text('Create Meeting'),
              // //       ),
              // //       Container(
              // //         margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              // //         child: TextField(
              // //           decoration: const InputDecoration(
              // //             hintText: 'Meeting Id',
              // //             border: OutlineInputBorder(),
              // //           ),
              // //           controller: _meetingIdController,
              // //         ),
              // //       ),
              // //       ElevatedButton(
              // //         onPressed: () => onJoinButtonPressed(context),
              // //         child: const Text('Join Meeting'),
              // //       ),
              // //     ],
              // //   ),
              // // ),
            ]),
          );
        }));
  }
}
