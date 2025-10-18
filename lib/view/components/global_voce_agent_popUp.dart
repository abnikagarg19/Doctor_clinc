import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controller/chatController.dart';

class GlobalVoiceAgentPopup extends StatelessWidget {
  const GlobalVoiceAgentPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Obx(() {
      // Only build the widget if it's supposed to be visible
      if (!controller.isVoiceAgentVisible.value) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 20,
        right: 20,
        child: SlideTransition(
          position: controller.slideAnimation,
          child: Obx(() => controller.isVoiceAgentMinimized.value
              ? _buildMinimizedView(controller)
              : _buildMaximizedView(controller)),
        ),
      );
    });
  }

  Widget _buildMinimizedView(ChatController controller) {
    return GestureDetector(
      onTap: () => controller.toggleVoiceAgentMinimize(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }

  Widget _buildMaximizedView(ChatController controller) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("AI Voice Agent",
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      onPressed: () => controller.toggleVoiceAgentMinimize(),
                      tooltip: "Minimize",
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Live Transcript
                Obx(() => Text(
                      controller.voiceAgentTranscript.value.isEmpty
                          ? "Listening..."
                          : controller.voiceAgentTranscript.value,
                      style: GoogleFonts.rubik(
                          fontSize: 16, color: Colors.black87),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
