import 'package:chatbot/controller/signupController.dart';
import 'package:flutter/material.dart';
import '../../../components/dropdown.dart';
import '../../../components/input_field.dart' show MyTextField;
import '../../../theme/apptheme.dart';
import 'label_common.dart';
import 'package:intl/intl.dart';

class ExperienceForm extends StatelessWidget {
  const ExperienceForm({
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
          buildLable(context, "Years of Practice"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.yearOfPracticeController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                  // }
                }
                return null;
              },
              hintText: "Enter your answer",
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context,
              "Primary Specialization (e.g., General Medicine, Pediatrics)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.specializationController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Enter your specialization',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Sub-specializations (if any)"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.subspecialtiesController,
              hintText: 'Enter if any',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Previous Hospitals / Clinics worked at"),
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
              hintText: 'Add all the places',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Languages Spoken"),
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
              hintText: 'Enter the languages',
              color: const Color(0xff585A60)),
          SizedBox(
            height: 20,
          ),
          buildLable(context, "Short Bio / Introduction"),
          SizedBox(
            height: 8,
          ),
          MyTextField(
              textEditingController: controller.shortBioController,
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              hintText: 'Type a short intro within 200 words',
              color: const Color(0xff585A60)),
        ],
      ),
    );
  }
}
