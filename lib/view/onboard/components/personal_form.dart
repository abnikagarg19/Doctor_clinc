import 'package:chatbot/controller/signupController.dart';
import 'package:chatbot/utils/custom_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';

import '../../../components/dropdown.dart';
import '../../../components/input_field.dart' show MyTextField;
import 'label_common.dart';

class PersonalForm extends StatelessWidget {
  const PersonalForm({
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
          buildLable(context, "Full Name (as per medical registration)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.nameController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: "Enter your name",
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Date of Birth"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.dobController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              readOnly: true,
              ontap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1947),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  warningPrint("pickedDate $pickedDate");
                  controller.selectedDOB = pickedDate;
                  String formattedDateForDisplay =
                      DateFormat('dd/MMM/yyyy').format(pickedDate);
                  controller.dobController.text = formattedDateForDisplay;
                } else {
                  alertPrint("end from date is not selected");
                }
              },
              hintText: 'dd/MMM/yyyy',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Gender"),
          SizedBox(
            height: 8,
          ),
          GetBuilder<SignUpController>(builder: (cntrl) {
            return ReusableDropdown(
              listmap: cntrl.genderOptions,
              selectedItem: cntrl.gender,
              onChanged: (newValue) {
                if (newValue != null) {
                  cntrl.gender = newValue;
                  cntrl.update();
                }
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Choose One',
            );
          }),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Mobile Number"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.mobileController,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter your number',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Emergency Contact (optional)",
              isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.emergencyContactController,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              hintText: 'Enter your number',
              textInputType: TextInputType.phone,
              validation: (value) {
                // Regex for a valid Indian mobile number
                String pattern = r'^[6-9]\d{9}$';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid mobile number';
                }
                return null;
              },
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Email Address"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.emailController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (!value.contains('@')) {
                  return "@ is required";
                }
                return null;
              },
              hintText: 'Enter your email',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Address"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.addressController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter your  address',
              color: const Color(0xff585A60)),
        ],
      ),
    );
  }
}
