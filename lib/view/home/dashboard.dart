import 'package:chatbot/utils/custom_print.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controller/DoctorController.dart';
import '../../controller/chatController.dart';
import '../../models/apppointment_modal.dart';
import '../../service/shared_pref.dart';
import '../../theme/apptheme.dart';
import '../../utils/constant.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final DateFormat dateFormat = DateFormat('EEEE, d MMM yyyy');

  List<DateTime> getNext7Days() {
    DateTime today = DateTime.now();
    return List.generate(10, (index) => today.add(Duration(days: index)));
  }

  final _controller = Get.put<Doctorcontroller>(Doctorcontroller());
  final chatController = Get.put(ChatController());
  int selectedIndex = 0;
  int selectTimeSlotIndex = 0;
  final List<DateTime> dates =
      List.generate(30, (i) => DateTime.now().add(Duration(days: i - 7)));
  final DateTime today = DateTime.now();
  final TextEditingController _chatInputController = TextEditingController();
  ChatState chatState = ChatState.minimized;
  String date = "";
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  /// animation on speak
  void startAnimation() {
    setState(() {
      chatController.isAiSpeaking.value = true;
    });
    _animationController.repeat(reverse: true);
  }

  void stopAiAnimation() {
    setState(() {
      chatController.isAiSpeaking.value = false;
    });
    _animationController.stop();
    _animationController.reset();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    data = [
      _ChartData('Mon', 12),
      _ChartData('Tue', 15),
      _ChartData('Wed', 30),
      _ChartData('Thu', 6.4),
      _ChartData('Fri', 14),
      _ChartData('Sat', 30),
      _ChartData('Sun', 39)
    ];
    _controller.applyFilter();
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  selectDate(index, date2) {
    selectedIndex = index;
    selectTimeSlotIndex = 0;
    date = DateFormat('dd-MMM-yyyy').format(date2).toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final doctorController = Get.put(Doctorcontroller());
    return _buildWidget(context, doctorController);
  }

  _buildWidget(context, Doctorcontroller controller) {
    final DateTime dateTime = DateTime.now();
    final String formattedTime = DateFormat('HH:MM').format(dateTime);
    final String formattedDate = DateFormat('dd-MMM-yy').format(dateTime);
    List<DateTime> dates = getNext7Days();
    final userName = PreferenceUtils.getString("name") ?? "No Name";

    // Helper method to get status color
    Color _getTagColor(String tag) {
      switch (tag.toLowerCase()) {
        case "new":
          return Colors.green.shade100;
        case "follow up":
          return Colors.blue.shade100;
        default:
          return Colors.grey.shade200;
      }
    }

    // STATUS color (right badge - Confirmed / Completed)
    Color _getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case "confirmed":
          return Colors.blue.shade400;
        case "completed":
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

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

                /// left section
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Today’s Visitors",
                                            style: GoogleFonts.rubik(
                                              color: AppTheme.blackColor,
                                              fontSize: Constant.twetysixtext(
                                                  context),
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
                                                      color:
                                                          AppTheme.blackColor,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                                      color:
                                                          AppTheme.blackColor,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                          fontSize:
                                              Constant.sixtyeight(context),
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: Color.fromRGBO(
                                                    241, 249, 255, 1)),
                                            child: Column(
                                              children: [
                                                Text("Pending",
                                                    style: GoogleFonts.rubik(
                                                      color:
                                                          AppTheme.blackColor,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                Text("5",
                                                    style: GoogleFonts.rubik(
                                                      color: AppTheme
                                                          .lightPrimaryColor,
                                                      fontSize:
                                                          Constant.sixtyeight(
                                                              context),
                                                      height: 0,
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: Color.fromRGBO(
                                                    241, 249, 255, 1)),
                                            child: Column(
                                              children: [
                                                Text("Completed",
                                                    style: GoogleFonts.rubik(
                                                      color:
                                                          AppTheme.blackColor,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                Text("3",
                                                    style: GoogleFonts.rubik(
                                                      color: AppTheme
                                                          .lightPrimaryColor,
                                                      height: 0,
                                                      fontSize:
                                                          Constant.sixtyeight(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                                color: Color.fromRGBO(
                                                    241, 249, 255, 1)),
                                            child: Column(
                                              children: [
                                                Text("Cancelled",
                                                    style: GoogleFonts.rubik(
                                                      color:
                                                          AppTheme.blackColor,
                                                      fontSize:
                                                          Constant.smallbody(
                                                              context),
                                                      height: 0,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                Text("2",
                                                    style: GoogleFonts.rubik(
                                                      color: AppTheme
                                                          .lightPrimaryColor,
                                                      height: 0,
                                                      fontSize:
                                                          Constant.sixtyeight(
                                                              context),
                                                      fontWeight:
                                                          FontWeight.w400,
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
                              GetBuilder<Doctorcontroller>(builder: (logic) {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      ///Heading
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Appointments",
                                              style: GoogleFonts.rubik(
                                                color: AppTheme.blackColor,
                                                fontSize: Constant.TwentyHeight(
                                                    context),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color: Colors.grey.shade300,
                                                    width: 1),
                                              ),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value:
                                                      controller.selectedFilter,
                                                  dropdownColor: Colors.white,
                                                  icon: const Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Color.fromRGBO(
                                                        142, 142, 142, 1),
                                                  ),
                                                  items: controller
                                                      .filterOptions
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: const TextStyle(
                                                          color: Color.fromRGBO(
                                                              142, 142, 142, 1),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      if (newValue != null) {
                                                        controller
                                                                .selectedFilter =
                                                            newValue;
                                                        controller.changeFilter(
                                                            newValue);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                          color:
                                              Color.fromRGBO(226, 226, 227, 1)),

                                      ///List
                                      controller.appointmentLoading.value ==
                                              false
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      AppTheme.whiteTextColor,
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                ),
                                                child: controller
                                                        .filteredAppointments
                                                        .isNotEmpty
                                                    ? ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemCount: controller
                                                            .filteredAppointments
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final data = controller
                                                                  .filteredAppointments[
                                                              index];
                                                          final appointment =
                                                              Appointment
                                                                  .fromJson(
                                                                      data);

                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          6,
                                                                      horizontal:
                                                                          10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                border:
                                                                    const Border(
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Left video indicator
                                                                  appointment
                                                                          .isOnline
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(16),
                                                                            bottomLeft:
                                                                                Radius.circular(16),
                                                                          ),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                70,
                                                                            height:
                                                                                100,
                                                                            color:
                                                                                const Color(0xFF4F7CF9),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.videocam_rounded,
                                                                              color: Colors.white,
                                                                              size: 28,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const SizedBox(
                                                                          width:
                                                                              0),

                                                                  // Right details
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              16.0,
                                                                          vertical:
                                                                              12.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          // Name + Status
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  appointment.patientName,
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w700,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: _getStatusColor(appointment.status),
                                                                                  borderRadius: BorderRadius.circular(30),
                                                                                ),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                                                                child: Text(
                                                                                  appointment.status,
                                                                                  style: GoogleFonts.rubik(
                                                                                    fontSize: 11,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                          const SizedBox(
                                                                              height: 6),

                                                                          // Time
                                                                          Text(
                                                                            appointment.fromTime,
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[600],
                                                                            ),
                                                                          ),

                                                                          const SizedBox(
                                                                              height: 4),

                                                                          // Reason
                                                                          Text(
                                                                            "Reason : ${appointment.description}",
                                                                            style:
                                                                                GoogleFonts.rubik(
                                                                              fontSize: 12,
                                                                              color: Colors.grey[800],
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      )
                                                    : Center(
                                                        child: Text(
                                                            "No appointments match the selected filter."),
                                                      ),
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              })
                            ],
                          )),
                      SizedBox(
                        width: 40,
                      ),

                      /// Right section
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
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
                                                fontSize: Constant.TwentyHeight(
                                                    context),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 10),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 18),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? AppTheme
                                                          .lightPrimaryColor
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
                                                        DateFormat('E').format(
                                                            dates[index]),
                                                        style:
                                                            GoogleFonts.rubik(
                                                          // Text color changes only for selected item
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Constant
                                                              .smallbody(
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.rubik(
                                                        color: isSelected
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
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

                              ///chat section
                              Expanded(
                                child: Stack(
                                  children: [
                                    _buildPatientDetailsGrid(context),
                                    if (chatState != ChatState.hidden)
                                      _buildChatSection(context),
                                  ],
                                ),
                              ),

                              ///chart
                              // Replace your existing chart's Expanded widget with this Row.

                              // Expanded(
                              //   child: Row(
                              //     crossAxisAlignment:
                              //         CrossAxisAlignment.stretch,
                              //     children: [
                              //       Expanded(
                              //         flex: 2,
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             color: AppTheme.whiteTextColor,
                              //             borderRadius:
                              //                 BorderRadius.circular(22),
                              //           ),
                              //           padding: const EdgeInsets.all(16),
                              //           child: SfCartesianChart(
                              //             primaryXAxis: CategoryAxis(
                              //               placeLabelsNearAxisLine: false,
                              //               axisLine: const AxisLine(width: 0),
                              //               majorGridLines:
                              //                   const MajorGridLines(width: 0),
                              //             ),
                              //             primaryYAxis: NumericAxis(
                              //               minimum: 0,
                              //               maximum: 50,
                              //               interval: 10,
                              //               isVisible: true,
                              //               axisLine: const AxisLine(width: 0),
                              //               majorTickLines:
                              //                   const MajorTickLines(size: 5),
                              //             ),
                              //             tooltipBehavior: _tooltip,
                              //             series: <CartesianSeries<_ChartData,
                              //                 String>>[
                              //               ColumnSeries<_ChartData, String>(
                              //                 dataSource: data,
                              //                 xValueMapper:
                              //                     (_ChartData data, _) =>
                              //                         data.x,
                              //                 yValueMapper:
                              //                     (_ChartData data, _) =>
                              //                         data.y,
                              //                 name: 'Patient',
                              //                 color: const Color.fromRGBO(
                              //                     8, 142, 255, 1),
                              //                 borderRadius:
                              //                     const BorderRadius.all(
                              //                         Radius.circular(8)),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //
                              //       const SizedBox(
                              //           width:
                              //               20), // Spacing between the chart and the new card
                              //       Expanded(
                              //         child: Container(
                              //           decoration: BoxDecoration(
                              //             color: AppTheme.whiteTextColor,
                              //             borderRadius:
                              //                 BorderRadius.circular(22),
                              //           ),
                              //           padding: const EdgeInsets.symmetric(
                              //               horizontal: 20, vertical: 24),
                              //           child: Column(
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             mainAxisAlignment: MainAxisAlignment
                              //                 .center, // Center the content vertically
                              //             children: [
                              //               Text(
                              //                 "Follow Up",
                              //                 style: GoogleFonts.rubik(
                              //                   fontSize: 16,
                              //                   fontWeight: FontWeight.w500,
                              //                   color: Colors.grey.shade600,
                              //                 ),
                              //               ),
                              //               const SizedBox(height: 12),
                              //               Text(
                              //                 "15", // This can be a dynamic value from your controller
                              //                 style: GoogleFonts.rubik(
                              //                   fontSize: 48,
                              //                   fontWeight: FontWeight.w700,
                              //                   color:
                              //                       AppTheme.lightPrimaryColor,
                              //                 ),
                              //               ),
                              //               const Spacer(), // Pushes the bottom text down
                              //               Row(
                              //                 children: [
                              //                   const Icon(Icons.arrow_upward,
                              //                       color: Colors.green,
                              //                       size: 16),
                              //                   const SizedBox(width: 4),
                              //                   SizedBox(
                              //                     width: 40,
                              //                     child: Text(
                              //                       "+5 from last week",
                              //                       maxLines: 2,
                              //                       overflow:
                              //                           TextOverflow.ellipsis,
                              //                       style: GoogleFonts.rubik(
                              //                         fontSize: 12,
                              //                         color:
                              //                             Colors.grey.shade700,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ],
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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

  ///chat section

  Widget _buildPatientDetailsList(BuildContext context) {
    final controller = Get.find<Doctorcontroller>();
    return Container(
      height: 250, // Give it a fixed height
      decoration: BoxDecoration(
        color: AppTheme.whiteTextColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Patient Details",
              style: GoogleFonts.rubik(
                fontSize: Constant.TwentyHeight(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.patientGridData.length,
              itemBuilder: (context, index) {
                final patient = controller.patientGridData[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      alertPrint("Tapped on ${patient.name}");
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSection(BuildContext context) {
    final double chatHeight = chatState == ChatState.maximized
        ? MediaQuery.of(context).size.height * 0.6
        : 140.0;

    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: chatHeight,
        decoration: BoxDecoration(
          color: AppTheme.whiteTextColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  chatState = chatState == ChatState.maximized
                      ? ChatState.minimized
                      : ChatState.maximized;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Conversation",
                      style: GoogleFonts.rubik(
                        fontSize: Constant.TwentyHeight(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        chatState == ChatState.maximized
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            if (chatState == ChatState.maximized) const Divider(height: 1),
            if (chatState == ChatState.maximized)
              Expanded(
                child: Obx(() {
                  if (chatController.chatMessage.isEmpty) {
                    return const Center(child: Text("No messages yet."));
                  }
                  return ListView.builder(
                    controller: chatController.scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatController.chatMessage.length,
                    itemBuilder: (context, index) {
                      final msg = chatController.chatMessage[index];
                      final isDoctor = msg['sender'] == 'doctor';
                      return Align(
                        alignment: isDoctor
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                isDoctor ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg['text'].toString()),
                        ),
                      );
                    },
                  );
                }),
              ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatInputController,
                      decoration: InputDecoration(
                        hintText: "Tell me about your thoughts",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () {},
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.lightPrimaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            chatController.isAiSpeaking.value =
                                !chatController.isAiSpeaking.value;
                          });
                          if (chatController.isAiSpeaking.value) {
                            chatController.startVoiceSession();
                          } else {
                            chatController.stopVoiceSession();
                          }
                        },
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Colors.red.shade600;
      case 'improving':
        return Colors.green.shade600;
      case 'moderate':
        return Colors.orange.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  Widget _buildPatientDetailsGrid(BuildContext context) {
    final controller = Get.find<Doctorcontroller>();

    return Expanded(
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.47,
        decoration: BoxDecoration(
          color: AppTheme.whiteTextColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Patient Details",
              ),
            ),
            const Divider(height: 1, color: Color.fromRGBO(226, 226, 227, 1)),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: controller.patientGridData.length,
                itemBuilder: (context, index) {
                  final patient = controller.patientGridData[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Material(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          alertPrint("Tapped on ${patient.name}");
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                patient.name,
                                                style: GoogleFonts.rubik(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  color: _getProgressColor(
                                                      patient.progressLevel),
                                                ),
                                                child: Text(
                                                  patient.progressLevel,
                                                  style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            patient.symptom,
                                            style: GoogleFonts.rubik(
                                                color: Colors.grey.shade700,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            patient.condition,
                                            style: GoogleFonts.rubik(
                                                color: Colors.grey.shade700,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.message,
                                                  size: 18,
                                                  color: Colors.blueGrey,
                                                )),
                                            if (patient.messageCount > 0)
                                              Positioned(
                                                right: 4,
                                                top: 4,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade100,
                                                          width: 1.5)),
                                                  constraints:
                                                      const BoxConstraints(
                                                    minWidth: 10,
                                                    minHeight: 10,
                                                  ),
                                                  child: Text(
                                                    '${patient.messageCount}',
                                                    style: GoogleFonts.rubik(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.view_agenda_outlined,
                                              size: 18,
                                              color: Colors.blueGrey,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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

enum ChatState { hidden, minimized, maximized }
