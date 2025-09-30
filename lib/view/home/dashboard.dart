import 'package:chatbot/view/videocall/videocall.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../controller/DoctorController.dart';
import '../../service/shared_pref.dart';
import '../../theme/apptheme.dart';
import 'package:intl/intl.dart';
import '../../utils/constant.dart';
import '../../videocall/api.dart';
import '../../videocall/meeting_screen.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  final DateFormat dateFormat = DateFormat('EEEE, d MMM yyyy');

  List<DateTime> getNext7Days() {
    DateTime today = DateTime.now();
    return List.generate(10, (index) => today.add(Duration(days: index)));
  }

  final _controller = Get.put<Doctorcontroller>(Doctorcontroller());

  int selectedIndex = -1;

  int selectTimeSlotIndex = 0;

  String date = "";
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

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

  _buildWidget(context) {
    List<DateTime> dates = getNext7Days();
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
                Text("Good Morning, Dr ${PreferenceUtils.getString("name")}",
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
                                            Text("  10:00 AM",
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
                                            Text("  26-06-2025",
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
                                Text("150",
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
                                            Text("Completed",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text("50",
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
                                            Text("50",
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
                                            Text("Completed",
                                                style: GoogleFonts.rubik(
                                                  color: AppTheme.blackColor,
                                                  fontSize: Constant.smallbody(
                                                      context),
                                                  height: 0,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            Text("50",
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
                                        GestureDetector(
                                            onTap: () async {
                                              DateTime? pickedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1947),
                                                lastDate: DateTime(2030),
                                              );

                                              if (pickedDate != null) {
                                                print(pickedDate);
                                                String formattedDate =
                                                    DateFormat(
                                                  'dd/MMM/yyyy',
                                                ).format(pickedDate);
                                                print(formattedDate);
                                              } else {
                                                print(
                                                    "end from date is not selected");
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Today ",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          142, 142, 142, 1)),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Color.fromRGBO(
                                                      142, 142, 142, 1),
                                                )
                                              ],
                                            ))
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
                                        child: Text("Verification may take 24–48 hrs to display patients.",
                                            style: GoogleFonts.rubik(
                                              color: AppTheme.lightHintTextColor,
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
                                     
                                          meetingId: "kv3f-g63t-55fx", token: token));
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
                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.whiteTextColor,
                                borderRadius: BorderRadius.circular(22)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
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
                                Divider(
                                  height: 20,
                                  color: Color.fromRGBO(226, 226, 227, 1),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      dates.length,
                                      (index) {
                                        bool isSelected =
                                            selectedIndex == index;
                                        return GestureDetector(
                                          onTap: () {
                                            selectDate(index, dates[index]);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 18),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppTheme.lightPrimaryColor
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                    DateFormat('E')
                                                        .format(dates[index]),
                                                    style: GoogleFonts.rubik(
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                SizedBox(
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
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w600,
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
                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
