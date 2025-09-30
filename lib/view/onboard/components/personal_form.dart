import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/material.dart';
import '../../../components/dropdown.dart';
import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import 'label_common.dart';
import 'package:intl/intl.dart';

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
                  // }
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
                  print(pickedDate);
                  String formattedDate = DateFormat(
                    'dd/MMM/yyyy',
                  ).format(pickedDate);
                  print(formattedDate);
                  controller.dobController.text =
                      formattedDate; //set output date to TextField value.
                } else {
                  print("end from date is not selected");
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
          ReusableDropdown(
            /// items: controller.genderOptions,
            listmap: controller.genderOptions,

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
            hintText: 'Choose One',
          ),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Mobile Number (with OTP verification)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.mobileController,
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
          buildLable(context, "Emergency Contact (optional)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.emergencyContactController,
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
          buildLable(context, "Email Address (with OTP verification)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.emailController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
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
