import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/material.dart';
import '../../../components/dropdown.dart';
import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import 'label_common.dart';
import 'package:intl/intl.dart';

class BankingForm extends StatelessWidget {
  const BankingForm({
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
          buildLable(context, "Account Holder Name"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.accHolderController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                  // }
                }
                return null;
              },
              hintText: "Enter your account no.",
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context,
              "Bank Name & Branch"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.bankNameController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter your bank branch',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Account Number"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.accNumberController,
              hintText: 'Enter the A/c number',
               validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "IFSC Code"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.ifscController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter the code',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "PAN Card Number (for TDS compliance)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.panCardController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter the PAN number ',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "GSTIN (if applicable)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.gstinController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter the number',
              color: const Color(0xff585A60)),
               SizedBox(
            height: 20,
          ),
          buildLable(context, "UPI ID (For faster payouts)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.upiIdController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter the UPI ID',
              color: const Color(0xff585A60)),
        ],
      ),
    );
  }
}
