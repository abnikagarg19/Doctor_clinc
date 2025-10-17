import 'package:chatbot/view/videocall/videocall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/DoctorController.dart';
import '../../service/shared_pref.dart';
import '../../theme/apptheme.dart';
import '../../utils/constant.dart';
import '../../videocall/api.dart';
import '../../videocall/meeting_screen.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DateFormat dateFormat = DateFormat('EEEE, d MMM yyyy');
  List<DateTime> getNext7Days() {
    DateTime today = DateTime.now();
    return List.generate(10, (index) => today.add(Duration(days: index)));
  }

  final _controller = Get.put<Doctorcontroller>(Doctorcontroller());
  int selectedIndex = 0;
  int selectTimeSlotIndex = 0;
  final List<DateTime> dates =
      List.generate(30, (i) => DateTime.now().add(Duration(days: i - 7)));
  final DateTime today = DateTime.now();
  String date = "";
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  final List<String> _filterOptions = ['All', 'Follow up', 'Completed'];
  String _selectedFilter = 'All'; // Default value

  @override
  void initState() {
    data = [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  selectDate(index, date2) {
    selectedIndex = index;
    selectTimeSlotIndex = 0;
    date = DateFormat('dd-MMM-yyyy').format(date2).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  _buildWidget(context) {
    final DateTime dateTime = DateTime.now();
    final String formattedTime = DateFormat('HH:MM').format(dateTime);
    final String formattedDate = DateFormat('dd-MMM-yy').format(dateTime);
    List<DateTime> dates = getNext7Days();
    final userName = PreferenceUtils.getString("name") ?? "No Name";
    return GetBuilder<Doctorcontroller>(builder: (controller) {
      return Expanded(
        /// constraints: BoxConstraints(maxWidth: 500, minWidth: 400),
        child: !controller.isLoaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                    "Good Morning, Dr ${userName.isEmpty ? "No Name" : userName}",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                                color: AppTheme.whiteTextColor,
                                borderRadius: BorderRadius.circular(22)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Today’s Visitors",
                                        style: GoogleFonts.rubik(
                                          color: AppTheme.blackColor,
                                          fontSize:
                                              Constant.twetysixtext(context),
                                          fontWeight: FontWeight.w400,
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/time.png"),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(formattedTime,
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/cal.png"),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(formattedDate,
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text("10",
                                    style: GoogleFonts.rubik(
                                      color: AppTheme.lightPrimaryColor,
                                      fontSize: Constant.sixtyeight(context),
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: Color.fromRGBO(
                                                241, 249, 255, 1)),
                                        child: Column(
                                          children: [
                                            Text("Pending",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text("5",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme
                                                      .lightPrimaryColor,
                                                  fontSize: Constant.sixtyeight(
                                                      context),
                                                  height: 0,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: Color.fromRGBO(
                                                241, 249, 255, 1)),
                                        child: Column(
                                          children: [
                                            Text("Completed",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text("3",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme
                                                      .lightPrimaryColor,
                                                  height: 0,
                                                  fontSize: Constant.sixtyeight(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            color: Color.fromRGBO(
                                                241, 249, 255, 1)),
                                        child: Column(
                                          children: [
                                            Text("Cancelled",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  height: 0,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text("2",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme
                                                      .lightPrimaryColor,
                                                  height: 0,
                                                  fontSize: Constant.sixtyeight(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.whiteTextColor,
                                  borderRadius: BorderRadius.circular(22)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Appointments",
                                            style: GoogleFonts.rubik(
                                              color: AppTheme.blackColor,
                                              fontSize: Constant.TwentyHeight(
                                                  context),
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedFilter,
                                              dropdownColor: Colors.white,
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color.fromRGBO(
                                                      142, 142, 142, 1)),
                                              items: _filterOptions.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                        color: Color.fromRGBO(
                                                            142, 142, 142, 1)),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  if (newValue != null) {
                                                    _selectedFilter = newValue;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Color.fromRGBO(226, 226, 227, 1),
                                  ),
                                  if (controller
                                      .appointmentList[0]["meeting"].isNotEmpty)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller
                                          .appointmentList[0]["meeting"].length,
                                      primary: false,
                                      itemBuilder: (context, index) {
                                        final data =
                                            controller.appointmentList[0]
                                                ["meeting"][index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.whiteTextColor,
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color.fromRGBO(
                                                        226, 226, 227, 1))),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("John Smith",
                                                      style: GoogleFonts.rubik(
                                                        color:
                                                            AppTheme.blackColor,
                                                        fontSize:
                                                            Constant.smallbody(
                                                                context),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      )),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(MeetingScreen(
                                                          meetingId: data[
                                                              "meeting_id_front"],
                                                          token: token));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: AppTheme
                                                              .powderBlue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6),
                                                      child: Text("Connect",
                                                          style:
                                                              GoogleFonts.rubik(
                                                            color: AppTheme
                                                                .whiteTextColor,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Text("${data["from_time"]} ",
                                                  style: GoogleFonts.rubik(
                                                    color: AppTheme
                                                        .lightHintTextColor,
                                                    fontSize:
                                                        Constant.smallbody(
                                                            context),
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                  "Reason : ${data["description"]} ",
                                                  style: GoogleFonts.rubik(
                                                    color: AppTheme.linkColor,
                                                    fontSize:
                                                        Constant.smallbody(
                                                            context),
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  else
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                            "Verification may take 24–48 hrs to display patients.",
                                            style: GoogleFonts.rubik(
                                              color:
                                                  AppTheme.lightHintTextColor,
                                              fontSize:
                                                  Constant.smallbody(context),
                                              fontWeight: FontWeight.w500,
                                            )),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                      SizedBox(
                        width: 40,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.lightPrimaryColor,
                                borderRadius: BorderRadius.circular(22)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("John Smith",
                                        style: GoogleFonts.rubik(
                                          color: AppTheme.whiteTextColor,
                                          fontSize: Constant.smallbody(context),
                                          fontWeight: FontWeight.w500,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text("10:30 AM ",
                                        style: GoogleFonts.rubik(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: Constant.smallbody(context),
                                          fontWeight: FontWeight.w400,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text("Reason : Weekly visit ",
                                        style: GoogleFonts.rubik(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: Constant.smallbody(context),
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(DoctorVideoCall(
                                        meetingId: "kv3f-g63t-55fx",
                                        token: token));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.whiteTextColor,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Text("Join Now",
                                        style: GoogleFonts.rubik(
                                          color: AppTheme.lightPrimaryColor,
                                          fontSize: Constant.smallbody(context),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          /// Schedule Calender
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: AppTheme.whiteTextColor,
                          //       borderRadius: BorderRadius.circular(22)),
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         height: 20,
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.symmetric(
                          //           horizontal: 20,
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             Text("Schedule Calendar",
                          //                 style: GoogleFonts.rubik(
                          //                   color: AppTheme.blackColor,
                          //                   fontSize:
                          //                       Constant.TwentyHeight(context),
                          //                   fontWeight: FontWeight.w600,
                          //                 )),
                          //           ],
                          //         ),
                          //       ),
                          //       Divider(
                          //         height: 20,
                          //         color: Color.fromRGBO(226, 226, 227, 1),
                          //       ),
                          //       SingleChildScrollView(
                          //         scrollDirection: Axis.horizontal,
                          //         child: Row(
                          //           children: List.generate(
                          //             dates.length,
                          //             (index) {
                          //               bool isSelected =
                          //                   selectedIndex == index;
                          //               return GestureDetector(
                          //                 onTap: () {
                          //                   selectDate(index, dates[index]);
                          //                 },
                          //                 child: Container(
                          //                   margin: EdgeInsets.symmetric(
                          //                       horizontal: 8, vertical: 10),
                          //                   padding: EdgeInsets.symmetric(
                          //                       horizontal: 16, vertical: 18),
                          //                   decoration: BoxDecoration(
                          //                     color: isSelected
                          //                         ? AppTheme.lightPrimaryColor
                          //                         : Colors.transparent,
                          //                     borderRadius:
                          //                         BorderRadius.circular(16),
                          //                   ),
                          //                   child: Column(
                          //                     children: [
                          //                       Text(
                          //                           DateFormat('E')
                          //                               .format(dates[index]),
                          //                           style: GoogleFonts.rubik(
                          //                             color: isSelected
                          //                                 ? Colors.white
                          //                                 : Colors.black,
                          //                             fontSize:
                          //                                 Constant.smallbody(
                          //                                     context),
                          //                             fontWeight:
                          //                                 FontWeight.w300,
                          //                           )),
                          //                       SizedBox(
                          //                         height: 8,
                          //                       ),
                          //                       Text(
                          //                         DateFormat('d')
                          //                             .format(dates[index]),
                          //                         textAlign: TextAlign.center,
                          //                         style: GoogleFonts.rubik(
                          //                           color: isSelected
                          //                               ? Colors.white
                          //                               : Colors.black,
                          //                           fontSize: 16,
                          //                           fontWeight: isSelected
                          //                               ? FontWeight.w600
                          //                               : FontWeight.w600,
                          //                         ),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               );
                          //             },
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 12,
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.whiteTextColor,
                                borderRadius: BorderRadius.circular(22)),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Text("Schedule Calendar",
                                          style: GoogleFonts.rubik(
                                            color: AppTheme.blackColor,
                                            fontSize:
                                                Constant.TwentyHeight(context),
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 20,
                                  color: Color.fromRGBO(226, 226, 227, 1),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      dates.length,
                                      (index) {
                                        final date = dates[index];

                                        final isToday =
                                            date.year == today.year &&
                                                date.month == today.month &&
                                                date.day == today.day;

                                        final bool isSelected =
                                            selectedIndex == index;

                                        return GestureDetector(
                                          onTap: () {
                                            selectDate(index, dates[index]);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 18),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppTheme.lightPrimaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: isToday && !isSelected
                                                  ? Border.all(
                                                      color: AppTheme
                                                          .lightPrimaryColor,
                                                      width: 1.5)
                                                  : null,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                    DateFormat('E')
                                                        .format(dates[index]),
                                                    style: GoogleFonts.rubik(
                                                      // Text color changes only for selected item
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  DateFormat('d')
                                                      .format(dates[index]),
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.rubik(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          ///chart
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: AppTheme.whiteTextColor,
                                    borderRadius: BorderRadius.circular(22)),
                                child: SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                      placeLabelsNearAxisLine: false,
                                      axisLine: AxisLine(),
                                      majorGridLines: MajorGridLines(),
                                    ),
                                    primaryYAxis: NumericAxis(
                                        minimum: 0, maximum: 40, interval: 10),
                                    tooltipBehavior: _tooltip,
                                    series: <CartesianSeries<_ChartData,
                                        String>>[
                                      ColumnSeries<_ChartData, String>(
                                          dataSource: data,

                                          /// xAxisName: "No. of Patient",

                                          xValueMapper: (_ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (_ChartData data, _) =>
                                              data.y,
                                          name: 'Paytent',
                                          color: Color.fromRGBO(8, 142, 255, 1))
                                    ])),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //  if(controller.isLoaded)
                // if(controller.resposeList.isNotEmpty)
              ]),
      );
    });
  }

  Widget filterDropDown() {
    final List<String> _filterOptions = ['All', 'Follow up', 'Completed'];
    String _selectedFilter = 'All';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          // 3. The value that is currently selected.
          value: _selectedFilter,

          // The dropdown arrow icon
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color.fromRGBO(142, 142, 142, 1)),

          // 4. The callback that runs when the user selects a new item.
          onChanged: (String? newValue) {
            // Update the state with the new selection.
            setState(() {
              if (newValue != null) {
                _selectedFilter = newValue;
                // You can add any filtering logic here, for example:
                // print("Filter changed to: $_selectedFilter");
                // controller.applyFilter(_selectedFilter);
              }
            });
          },

          // 5. Mapping your list of strings to a list of DropdownMenuItem widgets.
          items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Color.fromRGBO(142, 142, 142, 1)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
