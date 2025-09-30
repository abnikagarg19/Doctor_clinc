import 'package:flutter/material.dart';

class ProgressWithIcon extends StatelessWidget {
  const ProgressWithIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.av_timer_outlined,
                size: 60,
              ),
              // you can replace
              Container(
                width: 100,
                height: 100,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 0.9,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20,),
        Text("Please Wait....")
      ],
    );
  }
}
