import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/dropdown.dart';
import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import 'label_common.dart';
import 'package:intl/intl.dart';

class ConsultationForm extends StatelessWidget {
  const ConsultationForm({
    super.key,
    required this.controller,
  });
  final SignUpController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          buildLable(context, "Available Days & Time"),
          SizedBox(
            height: 8,
          ),
          ReusableDropdown(
            /// items: controller.genderOptions,
            listmap: controller.selectedDays,

            selectedItem: "",
            onChanged: (newValue) {
              // setState(() {
              // controller.selectedValue = newValue!;
              // });
            },
            //  validation: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'Required';
            //       }
            //       return null;
            //     },
            hintText: 'Choose Slots',
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: MyTextField(
                    hintText: "Available from",
                    readOnly: true,
                    icon: const Icon(
                      CupertinoIcons.clock,
                      color: Color.fromRGBO(130, 130, 131, 1),
                    ),
                    textEditingController: controller.availableFromController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    ontap: () async {},
                    color: const Color(0xff585A60)),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: MyTextField(
                    hintText: "Available To",
                    readOnly: true,
                    icon: const Icon(
                      CupertinoIcons.clock,
                      color: Color.fromRGBO(130, 130, 131, 1),
                    ),
                    textEditingController: controller.availableToController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    ontap: () async {},
                    color: const Color(0xff585A60)),
              ),
            ],
          ), SizedBox(
            height: 20,
          ),
          buildLable(context, "Consultation Duration (e.g., 15 mins)"),
          SizedBox(
            height: 8,
          ),
          ReusableDropdown(
            /// items: controller.genderOptions,
            listmap: ["15 mints", "20 mints", "30 mints", "45 mints"],

            selectedItem: "",
            onChanged: (newValue) {
              // setState(() {
              // controller.selectedValue = newValue!;
              // });
            },
            //  validation: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'Required';
            //       }
            //       return null;
            //     },
            hintText: 'Select the time',
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Preferred Platform (in-app video, phone, etc.)"),
          SizedBox(
            height: 8,
          ),
          ReusableDropdown(
            /// items: controller.genderOptions,
            listmap: ["Online", "Ofline"],

            selectedItem: "",
            onChanged: (newValue) {
              // setState(() {
              // controller.selectedValue = newValue!;
              // });
            },
            //  validation: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'Required';
            //       }
            //       return null;
            //     },
            hintText: 'Select the option',
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Consultation Fee"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.consultationFeeController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter the fee',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Emergency Consultation Available? (Yes/No)"),
          SizedBox(
            height: 8,
          ),
          ReusableDropdown(
            /// items: controller.genderOptions,
            listmap: ["Yes", "No"],

            selectedItem: "",
            onChanged: (newValue) {
              // setState(() {
              // controller.selectedValue = newValue!;
              // });
            },
            //  validation: (value) {
            //       if (value == null || value.isEmpty) {
            //         return 'Required';
            //       }
            //       return null;
            //     },
            hintText: 'Select the option',
          ),
        ],
      ),
    );
  }
}
