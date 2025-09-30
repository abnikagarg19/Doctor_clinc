import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPress;
  final bool isLoading;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? textSize;
  final Widget? child;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;
  const CustomButton({
    super.key,
    this.onPress,
    this.isLoading = false,
    this.text,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
    this.textSize = 16.0,
    this.child,
    this.elevation,
    this.padding,
    this.borderColor,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: elevation ?? 0,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: isLoading ? null : onPress,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(borderRadius ?? 13),
            color: backgroundColor,
          ),
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: isLoading
              ? Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.06,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor ?? Colors.white,
                    ),
                  ),
                )
              : (child ??
                  Text(
                    text ?? '',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: fontWeight ?? FontWeight.bold,
                      fontSize: textSize,
                    ),
                  )),
        ),
      ),
    );
  }
}
