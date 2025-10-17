import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import '../../../components/input_field.dart' show MyTextField;
import 'label_common.dart';

class OtherForm extends StatelessWidget {
  const OtherForm({
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
          buildLable(context, "LinkedIn Profile", isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.linkedinController,
              validation: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !GetUtils.isURL(value)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
              hintText: 'Provide the link',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Professional Website or Profile",
              isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.profWebsiteController,
              validation: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !GetUtils.isURL(value)) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
              hintText: 'Provide the link',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Reference from Another Doctor",
              isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.refDocController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Provide the link/Doc',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Any Awards / Recognitions", isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.awardController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Mention all of them',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Publications", isRequired: false),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.publicationsController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'If any..',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
