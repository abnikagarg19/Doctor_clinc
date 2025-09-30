// import 'package:just_audio/just_audio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:rive/rive.dart' as riv;
// import 'package:rive/rive.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';

// class AiPage extends StatefulWidget {
//   AiPage({super.key});

//   @override
//   State<AiPage> createState() => _AiPageState();
// }

// class _AiPageState extends State<AiPage> {
//   var animationLink = 'assets/images/boothai.riv';
//   StateMachineController? stateMachineController;
//   Artboard? artboard;
//   SMIBool? isIdle;
//   late AudioPlayer _audioPlayer;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     rootBundle.load(animationLink).then((value) async {
//       await RiveFile.initialize();
//       final file = RiveFile.import(value);

//       final art = file.mainArtboard;
//       //use for controlling different actions
//       stateMachineController =
//           StateMachineController.fromArtboard(art, "State Machine 1");

//       if (stateMachineController != null) {
//         art.addController(stateMachineController!);

//         stateMachineController!.inputs.forEach((element) {
//           if (element.name == "idle") {
//             isIdle = element as SMIBool;
//           } else {
//             print(element.name);
//           }
//         });
//       }
//       artboard = art;
// //hands!.fire();
//       setState(() {});
//     });
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _playMusic();
//     });
//   }

//   Future<void> _playMusic() async {
//      await _audioPlayer.setAudioSource(AudioSource.file("assets/assets/images/audio.wav") // your song in assets/audio
//         );
//     await _audioPlayer.setVolume(0);
//     Future.delayed(
//       Duration(milliseconds: 300),
//     );

//     _playvulumeMusic();
//   }

//   Future<void> _playvulumeMusic() async {
//     _audioPlayer.setVolume(1.0);
//     await _audioPlayer.play();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 40),
//         width: double.infinity,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 80,
//             ),
//             if (artboard != null)
//               GestureDetector(
//                 onTap: () {
//                   _playMusic();
//                 },
//                 child: Container(
//                   height: 300,
//                   width: 300,
//                   child: riv.Rive(fit: BoxFit.cover, artboard: artboard!),
//                 ),
//               ),
//           SizedBox(
//               height: 20,
//             ),
//             // Typing animation
//            AnimatedTextKit(
//   isRepeatingAnimation: false,
//   animatedTexts: [
//     TyperAnimatedText(
//       "Take a gentle breath with me and notice how, in this moment, your body is already supporting you.",
//       textAlign: TextAlign.center,
//       textStyle: const TextStyle(
//         color: Color.fromRGBO(75, 75, 75, 1),
//         fontSize: 20,
//         fontFamily: "SWItal",
//       ),
//       curve: Curves.linear,
//       speed: const Duration(milliseconds: 58),
//     ),
//     TyperAnimatedText(
//       "You've faced these feelings before and made it through, let's explore the strength you used then so we can call on it again now.",
//       textAlign: TextAlign.center,
//       textStyle: const TextStyle(
//         color: Color.fromRGBO(75, 75, 75, 1),
//         fontSize: 20,
//         fontFamily: "SWItal",
//       ),
//       curve: Curves.linear,
//       speed: const Duration(milliseconds: 62),
//     ),
//   ],
// )

//             // Text(
//             //  "Take a gentle breath with me and notice how, in this moment, your body is already supporting you.",
//             //   style: TextStyle(
//             //     color: Color.fromRGBO(75, 75, 75, 1),
//             //     fontSize: 20,
//             //     fontFamily: "SWItal",
//             //   ),
//             //   textAlign: TextAlign.center,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';import 'package:ffmpeg_kit_flutter_new/log.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class AiPage extends StatefulWidget {
  @override
  _AudioVisualizerState createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AiPage>
    with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  final ffmpeg = FFmpegKit();
  double imageScale = 1.0;
  double _amplitude = 0.0;  double _phase = 0.0; // for wave movement
  Timer? waveTimer;

double frequency = 0.1; // How close waves are (higher = closer)
  Timer? timer;

  @override
  void initState() {
    super.initState();
    playAndAnimate();
  }

  Future<void> playAndAnimate() async {
    // Load and play the audio
    // FFmpeg command: decode audio to 16-bit PCM at 44100Hz mono
      final audioPath =  "assets/images/audio.wav"; // <-- change this
    final command =
        "-i $audioPath -f s16le -ac 1 -ar 44100 pipe:1"; // sends PCM to stdout

    FFmpegKit.executeAsync(command, (session) async {
      final returnCode = await session.getReturnCode();
      print("FFmpeg exited with code: $returnCode");
    }, (log) {
      print(log);
    },);

    // Simulate reading PCM chunks
    waveTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      // This part should read PCM buffer and calculate amplitude
      // For now, we simulate random amplitude
      setState(() {
        _amplitude = Random().nextDouble();
      });
    });
    await player.setAudioSource(AudioSource.file(
        "assets/assets/images/audio.wav")); // your song in assets/audio
    player.play();

    // Run FFmpeg to read amplitude data in real time
    // This is a workaround because just_audio does not expose raw samples
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      _amplitude = Random().nextDouble(); // Placeholder: use real FFT data here

     //  _amplitude = 0.5 + Random().nextDouble() * 0.5; // random height
        _phase += 0.2; // move wave horizontally
      setState(() {
        imageScale = 1.0 + _amplitude * 0.9; // Expand/shrink
      });
    });

    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        timer?.cancel();
        setState(() {
          imageScale = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          Center(
            child: AnimatedScale(
              scale: imageScale,
              duration: const Duration(milliseconds: 800),
              child: Image.asset(
                "assets/images/aicon.png",
                width: 200,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Center(
          //   child: CustomPaint(
          //   size: const Size(400, 200),
          //   painter: WavePainter( _amplitude, _phase, frequency),
          //           ),
          // ),
          SizedBox(
            height: 80,
          ),
          // Typing animation
          Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TyperAnimatedText(
                  "Take a gentle breath with me and notice how in this moment, your body is already supporting you.",
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    color: Color.fromRGBO(75, 75, 75, 1),
                    fontSize: 20,
                    fontFamily: "SWItal",
                  ),
                  curve: Curves.linear,
                  speed: const Duration(milliseconds: 58),
                ),
                TyperAnimatedText(
                  "You've faced these feelings before and made it through, let's explore the strength you used then so we can call on it again now.",
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                    color: Color.fromRGBO(75, 75, 75, 1),
                    fontSize: 20,
                    fontFamily: "SWItal",
                  ),
                  curve: Curves.linear,
                  speed: const Duration(milliseconds: 62),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double amplitude; // Current audio amplitude
  final double frequency;
  final double phase;

  WavePainter(this.amplitude, this.frequency, this.phase);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();

    // Increase height by multiplying amplitude
    double heightMultiplier = 50.0; // <-- Adjust this for taller waves

    for (double x = 0; x <= size.width; x++) {
      double y = size.height / 2 +
          sin((x * frequency) + phase) * amplitude * heightMultiplier;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
